# Zephyr RTOS Dev Container

Development Container für Zephyr RTOS Entwicklung mit Raspberry Pi Pico/Pico W.

## Voraussetzungen

- Visual Studio Code
- Docker
- Dev Containers Extension ([ms-vscode-remote.remote-containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers))

## Installation

### Repository klonen

```bash
git clone https://github.com/EmbedOwl/zephyr.devcontainer.git
cd zephyr.devcontainer
```

### Container in VS Code starten

```bash
code .
```

VS Code erkennt automatisch die Dev Container Konfiguration und zeigt eine Benachrichtigung an.

**Option 1:** Klick auf "Reopen in Container" in der Benachrichtigung

**Option 2:** Command Palette (`Ctrl+Shift+P`) → "Dev Containers: Reopen in Container"

Der initiale Build dauert ca. 5-10 Minuten. Nach Abschluss werden automatisch Zephyr SDK und alle Dependencies installiert.

## Enthaltene Komponenten

## Enthaltene Komponenten

Der Container enthält:

- Zephyr RTOS SDK (v0.16.8)
- West Build Tool
- ARM Embedded GCC Toolchain
- Python Environment mit Zephyr Dependencies
- CMake, Ninja, Device Tree Compiler
- Git, vim, minicom
- J-Link Debugger Support (optional)

## Container-Verwaltung

### Container neu bauen

Nach Änderungen an `.devcontainer/devcontainer.json` oder `.devcontainer/Dockerfile`:

Command Palette → "Dev Containers: Rebuild Container"

### Verbindung trennen

Klick auf grünen Container-Button (links unten) → "Close Remote Connection"

## Troubleshooting

**Container startet nicht**
- Docker Status prüfen: `docker ps`
- Dev Containers Extension installiert?
- Docker-Logs im VS Code Terminal prüfen

**USB-Geräte nicht sichtbar**
- Windows/Mac: Docker Desktop USB-Passthrough konfigurieren
- Linux: User muss in `dialout` Gruppe sein

**Permission denied**
- Container läuft als Root
- Dateien außerhalb des Containers gehören dem Host-User

## Weitere Informationen

- Container-Details: [.devcontainer/README.md](.devcontainer/README.md)
- Zephyr Dokumentation: [https://docs.zephyrproject.org](https://docs.zephyrproject.org)
