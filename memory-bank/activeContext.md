# Active Context: Virtual Onvif Server

## Current Work Focus

The Virtual Onvif Server project is currently in a stable state with core functionality implemented. The main focus is on:

1. **Documentation**: Improving documentation to make the project more accessible to users with varying technical backgrounds.

2. **Stability**: Ensuring reliable operation across different network environments and camera systems.

3. **Compatibility**: Testing and improving compatibility with various Onvif clients beyond Unifi Protect.

## Recent Changes

1. **Initial Project Setup**: The project has been set up with the core functionality to:
   - Create virtual Onvif devices from existing RTSP streams
   - Support automatic configuration generation from existing Onvif devices
   - Implement the necessary Onvif protocol services for device discovery and streaming

2. **Docker Support**: Added Docker containerization for easier deployment.

3. **Documentation**: Created comprehensive README with setup instructions for Raspberry Pi and Docker environments.

## Next Steps

1. **Automated Network Configuration**: Develop scripts to automate the creation and configuration of virtual network interfaces, making setup easier for users.

2. **Extended Onvif Support**: Consider implementing additional Onvif profiles and features beyond the current Profile S support.

3. **Web Interface**: Potentially develop a web-based configuration interface to simplify setup and management.

4. **Persistent Configuration**: Implement a solution for persisting virtual network configurations across reboots.

5. **Performance Optimization**: Identify and address any performance bottlenecks, particularly for deployments with many virtual devices.

6. **Testing Framework**: Develop automated tests to ensure compatibility with different Onvif clients and camera systems.

## Active Decisions and Considerations

1. **Protocol Support Scope**: 
   - Decision: Currently limiting support to Onvif Profile S (Live Streaming)
   - Consideration: Expanding to other profiles would increase compatibility but add complexity

2. **Network Configuration**: 
   - Decision: Requiring manual setup of virtual network interfaces
   - Consideration: This adds complexity for users but is necessary for proper operation with Unifi Protect

3. **Authentication Handling**: 
   - Decision: Passing through authentication to the original device
   - Consideration: This simplifies implementation but may have security implications

4. **Configuration Format**: 
   - Decision: Using YAML for configuration files
   - Consideration: YAML provides better readability and structure compared to alternatives

5. **Deployment Strategy**: 
   - Decision: Supporting both direct Node.js deployment and Docker containerization
   - Consideration: This provides flexibility for different user preferences and environments

6. **Error Handling**: 
   - Decision: Implementing specific error handling for common Onvif issues like time synchronization
   - Consideration: Improves user experience by addressing known pain points in Onvif implementations
