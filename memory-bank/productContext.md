# Product Context: Virtual Onvif Server

## Why This Project Exists

### The Unifi Protect Limitation
Unifi Protect 5.0 introduced support for third-party cameras through the Onvif protocol, which was a welcome addition for users with mixed camera ecosystems. However, this implementation has a significant limitation: it only properly supports cameras with a single high and low-quality stream. This creates a problem for users with multi-channel Network Video Recorders (NVRs) or Digital Video Recorders (DVRs) that present multiple cameras through a single device interface.

### The Multi-Channel Camera Problem
Many surveillance setups use multi-channel recorders from manufacturers like Hikvision or Dahua. These devices connect to multiple cameras and expose them through a single interface. When connecting such a device to Unifi Protect, the system only recognizes it as a single camera, rather than the multiple cameras it actually represents.

### The Need for a Bridge Solution
Without a solution, users would need to:
1. Replace their existing multi-channel NVRs with individual cameras (expensive)
2. Maintain two separate surveillance systems (inefficient)
3. Forgo the benefits of Unifi Protect integration (limiting)

## Problems It Solves

1. **Device Compatibility**: Bridges the gap between multi-channel NVRs and Unifi Protect's single-camera expectation.

2. **Resource Utilization**: Allows users to continue using their existing camera infrastructure while gaining the benefits of Unifi Protect.

3. **Cost Efficiency**: Provides a software solution that eliminates the need for hardware replacement.

4. **Unified Management**: Enables all cameras to be managed through a single Unifi Protect interface.

5. **Scalability**: Supports multiple NVRs with many cameras, allowing for large surveillance deployments.

## How It Should Work

### Conceptual Flow
1. The Virtual Onvif Server connects to the real NVR/DVR and retrieves information about its cameras.
2. For each camera on the NVR, it creates a virtual Onvif device with its own unique network identity.
3. When Unifi Protect discovers these virtual devices, it sees them as individual cameras.
4. When Unifi Protect requests a video stream from a virtual device, the server retrieves the corresponding stream from the real NVR and passes it through.

### User Experience Goals

1. **Seamless Integration**: The virtual cameras should appear and function in Unifi Protect exactly like native cameras.

2. **Reliable Performance**: Video streams should be stable and maintain quality.

3. **Low Maintenance**: Once configured, the system should operate with minimal intervention.

4. **Flexible Configuration**: Users should be able to customize settings for each virtual camera.

5. **Resilience**: The system should recover gracefully from network interruptions or NVR issues.

## Current Implementation

The current implementation supports six NVRs with a total of 128 cameras. Each camera is presented as a separate virtual Onvif device with:

- A unique MAC address
- Dedicated network ports for server, RTSP, and snapshot services
- Custom naming based on camera location/function
- Configured resolution, framerate, and quality settings
- Proper routing to the source NVR

This setup allows all 128 cameras to be individually adopted and managed in Unifi Protect, providing a comprehensive surveillance solution that leverages both existing hardware and Unifi's management capabilities.
