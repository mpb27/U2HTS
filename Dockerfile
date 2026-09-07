FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install build tools and ARM cross-compiler toolchain
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    gcc-arm-none-eabi \
    git \
    libnewlib-arm-none-eabi \
    libstdc++-arm-none-eabi-newlib \
    ninja-build \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Pre-install Raspberry Pi Pico SDK v2.3.0
ENV PICO_SDK_PATH=/opt/pico-sdk
RUN git clone --depth 1 --branch 2.3.0 --recursive https://github.com/raspberrypi/pico-sdk.git ${PICO_SDK_PATH}

# Set working directory for volume-mounted source code
WORKDIR /workspace

# Build U2HTS firmware for waveshare_rp2040_zero target by default
CMD ["sh", "-c", "cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=MinSizeRel -DPICO_BOARD=waveshare_rp2040_zero -DU2HTS_ENABLE_LED=ON && cmake --build build"]
