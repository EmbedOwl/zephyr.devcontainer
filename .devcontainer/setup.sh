#!/bin/bash
set -e

echo "=== Zephyr RTOS Development Environment Setup ==="

# Install Zephyr dependencies
echo "[1/4] Installing system dependencies..."
apt-get update
apt-get install -y \
    build-essential \
    cmake \
    git \
    python3-dev \
    python3-pip \
    ccache \
    dfu-util \
    device-tree-compiler \
    ninja-build \
    gperf

# Install Python dependencies
echo "[2/4] Installing Python tools..."
python3 -m pip install --upgrade pip
pip3 install west cryptography pyyaml

# Initialize Zephyr workspace (if needed)
if [ ! -d "/opt/toolchains/zephyr/.git" ]; then
    echo "[3/4] Initializing Zephyr workspace..."
    mkdir -p /opt/toolchains
    cd /opt/toolchains
    west init -m https://github.com/zephyrproject-rtos/zephyr.git zephyr
    cd zephyr
    west update
else
    echo "[3/4] Zephyr workspace already initialized"
fi

# Setup environment
echo "[4/4] Setting up environment variables..."
echo "export ZEPHYR_BASE=/opt/toolchains/zephyr" >> ~/.bashrc
export ZEPHYR_BASE=/opt/toolchains/zephyr

echo "=== Setup Complete ==="
echo "Zephyr is ready at: $ZEPHYR_BASE"
echo "Try: cd /workspace && west build"
