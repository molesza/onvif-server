#!/usr/bin/env node

const yaml = require('yaml');
const fs = require('fs');
const path = require('path');

/**
 * Merges NVR configurations while preserving existing camera settings
 * and incrementally adding new ones with adjusted ports and MAC addresses.
 * Ensures only one RTSP/Snapshot proxy port pair per target NVR.
 */
function mergeNvrConfigs(combinedConfigPath, newConfigPath) {
    console.log(`Merging ${newConfigPath} into ${combinedConfigPath}...`);

    // Extract NVR IP from filename (e.g., "192.168.6.202.yaml" -> "202")
    const nvrIpSuffix = path.basename(newConfigPath, '.yaml').split('.').pop();
    console.log(`Detected NVR IP suffix: ${nvrIpSuffix}`);

    // Special handling for the first NVR (192.168.6.201.yaml)
    // If this is the first NVR and we're creating the combined file, just copy it directly
    if (!fs.existsSync(combinedConfigPath) && newConfigPath === '192.168.6.201.yaml') {
        console.log(`This is the first NVR (${newConfigPath}). Creating combined config by direct copy.`);
        fs.copyFileSync(newConfigPath, combinedConfigPath);
        console.log(`Created ${combinedConfigPath} as an exact copy of ${newConfigPath}`);
        return;
    }

    // --- Read Configurations ---
    let combinedConfig;
    if (fs.existsSync(combinedConfigPath)) {
        console.log(`Reading existing combined config from ${combinedConfigPath}`);
        try {
            const combinedConfigData = fs.readFileSync(combinedConfigPath, 'utf8');
            combinedConfig = yaml.parse(combinedConfigData);
            // Ensure combinedConfig.onvif is an array
            if (!combinedConfig || typeof combinedConfig !== 'object') combinedConfig = { onvif: [] };
            if (!Array.isArray(combinedConfig.onvif)) combinedConfig.onvif = [];
        } catch (e) {
            console.error(`Error parsing existing combined config ${combinedConfigPath}: ${e.message}`);
            process.exit(1);
        }
    } else {
        console.error(`Error: Combined config file ${combinedConfigPath} does not exist.`);
        console.error(`Please run the script first with 192.168.6.201.yaml to create the initial combined config.`);
        process.exit(1);
    }

    console.log(`Reading new NVR config from ${newConfigPath}`);
    const newConfigData = fs.readFileSync(newConfigPath, 'utf8');
    const newConfig = yaml.parse(newConfigData);

    // Ensure the new config has the onvif array
    if (!newConfig.onvif || !Array.isArray(newConfig.onvif)) {
        console.error('Error: Invalid new config format. Missing or invalid onvif array.');
        process.exit(1);
    }

    // --- Analyze Existing Config for Highest Values and Proxy Ports Per NVR ---
    let highestServerPort = 8080; // Start with a base value below expected range
    let highestMacSuffix = 0;     // For MAC addresses like a2:a2:a2:a2:a2:XX
    const nvrProxyPorts = {}; // Stores { 'targetNVR': { rtsp: port, snapshot: port } }
    let currentHighestRtspPort = 8553;   // Start below expected range
    let currentHighestSnapshotPort = 8579; // Start below expected range

    combinedConfig.onvif.forEach(camera => {
        // Track highest server port
        if (camera.ports && camera.ports.server && camera.ports.server > highestServerPort) {
            highestServerPort = camera.ports.server;
        }

        // Track highest MAC suffix
        if (camera.mac) {
            const macParts = camera.mac.split(':');
            if (macParts.length === 6) {
                const macSuffix = parseInt(macParts[5], 16);
                if (!isNaN(macSuffix) && macSuffix > highestMacSuffix) {
                    highestMacSuffix = macSuffix;
                }
            }
        }

        // Track highest proxy ports and map them to NVRs
        if (camera.target && camera.target.hostname && camera.ports && camera.ports.rtsp && camera.ports.snapshot) {
            const targetNVR = camera.target.hostname;
            const rtspPort = camera.ports.rtsp;
            const snapshotPort = camera.ports.snapshot;

            if (!nvrProxyPorts[targetNVR]) {
                nvrProxyPorts[targetNVR] = { rtsp: rtspPort, snapshot: snapshotPort };
                if (rtspPort > currentHighestRtspPort) {
                    currentHighestRtspPort = rtspPort;
                }
                if (snapshotPort > currentHighestSnapshotPort) {
                    currentHighestSnapshotPort = snapshotPort;
                }
            } else {
                // Verify consistency if NVR already seen
                if (nvrProxyPorts[targetNVR].rtsp !== rtspPort || nvrProxyPorts[targetNVR].snapshot !== snapshotPort) {
                    console.warn(`Warning: Inconsistent proxy ports found for NVR ${targetNVR} in existing config. Using first found ports (${nvrProxyPorts[targetNVR].rtsp}, ${nvrProxyPorts[targetNVR].snapshot}).`);
                }
            }
        }
    });

    console.log(`Initial Highest server port found: ${highestServerPort}`);
    console.log(`Initial Highest RTSP port found: ${currentHighestRtspPort}`);
    console.log(`Initial Highest snapshot port found: ${currentHighestSnapshotPort}`);
    console.log(`Initial Highest MAC suffix found: 0x${highestMacSuffix.toString(16)}`);
    console.log(`Initial NVR Proxy Ports Map:`, nvrProxyPorts);

    // --- Process New Cameras ---
    const newCamerasToAdd = [];
    let assignedNewRtspPort = -1;
    let assignedNewSnapshotPort = -1;
    let newNvrTarget = null; // Track the target NVR for the *current* new file

    newConfig.onvif.forEach((camera, index) => {
        // Create a deep copy
        const newCamera = JSON.parse(JSON.stringify(camera));
        const targetNVR = newCamera.target?.hostname;

        if (!targetNVR) {
            console.warn(`Skipping camera at index ${index} in ${newConfigPath} due to missing target hostname.`);
            return; // Skip this camera
        }

        // **Assign Proxy Ports (RTSP/Snapshot) - Only once per new NVR target**
        if (!nvrProxyPorts[targetNVR]) {
            // This is the first time we see this target NVR in this merge operation
            if (assignedNewRtspPort === -1) { // Only increment if we haven't assigned ports for this new file yet
                currentHighestRtspPort++;
                currentHighestSnapshotPort++;
                assignedNewRtspPort = currentHighestRtspPort;
                assignedNewSnapshotPort = currentHighestSnapshotPort;
                newNvrTarget = targetNVR; // Remember which NVR these ports belong to
                console.log(`Assigning new proxy ports for NVR ${targetNVR}: RTSP=${assignedNewRtspPort}, Snapshot=${assignedNewSnapshotPort}`);
                nvrProxyPorts[targetNVR] = { rtsp: assignedNewRtspPort, snapshot: assignedNewSnapshotPort };
            } else if (targetNVR !== newNvrTarget) {
                // Error: The new config file contains cameras pointing to different target NVRs.
                // This script currently assumes one target NVR per input file for simplicity in port assignment.
                console.error(`Error: Configuration file ${newConfigPath} contains cameras pointing to different target NVRs (${newNvrTarget} and ${targetNVR}). Please ensure each input YAML file corresponds to only one target NVR.`);
                process.exit(1);
            }
            // Assign the newly determined ports for this NVR
            newCamera.ports.rtsp = assignedNewRtspPort;
            newCamera.ports.snapshot = assignedNewSnapshotPort;
        } else {
            // Target NVR already exists in the combined config or was previously processed from this file
            console.log(`Using existing proxy ports for NVR ${targetNVR}: RTSP=${nvrProxyPorts[targetNVR].rtsp}, Snapshot=${nvrProxyPorts[targetNVR].snapshot}`);
            newCamera.ports.rtsp = nvrProxyPorts[targetNVR].rtsp;
            newCamera.ports.snapshot = nvrProxyPorts[targetNVR].snapshot;
        }

        // **Assign Server Port and MAC Address - Unique per camera**
        highestServerPort++;
        highestMacSuffix++;

        newCamera.ports.server = highestServerPort;

        const macPrefix = 'a2:a2:a2:a2:a2';
        const macSuffixHex = highestMacSuffix.toString(16).padStart(2, '0');
        newCamera.mac = `${macPrefix}:${macSuffixHex}`;

        // **Assign Name**
        const channelNumber = index + 1; // Use index from the *new* file
        newCamera.name = `NVR${nvrIpSuffix}-CH${channelNumber}`;

        console.log(`Processed camera: ${newCamera.name} (Server Port: ${newCamera.ports.server}, RTSP Proxy Port: ${newCamera.ports.rtsp}, Snapshot Proxy Port: ${newCamera.ports.snapshot}, MAC: ${newCamera.mac})`);

        newCamerasToAdd.push(newCamera);
    });

    // --- Combine and Write Output ---
    combinedConfig.onvif = combinedConfig.onvif.concat(newCamerasToAdd);

    console.log(`Writing combined config to ${combinedConfigPath}`);
    fs.writeFileSync(combinedConfigPath, yaml.stringify(combinedConfig, { indent: 2 })); // Added indentation

    console.log(`Successfully merged ${newCamerasToAdd.length} cameras from ${newConfigPath} into ${combinedConfigPath}`);
    console.log(`Total cameras in combined config: ${combinedConfig.onvif.length}`);
}

// Main execution
if (process.argv.length < 4) {
    console.error('Usage: node merge-nvr-configs.js <combined-config.yaml> <new-config.yaml>');
    process.exit(1);
}

const combinedConfigPath = process.argv[2];
const newConfigPath = process.argv[3];

mergeNvrConfigs(combinedConfigPath, newConfigPath);
