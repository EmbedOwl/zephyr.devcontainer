# Zephyr RTOS Dev Container

Ready-to-use dev container for Zephyr RTOS development on Raspberry Pi Pico / Pico W (RP2040). Includes toolchain, SDK, and all required build tools – no manual host setup needed.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Structure: Devcontainer and Projects Are Separate](#structure-devcontainer-and-projects-are-separate)
- [Included Components](#included-components)
- [Hardware Access](#hardware-access)

## Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/)
- [Docker](https://www.docker.com/)
- VS Code extension [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## Quick Start

```bash
git clone https://github.com/EmbedOwl/zephyr.devcontainer.git
cd zephyr.devcontainer
code .
```

VS Code automatically detects the devcontainer configuration:

- **Notification** → *"Reopen in Container"*, or
- **Command Palette** (`Ctrl+Shift+P`) → *"Dev Containers: Reopen in Container"*

The first build takes about 5–10 minutes (toolchain and SDK download). Afterwards, a complete Zephyr development environment is ready inside the container.

## Structure: Devcontainer and Projects Are Separate

This repository contains **only the devcontainer infrastructure** – no application code of its own. The folder this repo lives in is mounted 1:1 into the container at `/workspace`. VS Code opens directly into `/workspace/apps`, so `.devcontainer`, `docs/`, and this `README.md` stay out of the way in day-to-day work.

Your own Zephyr applications go into subfolders under `apps/` – one folder per project, each with its own `CMakeLists.txt`, `prj.conf`, `boards/` and `src/` directory:

```
zephyr.devcontainer/            ← this repo (devcontainer infrastructure)
├── .devcontainer/
│   ├── Dockerfile
│   └── devcontainer.json       ← workspaceFolder = /workspace/apps
├── README.md
└── apps/                       ← opened by default; local only, not part of this repo (.gitignore)
    ├── project_a/
    │   ├── CMakeLists.txt
    │   ├── prj.conf
    │   ├── boards/
    │   └── src/
    └── project_b/
        └── ...
```

To access `.devcontainer`, `docs/`, or other repo-root files from inside the running container, open the parent folder instead: Command Palette → *"File: Open Folder"* → `/workspace`.

The reasoning behind this separation: the devcontainer is developed and versioned independently of your own projects. Your projects belong in their own repository – e.g. one per folder under `apps/`, or a shared project repo tracking the whole workspace folder.

## Included Components

| Component           | Details                                                                  |
| ------------------- | ------------------------------------------------------------------------ |
| Base image          | `debian:trixie-slim`                                                     |
| Zephyr RTOS         | `v4.4-branch`, including HAL blobs for `hal_rpi_pico` and `hal_infineon`  |
| Zephyr SDK          | `v1.0.1`, ARM toolchain (`arm-zephyr-eabi`)                               |
| Build tools         | West, CMake (+ `cmake-curses-gui`), Ninja, Device Tree Compiler, gperf    |
| Debug/Flash         | OpenOCD, gdb-multiarch, minicom, optional J-Link                         |
| Python              | Dedicated venv (`/opt/venv`) with all Zephyr requirements                 |
| Shell/CLI utilities | git, curl, wget, vim, nano, mc, sudo, usbutils                            |
| SSH                 | OpenSSH server pre-installed                                             |
| Editor integration  | C/C++, CMake Tools, Cortex-Debug (pre-installed)                         |

The Python venv and Zephyr environment are activated automatically when a shell starts (`~/.bashrc`).

## Hardware Access

The container runs with `--privileged` and mounts `/dev` as well as `/dev/bus/usb`, so the Pico/Pico W can be accessed via USB (flashing, serial) directly from inside the container – no additional passthrough configuration required.
