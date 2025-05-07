# Custom ONVIF Server Tools

This document describes the custom tools and scripts created to enhance the functionality of the ONVIF server.

## Table of Contents

1. [Sequential Adoption Script](#sequential-adoption-script)
2. [No-Broadcast Mode](#no-broadcast-mode)
3. [NVR Configuration Merger](#nvr-configuration-merger)
4. [MAC Address and YAML Configuration Tools](#mac-address-and-yaml-configuration-tools)
5. [Usage Examples](#usage-examples)
6. [Troubleshooting](#troubleshooting)

## Sequential Adoption Script

The sequential adoption script (`sequential-adoption.js`) allows you to start each camera one at a time, wait for it to be adopted in Unifi Protect, and then move on to the next camera. This helps avoid port conflicts and discovery issues when dealing with multiple cameras.

### Features

- Starts one camera at a time from your configuration file
- Prompts for user confirmation after each camera is adopted
- Automatically cleans up temporary files
- Provides options to skip problematic cameras or quit the process

### Usage

```bash
node sequential-adoption.js <config.yaml> [start_index]
```

Where:
- `<config.yaml>`: Path to the configuration file
- `[start_index]`: Optional camera index to start from (1-based, default: 1)

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
node sequential-adoption-no-broadcast.js <config.yaml> [start_index]
```

Where:
- `<config.yaml>`: Path to the configuration file
- `[start_index]`: Optional camera index to start from (1-based, default: 1)

### Manual Camera Addition

When using the no-broadcast mode, you'll need to manually add each camera in your NVR using:

- IP Address: (The IP of the virtual interface)
- Port: (The server port from the configuration, typically 8081, 8082, etc.)
- Username: (Same as your physical camera/NVR)
- Password: (Same as your physical camera/NVR)
- ONVIF Path: /onvif/device_service

## NVR Configuration Merger

The NVR Configuration Merger (`merge-nvr-configs.js`) allows you to combine multiple NVR YAML configuration files into a single combined configuration file. This is useful when you have multiple NVRs and want to run them all from a single ONVIF server instance.

### Features

- Preserves existing camera configurations exactly as they are
- Incrementally adds new cameras with adjusted ports and MAC addresses
- Automatically resolves port conflicts
- Uses a consistent naming convention (NVR*-CH*)
- Maintains the same configuration structure

### Usage

```bash
node merge-nvr-configs.js <combined-config.yaml> <new-config.yaml>
```

### How It Works

1. For the first NVR (typically 192.168.6.201.yaml):
   - Creates an exact copy as the combined configuration file
   - Preserves all settings exactly as they are

2. For subsequent NVRs:
   - Reads the existing combined configuration
   - Analyzes the highest port numbers and MAC addresses in use
   - Adjusts the new cameras' configurations to avoid conflicts
   - Adds the new cameras to the combined configuration

3. The script ensures:
   - Server ports are incremented sequentially
   - RTSP and snapshot ports are incremented
   - MAC addresses are unique
   - Camera names follow the NVR*-CH* convention (e.g., NVR202-CH1)

### Example

```bash
# First, create the combined config from the first NVR
node merge-nvr-configs.js combined-nvr.yaml 192.168.6.201.yaml

# Then add the second NVR
node merge-nvr-configs.js combined-nvr.yaml 192.168.6.202.yaml

# Add more NVRs as needed
node merge-nvr-configs.js combined-nvr.yaml 192.168.6.204.yaml
```

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

2. Generate a configuration file for each NVR:
   ```bash
   node main.js --create-config
   # Enter NVR details (e.g., 192.168.6.201)
   # Save as 192.168.6.201.yaml

   node main.js --create-config
   # Enter NVR details (e.g., 192.168.6.202)
   # Save as 192.168.6.202.yaml
   ```

3. Insert MAC addresses into the configurations:
   ```bash
   ./mac_yaml_inserter.sh 192.168.6.201.yaml
   ./mac_yaml_inserter.sh 192.168.6.202.yaml
   ```

4. Create a combined configuration:
   ```bash
   node merge-nvr-configs.js combined-nvr.yaml 192.168.6.201.yaml
   node merge-nvr-configs.js combined-nvr.yaml 192.168.6.202.yaml
   ```

5. Adopt cameras sequentially without broadcasting:
   ```bash
   # Start from the beginning (camera 1)
   node sequential-adoption-no-broadcast.js combined-nvr.yaml

   # Or start from a specific camera (e.g., camera 33)
   node sequential-adoption-no-broadcast.js combined-nvr.yaml 33
   ```

6. Run all cameras without broadcasting:
   ```bash
   node main-no-broadcast.js combined-nvr.yaml
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
