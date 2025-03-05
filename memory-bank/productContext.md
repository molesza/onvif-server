# Product Context: Virtual Onvif Server

## Why This Project Exists

The Virtual Onvif Server was created to address specific limitations in how third-party camera systems integrate with Unifi Protect. Unifi Protect 5.0 introduced support for third-party cameras through the Onvif protocol, but with significant limitations:

1. It only supports cameras with a single high and low-quality stream.
2. It doesn't properly support video recorders that output multiple cameras (e.g., Hikvision/Dahua XVR) or cameras with multiple internal cameras.

These limitations prevent users from fully utilizing their existing multi-channel camera systems with Unifi Protect, forcing them to either replace their equipment or forego integration.

## Problems It Solves

1. **Multi-Channel Device Integration**: By splitting a multi-channel Onvif device into multiple virtual Onvif devices, each with its own unique MAC address, the project allows Unifi Protect to recognize and manage each channel as a separate camera.

2. **RTSP Stream Conversion**: Enables regular RTSP streams (even those not from Onvif-compatible sources) to be presented as Onvif devices, expanding compatibility with Unifi Protect and other Onvif clients.

3. **Network Identification**: Solves the network identification issue by creating virtual network interfaces with unique MAC addresses, ensuring Unifi Protect can properly identify and manage each virtual camera.

4. **Configuration Flexibility**: Provides a way to customize stream properties (resolution, framerate, bitrate, quality) to optimize for different use cases and network conditions.

## How It Should Work

1. **Configuration**: Users provide details about their existing RTSP streams, either by:
   - Using the automatic configuration tool that connects to an existing Onvif device and extracts stream information
   - Manually creating a configuration for regular RTSP streams

2. **Virtual Network Setup**: Users create virtual network interfaces with unique MAC addresses using the MacVLAN network driver.

3. **Virtual Onvif Server Deployment**: The application creates virtual Onvif devices based on the configuration, each listening on its assigned virtual network interface.

4. **Stream Proxying**: When an Onvif client (like Unifi Protect) connects to a virtual device, the server proxies the RTSP stream from the original source to the client, presenting it as if it were coming from a native Onvif device.

5. **Discovery**: The virtual devices respond to Onvif discovery protocols, making them automatically discoverable by Onvif clients on the network.

## User Experience Goals

1. **Simplicity**: Users should be able to set up and configure the system with minimal technical knowledge, using either the automatic configuration tool or following clear documentation for manual configuration.

2. **Reliability**: Once configured, the virtual Onvif devices should operate reliably without requiring frequent maintenance or adjustments.

3. **Performance**: The proxy should introduce minimal overhead, ensuring that video streams remain smooth and responsive.

4. **Flexibility**: Users should be able to easily adjust configurations to accommodate different camera setups and requirements.

5. **Compatibility**: The virtual devices should appear as standard Onvif devices to clients, ensuring broad compatibility with Onvif-compatible systems.

6. **Containerization**: Provide a Docker container option for users who prefer containerized deployments, simplifying installation and updates.
