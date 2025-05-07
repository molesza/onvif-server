#!/usr/bin/env node

const yaml = require('yaml');
const fs = require('fs');
const { spawn } = require('child_process');
const readline = require('readline');
const path = require('path');

// Create readline interface for user input
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

// Function to prompt user with a question and get response
function askQuestion(question) {
    return new Promise((resolve) => {
        rl.question(question, (answer) => {
            resolve(answer);
        });
    });
}

// Function to run a single camera and wait for user confirmation
async function runCamera(cameraConfig, index, total) {
    return new Promise((resolve) => {
        console.log(`\n========================================`);
        console.log(`Starting camera ${index + 1} of ${total}: ${cameraConfig.name}`);
        console.log(`MAC Address: ${cameraConfig.mac}`);
        console.log(`Server Port: ${cameraConfig.ports.server}`);
        console.log(`IP Address: ${getIpAddressFromMac(cameraConfig.mac) || 'Unknown'}`);
        console.log(`========================================\n`);

        // Create a temporary config file with just this camera
        const tempConfig = {
            onvif: [cameraConfig]
        };

        const tempConfigPath = path.join(__dirname, `temp-camera-${index + 1}.yaml`);
        fs.writeFileSync(tempConfigPath, yaml.stringify(tempConfig));

        // Start the camera process with the no-broadcast version
        const cameraProcess = spawn('node', ['main-no-broadcast.js', '--debug', tempConfigPath], {
            stdio: ['inherit', 'inherit', 'inherit']
        });

        // Handle process events
        cameraProcess.on('error', (err) => {
            console.error(`Error starting camera ${index + 1}: ${err.message}`);
            cleanup();
            resolve(false);
        });

        // Function to clean up temporary files and kill process
        const cleanup = () => {
            try {
                if (fs.existsSync(tempConfigPath)) {
                    fs.unlinkSync(tempConfigPath);
                }
                if (cameraProcess && !cameraProcess.killed) {
                    cameraProcess.kill();
                }
            } catch (err) {
                console.error(`Error during cleanup: ${err.message}`);
            }
        };

        // Ask user to confirm when camera is adopted
        const promptUser = async () => {
            try {
                console.log(`\nCamera ${index + 1} (${cameraConfig.name}) is running WITHOUT discovery broadcast.`);
                console.log(`To manually add this camera in Unifi Protect, use these details:`);
                console.log(`- IP Address: ${getIpAddressFromMac(cameraConfig.mac) || 'Unknown'}`);
                console.log(`- Port: ${cameraConfig.ports.server}`);
                console.log(`- Username: admin`);
                console.log(`- Password: Nespnp@123`);
                console.log(`- ONVIF Path: /onvif/device_service`);

                const answer = await askQuestion(
                    `\nType 'done' when adoption is complete, 'skip' to skip this camera, or 'quit' to exit: `
                );

                if (answer.toLowerCase() === 'done') {
                    console.log(`Camera ${index + 1} adoption confirmed!`);
                    cleanup();
                    resolve(true);
                } else if (answer.toLowerCase() === 'skip') {
                    console.log(`Skipping camera ${index + 1}`);
                    cleanup();
                    resolve(true);
                } else if (answer.toLowerCase() === 'quit') {
                    console.log('Exiting program...');
                    cleanup();
                    process.exit(0);
                } else {
                    console.log('Please type "done", "skip", or "quit"');
                    promptUser();
                }
            } catch (err) {
                console.error(`Error during user prompt: ${err.message}`);
                cleanup();
                resolve(false);
            }
        };

        // Start the user prompt
        promptUser();
    });
}

// Helper function to get IP address from MAC
function getIpAddressFromMac(macAddress) {
    try {
        const networkInterfaces = require('os').networkInterfaces();
        for (let interface in networkInterfaces) {
            for (let network of networkInterfaces[interface]) {
                if (network.family === 'IPv4' && network.mac.toLowerCase() === macAddress.toLowerCase()) {
                    return network.address;
                }
            }
        }
    } catch (err) {
        console.error(`Error getting IP address: ${err.message}`);
    }
    return null;
}

// Main function to run the script
async function main() {
    try {
        // Check if config file is provided
        if (process.argv.length < 3) {
            console.error('Please provide a config file path');
            console.error('Usage: node sequential-adoption-no-broadcast.js <config.yaml> [start_index]');
            console.error('  <config.yaml>: Path to the configuration file');
            console.error('  [start_index]: Optional camera index to start from (1-based, default: 1)');
            process.exit(1);
        }

        const configPath = process.argv[2];

        // Parse starting index (default to 1 if not provided)
        let startIndex = 1;
        if (process.argv.length >= 4) {
            const parsedIndex = parseInt(process.argv[3]);
            if (!isNaN(parsedIndex) && parsedIndex >= 1) {
                startIndex = parsedIndex;
            } else {
                console.error('Invalid start_index. Using default value of 1.');
            }
        }

        // Check if config file exists
        if (!fs.existsSync(configPath)) {
            console.error(`Config file not found: ${configPath}`);
            process.exit(1);
        }

        // Read and parse the config file
        const configData = fs.readFileSync(configPath, 'utf8');
        const config = yaml.parse(configData);

        if (!config.onvif || !Array.isArray(config.onvif) || config.onvif.length === 0) {
            console.error('Invalid config file: No cameras found in the configuration');
            process.exit(1);
        }

        console.log(`Found ${config.onvif.length} cameras in the configuration`);

        // Adjust startIndex to be 0-based for array indexing
        const startIndexZeroBased = startIndex - 1;

        if (startIndexZeroBased >= config.onvif.length) {
            console.error(`Error: Start index ${startIndex} is greater than the number of cameras (${config.onvif.length})`);
            process.exit(1);
        }

        // Ask user if they want to start the sequential adoption process
        const startAnswer = await askQuestion(
            `This script will start each camera one by one for adoption WITHOUT discovery broadcast.\n` +
            `Starting from camera ${startIndex} of ${config.onvif.length} (${config.onvif[startIndexZeroBased].name}).\n` +
            `You will need to manually add each camera in Unifi Protect using its IP and port.\n` +
            `Make sure your virtual network interfaces are properly set up.\n` +
            `Do you want to continue? (yes/no): `
        );

        if (startAnswer.toLowerCase() !== 'yes') {
            console.log('Exiting program...');
            process.exit(0);
        }

        console.log(`Starting from camera ${startIndex} of ${config.onvif.length}`);

        // Process each camera sequentially, starting from the specified index
        for (let i = startIndexZeroBased; i < config.onvif.length; i++) {
            const cameraConfig = config.onvif[i];

            // Check if MAC address is properly set
            if (cameraConfig.mac === '<ONVIF PROXY MAC ADDRESS HERE>') {
                console.warn(`Warning: Camera ${i + 1} (${cameraConfig.name}) has a placeholder MAC address`);
                const continueAnswer = await askQuestion('Do you want to continue with this camera? (yes/no): ');
                if (continueAnswer.toLowerCase() !== 'yes') {
                    console.log(`Skipping camera ${i + 1}`);
                    continue;
                }
            }

            // Run the camera and wait for user confirmation
            await runCamera(cameraConfig, i, config.onvif.length);
        }

        console.log('\n========================================');
        console.log('All cameras have been processed!');
        console.log('========================================\n');
    } catch (err) {
        console.error(`Error: ${err.message}`);
        process.exit(1);
    } finally {
        rl.close();
    }
}

// Start the script
main();
