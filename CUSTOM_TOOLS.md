# Custom ONVIF Server Tools

This document describes the custom tools and scripts created to enhance the functionality of the ONVIF server.

## Table of Contents

1. [Sequential Adoption Script](#sequential-adoption-script)
2. [No-Broadcast Mode](#no-broadcast-mode)
3. [MAC Address and YAML Configuration Tools](#mac-address-and-yaml-configuration-tools)
4. [Usage Examples](#usage-examples)
5. [Troubleshooting](#troubleshooting)

## Sequential Adoption Script

The sequential adoption script (`sequential-adoption.js`) allows you to start each camera one at a time, wait for it to be adopted in Unifi Protect, and then move on to the next camera. This helps avoid port conflicts and discovery issues when dealing with multiple cameras.

### Features

- Starts one camera at a time from your configuration file
- Prompts for user confirmation after each camera is adopted
- Automatically cleans up temporary files
- Provides options to skip problematic cameras or quit the process

### Usage

```bash
node sequential-adoption.js <config.yaml>
```

### How It Works

1. Reads your YAML configuration file
2. For each camera in the configuration:
   - Creates a temporary configuration file with just that camera
   - Starts the ONVIF server for just that camera
   - Prompts you to adopt the camera in Unifi Protect
   - Waits for your confirmation
   - Stops the camera and moves to the next one

## No-Broadcast Mode

The no-broadcast mode provides a way to run the ONVIF server without broadcasting discovery messages. This is useful when you want to manually add cameras to your NVR or when you're experiencing issues with the discovery process.

### Files

- `main-no-broadcast.js`: Modified version of main.js without discovery broadcasting
- `src/onvif-server-no-broadcast.js`: Modified version of onvif-server.js with discovery functionality removed
- `sequential-adoption-no-broadcast.js`: Sequential adoption script that uses the no-broadcast versions

### Usage

To run a single configuration file without broadcasting:

```bash
node main-no-broadcast.js <config.yaml>
```

To run the sequential adoption process without broadcasting:

```bash
node sequential-adoption-no-broadcast.js <config.yaml>
```

### Manual Camera Addition

When using the no-broadcast mode, you'll need to manually add each camera in your NVR using:

- IP Address: (The IP of the virtual interface)
- Port: (The server port from the configuration, typically 8081, 8082, etc.)
- Username: (Same as your physical camera/NVR)
- Password: (Same as your physical camera/NVR)
- ONVIF Path: /onvif/device_service

## MAC Address and YAML Configuration Tools

### MAC YAML Inserter

The `mac_yaml_inserter.sh` script automatically inserts MAC addresses from your network interfaces into your YAML configuration file.

#### Usage

```bash
./mac_yaml_inserter.sh <yaml_file>
```

#### Features

- Finds all network interfaces with MAC addresses matching the pattern `a2:a2:a2:a2:a2:*`
- Replaces `<ONVIF PROXY MAC ADDRESS HERE>` placeholders in your YAML file
- Creates a backup of your original file

### Create MacVLAN Script

The `create_macvlan.sh` script creates virtual network interfaces with specific MAC addresses for your ONVIF cameras.

#### Usage

```bash
./create_macvlan.sh <number_of_interfaces> [parent_interface]
```

#### Features

- Creates the specified number of virtual interfaces
- Assigns sequential MAC addresses (a2:a2:a2:a2:a2:01, a2:a2:a2:a2:a2:02, etc.)
- Uses the specified parent interface (defaults to eth0)
- Brings up the interfaces and assigns IP addresses

## Usage Examples

### Complete Setup Process

1. Create virtual network interfaces:
   ```bash
   sudo ./create_macvlan.sh 16 eth0
   ```

2. Generate a configuration file:
   ```bash
   node main.js --create-config
   ```

3. Insert MAC addresses into the configuration:
   ```bash
   ./mac_yaml_inserter.sh config.yaml
   ```

4. Adopt cameras sequentially without broadcasting:
   ```bash
   node sequential-adoption-no-broadcast.js config.yaml
   ```

5. Run all cameras without broadcasting:
   ```bash
   node main-no-broadcast.js config.yaml
   ```

### Running with Discovery (Original Method)

If you prefer to use the discovery broadcasting:

1. Adopt cameras sequentially:
   ```bash
   node sequential-adoption.js config.yaml
   ```

2. Run all cameras:
   ```bash
   node main.js config.yaml
   ```

## Troubleshooting

### Authentication Issues

If you're experiencing authentication issues:

1. Try using the no-broadcast mode and manually add the cameras
2. Verify that the credentials are correct
3. Check network connectivity between the virtual interfaces and the physical camera/NVR

### Port Conflicts

If you're experiencing port conflicts:

1. Use the sequential adoption script to adopt one camera at a time
2. Make sure no other services are using the same ports
3. Check if any previous instances of the ONVIF server are still running

### Discovery Issues

If cameras aren't being discovered:

1. Check if the virtual network interfaces are properly set up
2. Verify that the MAC addresses in the configuration match the interfaces
3. Try using the no-broadcast mode and manually add the cameras

### Multiple Cameras Showing Same Stream

If multiple cameras are showing the same video stream:

1. Run these commands to fix ARP issues:
   ```bash
   sudo sysctl -w net.ipv4.conf.all.arp_ignore=1
   sudo sysctl -w net.ipv4.conf.all.arp_announce=2
   ```

2. Make sure each camera has a unique MAC address in the configuration
