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
        console.log(`========================================\n`);

        // Create a temporary config file with just this camera
        const tempConfig = {
            onvif: [cameraConfig]
        };

        const tempConfigPath = path.join(__dirname, `temp-camera-${index + 1}.yaml`);
        fs.writeFileSync(tempConfigPath, yaml.stringify(tempConfig));

        // Start the camera process with debug mode
        const cameraProcess = spawn('node', ['main.js', '--debug', tempConfigPath], {
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
                const answer = await askQuestion(
                    `\nCamera ${index + 1} (${cameraConfig.name}) is running.\n` +
                    `Please adopt this camera in Unifi Protect.\n` +
                    `Type 'done' when adoption is complete, 'skip' to skip this camera, or 'quit' to exit: `
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

// Main function to run the script
async function main() {
    try {
        // Check if config file is provided
        if (process.argv.length < 3) {
            console.error('Please provide a config file path');
            console.error('Usage: node sequential-adoption.js <config.yaml>');
            process.exit(1);
        }

        const configPath = process.argv[2];

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

        // Ask user if they want to start the sequential adoption process
        const startAnswer = await askQuestion(
            'This script will start each camera one by one for adoption.\n' +
            'Make sure your virtual network interfaces are properly set up.\n' +
            'Do you want to continue? (yes/no): '
        );

        if (startAnswer.toLowerCase() !== 'yes') {
            console.log('Exiting program...');
            process.exit(0);
        }

        // Process each camera sequentially
        for (let i = 0; i < config.onvif.length; i++) {
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
