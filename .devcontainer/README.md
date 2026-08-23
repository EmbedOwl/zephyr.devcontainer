# Zephyr RTOS Development Container

A complete development environment for Zephyr RTOS projects on Raspberry Pi Pico W and other platforms.

## Features

✅ Zephyr RTOS v4.4+ pre-configured
✅ West build system
✅ ARM GCC toolchain
✅ VS Code integration with C/C++ tools
✅ USB device access for flashing
✅ Fully containerized with Docker

## Quick Start

### Prerequisites

- Docker Desktop or Docker Engine
- VS Code with "Dev Containers" extension
- USB connection to your Raspberry Pi Pico

### Setup

1. **Clone this repository**
   ```bash
   git clone https://github.com/yourusername/zephyr-devcontainer.git
   cd zephyr-devcontainer
   ```

2. **Open in VS Code**
   ```bash
   code .
   ```
   VS Code will automatically detect the devcontainer config and prompt you to reopen in container.

3. **Clone your projects repository**
   Inside the container:
   ```bash
   cd /workspace
   git clone https://github.com/yourusername/zephyr-projects.git .
   ```

4. **Build a project**
   ```bash
   cd /workspace/apps/05_mqtt_rpi_pico_w
   west build -p always -b rpi_pico/rp2040/w
   ```

5. **Flash to device**
   ```bash
   west flash --runner uf2
   ```

## Container Contents

- **Zephyr RTOS**: Latest stable version
- **West**: Zephyr meta-tool
- **ARM GCC**: For cross-compilation
- **CMake**: Build system
- **Python 3**: With pip and development tools
- **VS Code Extensions**: C++, CMake, Cortex-Debug

## Directory Structure

```
zephyr-devcontainer/          ← This repo
├── .devcontainer/
│   ├── devcontainer.json     ← VS Code config
│   ├── setup.sh              ← Installation script
│   └── zephyr.code-workspace ← Loads project tasks
├── README.md                 ← This file
└── LICENSE

/workspace                     ← Mounted from outside
└── zephyr-projects/          ← Your separate project repo
    ├── apps/
    ├── .vscode/tasks.json
    └── docs/
```

## Mounting Custom Projects

The container mounts `/workspace` which can contain:
- Your Zephyr project repository
- Multiple projects side-by-side
- Any other Zephyr-based project

To use a different project:
```bash
# Inside container
cd /workspace
git clone <your-project-repo> .
```

## USB Device Access

The container has access to `/dev/ttyACM0` for serial communication and `/dev/bus/usb` for device flashing.

**On Linux**, ensure your user is in the `dialout` group:
```bash
sudo usermod -aG dialout $USER
```

## Troubleshooting

### "No device found" when flashing
- Check USB connection with `lsusb`
- Ensure device is in bootloader mode (BOOTSEL button)
- Verify `/dev/ttyACM0` exists

### "Permission denied" for USB
- Container runs as root, so permissions should work
- If on Linux host, check `sudo usermod -aG dialout $USER`

### Zephyr build fails
- Clear build: `cd apps/myproject && rm -rf build`
- Update Zephyr: `cd /opt/toolchains/zephyr && west update`

## Environment Variables

Available inside container:
- `ZEPHYR_BASE=/opt/toolchains/zephyr`
- `PATH` includes ARM toolchain

## Project Structure (Reference)

When you mount your projects repo, it should have:
```
zephyr-projects/
├── apps/
│   ├── 01_hello_world/
│   ├── 02_random/
│   └── 05_mqtt/
├── .vscode/
│   └── tasks.json      ← Build/flash tasks
├── docs/
└── README.md
```

## License

MIT - See LICENSE file

## Support

For Zephyr documentation: https://docs.zephyrproject.org
For issues with this container: Open an issue in this repository
