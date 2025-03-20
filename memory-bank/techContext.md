# Technical Context: Virtual Onvif Server

## Technologies Used

### Core Technologies

| Technology | Purpose | Version |
|------------|---------|---------|
| Node.js | Runtime environment | v16+ |
| JavaScript | Programming language | ES6+ |
| YAML | Configuration format | - |
| MacVLAN | Network virtualization | - |
| Onvif | Camera protocol | Profile S |
| RTSP | Streaming protocol | - |

### Key Libraries and Dependencies

| Library | Purpose | Notes |
|---------|---------|-------|
| node-onvif | Onvif protocol implementation | Handles device discovery and communication |
| node-rtsp-stream | RTSP streaming | Manages video stream proxying |
| js-yaml | YAML parsing | Processes configuration files |
| node-tcp-proxy | TCP proxying | Routes network traffic between virtual and real devices |
| uuid | UUID generation | Creates unique identifiers for virtual devices |

## Development Setup

### Hardware Requirements
- Raspberry Pi 4 (recommended) or equivalent
- 2GB+ RAM
- Ethernet connection (for reliable camera streaming)
- Sufficient storage for the application (minimal requirements)

### Software Requirements
- Raspberry OS 11 (Bullseye) or newer
- Node.js v16 or higher
- Network configuration tools (for virtual interfaces)

### Development Environment
- Standard Node.js development tools
- Text editor with YAML support
- Network analysis tools for debugging
- RTSP client for testing (e.g., VLC)

## Technical Constraints

### Network Constraints
1. **IP Address Availability**: Each virtual camera requires its own IP address, which may be a constraint in networks with limited IP space.
2. **Network Interface Support**: The host system must support MacVLAN or similar technology for creating virtual network interfaces.
3. **Bandwidth Requirements**: Multiple camera streams require significant bandwidth; a gigabit network is recommended.
4. **Multicast Limitations**: Some networks may have limitations on multicast traffic, which can affect device discovery.

### Hardware Constraints
1. **CPU Usage**: Each camera stream requires processing power; a Raspberry Pi 4 can typically handle 10-20 cameras depending on resolution and framerate.
2. **Memory Usage**: Memory requirements scale with the number of active streams.
3. **Network Interface**: A single physical network interface is required, but it must support virtual interfaces.

### Software Constraints
1. **Node.js Version**: Requires Node.js v16 or higher for modern JavaScript features and performance.
2. **OS Compatibility**: Primarily designed for Linux-based systems; may require adjustments for other platforms.
3. **Root Access**: Creating virtual network interfaces requires root/sudo access.

## Dependencies

### External Dependencies
1. **Real NVR/DVR Systems**: The virtual server depends on the availability and stability of the real camera systems.
2. **Network Infrastructure**: Requires stable network connectivity between the server, NVRs, and clients.
3. **Unifi Protect**: While designed to work with Unifi Protect, it depends on Unifi's implementation of the Onvif protocol.

### Internal Dependencies
1. **Configuration Integrity**: The system depends on a valid and well-structured configuration file.
2. **Port Availability**: Requires numerous TCP ports to be available for the various services.
3. **Virtual Network Setup**: Depends on properly configured virtual network interfaces.

## Performance Considerations

### Bottlenecks
1. **Network Bandwidth**: The most common bottleneck, especially with multiple high-resolution streams.
2. **CPU Processing**: Can become a bottleneck when handling many concurrent streams.
3. **Memory Usage**: Can grow significantly with many active connections.

### Optimization Strategies
1. **Stream Reuse**: When possible, reuse existing streams rather than creating new connections to the NVR.
2. **Lazy Loading**: Only establish connections to NVRs when clients request streams.
3. **Connection Pooling**: Maintain a pool of connections to reduce setup/teardown overhead.
4. **Caching**: Cache snapshot images and device capabilities to reduce load.

## Security Considerations

1. **Authentication Passthrough**: The system passes through authentication credentials to the real NVRs.
2. **Network Isolation**: Consider placing the virtual server in a separate network segment for isolation.
3. **Credential Management**: Credentials are stored in the configuration file and should be protected.
4. **Limited Scope**: The implementation focuses on Profile S (streaming) and does not expose full device control.

## Deployment Considerations

1. **Persistence**: Consider using systemd or similar to ensure the service starts automatically.
2. **Network Setup Persistence**: Virtual network interfaces need to be recreated on system restart.
3. **Logging**: Configure appropriate logging for troubleshooting.
4. **Monitoring**: Consider implementing health checks and monitoring.
5. **Updates**: Plan for updating the software and its dependencies.

## Docker Support

The application can be containerized using Docker, which provides:
- Isolation from the host system
- Simplified deployment
- Consistent runtime environment
- Easy updates

When using Docker, the configuration file is mounted into the container, and network considerations become more complex due to the need for virtual network interfaces.
