# Zephyr development image for Raspberry Pi Pico (RP2040)

# Settings
ARG DEBIAN_VERSION=trixie-20260713-slim
ARG PASSWORD="zephyr"
ARG ZEPHYR_RTOS_COMMIT=v4.4-branch
ARG ZEPHYR_SDK_VERSION=1.0.1
ARG TOOLCHAIN_LIST="-t arm-zephyr-eabi"
ARG WGET_ARGS="-q --show-progress --progress=bar:force:noscroll"
ARG VIRTUAL_ENV=/opt/venv

#-------------------------------------------------------------------------------
# Base Image and Dependencies

FROM debian:${DEBIAN_VERSION}

# Redeclare arguments after FROM
ARG PASSWORD
ARG ZEPHYR_RTOS_COMMIT
ARG ZEPHYR_SDK_VERSION
ARG TOOLCHAIN_LIST
ARG WGET_ARGS
ARG VIRTUAL_ENV
ARG TARGETARCH

# Set default shell during Docker image build to bash
SHELL ["/bin/bash", "-c"]

# Check if the target architecture is supported
RUN if [ "$TARGETARCH" = "amd64" ] || [ "$TARGETARCH" = "arm64" ]; then \
        echo "Architecture $TARGETARCH is supported."; \
    else \
        echo "Unsupported architecture: $TARGETARCH"; \
        exit 1; \
    fi

# Set non-interactive frontend for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Install base packages
RUN apt-get -y update && \
    apt-get install --no-install-recommends -y \
        ca-certificates \
        file \
        locales \
        git \
        build-essential \
        cmake \
        ninja-build \
        gperf \
        device-tree-compiler \
        wget \
        curl \
        python3 \
        python3-pip \
        python3-venv \
        xz-utils \
        vim \
        nano \
        mc \
        openssh-server \
        gdb-multiarch \
        openocd \
        minicom \
        cmake-curses-gui \
        sudo \
        usbutils \
    && rm -rf /var/lib/apt/lists/*

# Set root password
RUN echo "root:${PASSWORD}" | chpasswd

# Set up a Python virtual environment
ENV VIRTUAL_ENV=${VIRTUAL_ENV}
RUN python3 -m venv ${VIRTUAL_ENV}
ENV PATH="${VIRTUAL_ENV}/bin:$PATH"

# Install west
RUN python3 -m pip install --no-cache-dir west

# Set up directories
RUN mkdir -p /workspace/ && \
    mkdir -p /opt/toolchains

# Set up sshd working directory
RUN mkdir -p /var/run/sshd && \
    chmod 0755 /var/run/sshd

#-------------------------------------------------------------------------------
# Zephyr RTOS

# Set Zephyr environment variables
ENV ZEPHYR_RTOS_COMMIT=${ZEPHYR_RTOS_COMMIT}

# Install Zephyr
RUN cd /opt/toolchains && \
    git clone https://github.com/zephyrproject-rtos/zephyr.git && \
    cd zephyr && \
    git checkout ${ZEPHYR_RTOS_COMMIT} && \
    python3 -m pip install -r scripts/requirements-base.txt

# Instantiate west workspace and install tools
RUN cd /opt/toolchains && \
    west init -l zephyr && \
    west update --narrow -o=--depth=1

# Install module-specific blobs
RUN cd /opt/toolchains && \
    west blobs fetch hal_rpi_pico && \
    west blobs fetch hal_infineon

#-------------------------------------------------------------------------------
# Zephyr SDK

# Set environment variables
ENV ZEPHYR_SDK_VERSION=${ZEPHYR_SDK_VERSION}

# Install minimal Zephyr SDK
RUN cd /opt/toolchains && \
    wget ${WGET_ARGS} https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}/zephyr-sdk-${ZEPHYR_SDK_VERSION}_linux-${HOSTTYPE}_minimal.tar.xz && \
    tar xf zephyr-sdk-${ZEPHYR_SDK_VERSION}_linux-${HOSTTYPE}_minimal.tar.xz && \
    rm zephyr-sdk-${ZEPHYR_SDK_VERSION}_linux-${HOSTTYPE}_minimal.tar.xz

# Install Zephyr SDK for ARM toolchain
RUN cd /opt/toolchains/zephyr-sdk-${ZEPHYR_SDK_VERSION} && \
    bash setup.sh -c ${TOOLCHAIN_LIST}

# Install host tools
RUN cd /opt/toolchains/zephyr-sdk-${ZEPHYR_SDK_VERSION} && \
    wget ${WGET_ARGS} https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}/hosttools_linux-${HOSTTYPE}.tar.xz && \
    tar xf hosttools_linux-${HOSTTYPE}.tar.xz && \
    rm hosttools_linux-${HOSTTYPE}.tar.xz && \
    bash zephyr-sdk-${HOSTTYPE}-hosttools-standalone-*.sh -y -d .

#-------------------------------------------------------------------------------
# Optional Settings

# Initialize system locale
RUN sed -i '/^#.*en_US.UTF-8/s/^#//' /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Activate Python and Zephyr environments for shell sessions
RUN echo "source ${VIRTUAL_ENV}/bin/activate" >> /root/.bashrc && \
    echo "source /opt/toolchains/zephyr/zephyr-env.sh" >> /root/.bashrc

#-------------------------------------------------------------------------------
# User Setup

# Create 'user' account
RUN useradd -m -s /bin/bash user && \
    echo "user:${PASSWORD}" | chpasswd && \
    usermod -a -G dialout user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Setup user environment
RUN echo "source ${VIRTUAL_ENV}/bin/activate" >> /home/user/.bashrc && \
    echo "source /opt/toolchains/zephyr/zephyr-env.sh" >> /home/user/.bashrc

# Switch to user
USER user
WORKDIR /workspace

# Register SDK for user (SDK was installed as root, but needs to be registered for user)
RUN cd /opt/toolchains/zephyr-sdk-${ZEPHYR_SDK_VERSION} && bash setup.sh -c