# Onvif Server Setup for Liquor Store Cameras

This document provides instructions for setting up the virtual Onvif server for your 16 cameras from the NVR at 192.168.0.207.

## Overview

The configuration includes:
- 16 virtual Onvif devices, one for each camera channel
- Each virtual device has its own MAC address and will request an IP via DHCP
- Each virtual device exposes both high-quality and low-quality streams

## Files

- `config.yaml`: Configuration file for all 16 camera channels
- `setup.sh`: Script to create virtual network interfaces with unique MAC addresses
- `start-onvif-server.sh`: Script to run the setup and start the onvif-server

## Running the Setup

1. First, make sure you have the required dependencies installed:
   ```bash
   npm install
   ```

2. Run the setup script to create the virtual network interfaces:
   ```bash
   sudo ./setup.sh
   ```
   This will:
   - Create 16 virtual network interfaces with unique MAC addresses
   - Configure them to request IP addresses via DHCP
   - Set system settings to prevent MAC address conflicts

3. Start the onvif-server:
   ```bash
   node main.js ./config.yaml
   ```

Alternatively, you can use the all-in-one startup script:
```bash
sudo ./start-onvif-server.sh
```

## Setting Up Automatic Startup on Boot

To make the onvif-server start automatically when your system boots:

1. Edit the crontab:
   ```bash
   crontab -e
   ```

2. Add the following line:
   ```
   @reboot /home/molesza/onvif-server/start-onvif-server.sh > /home/molesza/onvif-server/startup.log 2>&1
   ```

3. Save and exit.

## Unifi Protect Configuration

1. In your Unifi router, set up static IP reservations for each of the MAC addresses:
   - a2:a2:a2:a2:a2:a1 (Camera 1 - Liquor Str Back Entrance Passage)
   - a2:a2:a2:a2:a2:a2 (Camera 2 - Liquor Store Main Chiller)
   - a2:a2:a2:a2:a2:a3 (Camera 3 - Liquor Wine Section)
   - a2:a2:a2:a2:a2:a4 (Camera 4 - Liquor Receiving)
   - a2:a2:a2:a2:a2:a5 (Camera 5 - Liquor Tillpoint Overview)
   - a2:a2:a2:a2:a2:a6 (Camera 6 - Liquor Tillpoint Side View)
   - a2:a2:a2:a2:a2:a7 (Camera 7 - Liquor Side Fridge Bck View)
   - a2:a2:a2:a2:a2:a8 (Camera 8 - Liquor Main Chiller Bck Overvi)
   - a2:a2:a2:a2:a2:a9 (Camera 9 - Liquor Cooldrinks Glassware)
   - a2:a2:a2:a2:a2:b1 (Camera 10 - Liquor Rum Vodka etc)
   - a2:a2:a2:a2:a2:b2 (Camera 11 - Outside Storeroom Passage 2)
   - a2:a2:a2:a2:a2:b3 (Camera 12 - Outside Storeroom Passage 1)
   - a2:a2:a2:a2:a2:b4 (Camera 13 - PARKING BACK OVERVIEW)
   - a2:a2:a2:a2:a2:b5 (Camera 14 - Outside Storeroom Passage 3)
   - a2:a2:a2:a2:a2:b6 (Camera 15 - OUTSIDE STOREROOM 1 A)
   - a2:a2:a2:a2:a2:b7 (Camera 16 - OUTSIDE STOREROOM 2 A)

2. In Unifi Protect, add each camera as an Onvif device using the IP address assigned to each MAC address.
   - The username and password are the same as your original NVR: admin/Nespnp@123

## Troubleshooting

- **All cameras show the same video stream in Unifi Protect**
  - Make sure the system settings are properly set:
    ```bash
    sudo sysctl -w net.ipv4.conf.all.arp_ignore=1
    sudo sysctl -w net.ipv4.conf.all.arp_announce=2
    ```

- **Error: Wsse authorized time check failed.**
  - Try updating the date/time on your Onvif device to the current time.

- **I only see snapshots, no live-stream.**
  - Check if you're capturing the RTSP streams elsewhere already. You might have hit the maximum concurrent RTSP streams that your camera supports.
  - Ensure your NVR encodes videos with h264, as Unifi Protect only supports h264 video streams.

- **Virtual interfaces not getting IP addresses**
  - Check if dhclient is installed: `which dhclient`
  - If not, install it: `sudo apt-get install isc-dhcp-client`
  - Check your DHCP server logs to see if it's receiving requests from the virtual interfaces
