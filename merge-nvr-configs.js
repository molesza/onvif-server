#!/usr/bin/env node

const yaml = require('yaml');
const fs = require('fs');
const path = require('path');

/**
 * Merges NVR configurations while preserving existing camera settings
 * and incrementally adding new ones with adjusted ports and MAC addresses.
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

    // Read the combined config file
    let combinedConfig;
    if (fs.existsSync(combinedConfigPath)) {
        console.log(`Reading existing combined config from ${combinedConfigPath}`);
        const combinedConfigData = fs.readFileSync(combinedConfigPath, 'utf8');
        combinedConfig = yaml.parse(combinedConfigData);
    } else {
        console.error(`Error: Combined config file ${combinedConfigPath} does not exist.`);
        console.error(`Please run the script first with 192.168.6.201.yaml to create the initial combined config.`);
        process.exit(1);
    }

    // Read the new NVR config
    console.log(`Reading new NVR config from ${newConfigPath}`);
    const newConfigData = fs.readFileSync(newConfigPath, 'utf8');
    const newConfig = yaml.parse(newConfigData);

    // Ensure the combined config has the onvif array
    if (!combinedConfig.onvif || !Array.isArray(combinedConfig.onvif)) {
        console.error('Error: Invalid combined config format. Missing onvif array.');
        process.exit(1);
    }

    // Ensure the new config has the onvif array
    if (!newConfig.onvif || !Array.isArray(newConfig.onvif)) {
        console.error('Error: Invalid new config format. Missing onvif array.');
        process.exit(1);
    }

    // Find the highest server port, last MAC address, etc.
    let highestServerPort = 8080; // Start with a base value
    let highestRtspPort = 8553;   // Start with a base value
    let highestSnapshotPort = 8579; // Start with a base value
    let highestMacSuffix = 0;     // For MAC addresses like a2:a2:a2:a2:a2:XX

    // Analyze existing cameras
    combinedConfig.onvif.forEach(camera => {
        // Check server port
        if (camera.ports && camera.ports.server && camera.ports.server > highestServerPort) {
            highestServerPort = camera.ports.server;
        }

        // Check RTSP port
        if (camera.ports && camera.ports.rtsp && camera.ports.rtsp > highestRtspPort) {
            highestRtspPort = camera.ports.rtsp;
        }

        // Check snapshot port
        if (camera.ports && camera.ports.snapshot && camera.ports.snapshot > highestSnapshotPort) {
            highestSnapshotPort = camera.ports.snapshot;
        }

        // Check MAC address suffix
        if (camera.mac) {
            const macParts = camera.mac.split(':');
            if (macParts.length === 6) {
                const macSuffix = parseInt(macParts[5], 16);
                if (!isNaN(macSuffix) && macSuffix > highestMacSuffix) {
                    highestMacSuffix = macSuffix;
                }
            }
        }
    });

    console.log(`Highest server port found: ${highestServerPort}`);
    console.log(`Highest RTSP port found: ${highestRtspPort}`);
    console.log(`Highest snapshot port found: ${highestSnapshotPort}`);
    console.log(`Highest MAC suffix found: 0x${highestMacSuffix.toString(16)}`);

    // Process new cameras and adjust their settings
    const newCameras = newConfig.onvif.map((camera, index) => {
        // Create a copy of the camera config
        const newCamera = JSON.parse(JSON.stringify(camera));

        // Increment ports
        highestServerPort++;
        highestRtspPort++;
        highestSnapshotPort++;
        highestMacSuffix++;

        // Update ports
        newCamera.ports.server = highestServerPort;
        newCamera.ports.rtsp = highestRtspPort;
        newCamera.ports.snapshot = highestSnapshotPort;

        // Update MAC address
        const macPrefix = 'a2:a2:a2:a2:a2';
        const macSuffix = highestMacSuffix.toString(16).padStart(2, '0');
        newCamera.mac = `${macPrefix}:${macSuffix}`;

        // Keep the original UUID - no need to generate a new one
        // The chance of UUID conflicts is practically zero

        // Update name using NVR*-CH* format
        const channelNumber = index + 1;
        newCamera.name = `NVR${nvrIpSuffix}-CH${channelNumber}`;

        console.log(`Processed camera: ${newCamera.name} (Port: ${newCamera.ports.server}, MAC: ${newCamera.mac})`);

        return newCamera;
    });

    // Add new cameras to the combined config
    combinedConfig.onvif = combinedConfig.onvif.concat(newCameras);

    // Write the combined config back to file
    console.log(`Writing combined config to ${combinedConfigPath}`);
    fs.writeFileSync(combinedConfigPath, yaml.stringify(combinedConfig));

    console.log(`Successfully merged ${newCameras.length} cameras from ${newConfigPath} into ${combinedConfigPath}`);
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
