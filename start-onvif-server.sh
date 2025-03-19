#!/bin/bash

# This script runs the setup and starts the onvif-server
# It can be added to crontab with @reboot to start automatically on boot

# Change to the onvif-server directory
cd "$(dirname "$0")"

# Run the setup script to create virtual network interfaces
echo "Setting up virtual network interfaces..."
sudo ./setup.sh

# Wait for DHCP to assign IP addresses (adjust time if needed)
echo "Waiting for DHCP to assign IP addresses..."
sleep 10

# Start the onvif-server
echo "Starting onvif-server..."
node main.js ./config.yaml
