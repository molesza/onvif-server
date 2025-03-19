#!/bin/bash

# First, combine all configuration files
echo "Combining all camera configurations..."
./combine-configs.sh

# Then start the onvif-server with the combined configuration
echo "Starting onvif-server with combined configuration..."
node main.js ./config.yaml
