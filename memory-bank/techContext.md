# Technical Context: Virtual Onvif Server

## Technologies Used

### Core Technologies

1. **Node.js**: The application is built on Node.js, providing a lightweight and efficient runtime for the server components.

2. **SOAP Protocol**: The Onvif protocol is based on SOAP (Simple Object Access Protocol), which is used for communication between the virtual devices and Onvif clients.

3. **RTSP Protocol**: Real Time Streaming Protocol is used for video streaming from the original camera/recorder to clients.

4. **WS-Discovery**: Web Services Discovery protocol is implemented to make the virtual Onvif devices discoverable on the network.

5. **MacVLAN**: Network virtualization technology used to create virtual network interfaces with unique MAC addresses.

6. **YAML**: Used for configuration file format due to its readability and support for complex data structures.

7. **Docker**: Containerization technology for simplified deployment and isolation.

### Key Dependencies

1. **soap (1.1.5)**: Library for implementing SOAP services and clients.

2. **xml2js (0.4.23)**: XML parsing and generation library used for handling SOAP messages.

3. **node-tcp-proxy (0.0.28)**: TCP proxy implementation for forwarding RTSP and HTTP traffic.

4. **node-uuid (1.4.8)**: UUID generation for device identification and message correlation.

5. **argparse (2.0.1)**: Command-line argument parsing.

6. **yaml (2.5.1)**: YAML parsing and generation.

7. **simple-node-logger (21.8.12)**: Logging functionality.

## Development Setup

### Prerequisites

1. **Node.js**: Version 16 or higher is required.

2. **Operating System**: 
   - For Raspberry Pi: Raspberry OS 11 (Bullseye) or newer
   - For other platforms: Any OS that supports Node.js v16+ and network virtualization

### Development Environment

1. **Code Structure**:
   - `main.js`: Entry point and main application logic
   - `src/onvif-server.js`: Core Onvif server implementation
   - `src/config-builder.js`: Configuration generation tool
   - `wsdl/`: WSDL files defining the Onvif services
   - `resources/`: Static resources like default snapshot images

2. **Building and Testing**:
   - No build process is required as the application is written in JavaScript
   - Manual testing is performed by deploying the application and connecting Onvif clients

3. **Deployment**:
   - Direct deployment: Run with Node.js on the target system
   - Docker deployment: Use the provided Docker image

## Technical Constraints

1. **Network Configuration**:
   - Requires the ability to create virtual network interfaces with unique MAC addresses
   - May require specific network settings to ensure proper ARP handling for virtual interfaces

2. **Performance Limitations**:
   - As a proxy, introduces some latency in video streaming
   - Node.js single-threaded nature may limit the number of concurrent connections
   - Resource constraints on devices like Raspberry Pi may limit the number of virtual devices

3. **Protocol Support**:
   - Currently only implements Onvif Profile S (Live Streaming)
   - Limited subset of Onvif functionality is implemented
   - No support for PTZ (Pan-Tilt-Zoom), analytics, or other advanced features

4. **Security Considerations**:
   - Passes through authentication to the original device
   - No additional security layer is implemented
   - Network isolation is recommended for production deployments

5. **Compatibility**:
   - Tested primarily with Unifi Protect as the client
   - May have compatibility issues with other Onvif clients that expect full protocol support

## Dependencies Management

1. **Fixed Versions**: Package.json specifies exact versions for most dependencies to ensure consistent behavior.

2. **Minimal Dependencies**: The project uses a minimal set of dependencies to reduce potential issues and security vulnerabilities.

3. **No Build Tools**: The project doesn't require build tools like webpack or babel, simplifying the development and deployment process.

## Deployment Considerations

1. **Network Setup**:
   - Virtual network interfaces must be configured before starting the application
   - DHCP reservations are recommended for the virtual interfaces

2. **Persistence**:
   - Virtual network settings are lost on reboot and must be reconfigured
   - Consider using startup scripts to automate network configuration

3. **Resource Usage**:
   - Monitor CPU and memory usage, especially on resource-constrained devices
   - Each virtual device adds some overhead in terms of memory and network connections

4. **Docker Deployment**:
   - Docker container requires host networking to properly handle virtual interfaces
   - Configuration file must be mounted into the container
