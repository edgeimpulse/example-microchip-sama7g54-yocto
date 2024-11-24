FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    git \
    sudo \
    build-essential \
    chrpath \
    cpio \
    diffstat \
    gawk \
    texinfo \
    wget \
    python3 \
    python3-pip \
    python3-pexpect \
    libsdl1.2-dev \
    xterm \
    locales \
    lz4 \
    zstd \
    nano \
    xterm \
    tmux \
    screen \
    gnome-terminal \
    vim-common && \
    rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN useradd -m -s /bin/bash yocto && echo "yocto ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER yocto
WORKDIR /home/yocto

RUN git clone https://git.yoctoproject.org/poky && \
    cd poky && \
    git checkout -b kirkstone yocto-4.0.17 && \
    cd -

RUN git clone git://git.openembedded.org/meta-openembedded && \
    cd meta-openembedded && \
    git checkout -b kirkstone 8bb165 && \
    cd -

RUN git clone https://github.com/linux4sam/meta-atmel.git && \
    cd meta-atmel && \
    git checkout kirkstone || git checkout -b kirkstone linux4microchip-2024.04 && \
    cd -

RUN git clone https://git.yoctoproject.org/meta-arm && \
    cd meta-arm && \
    git checkout -b kirkstone yocto-4.0.2 && \
    cd -

WORKDIR /home/yocto/poky
RUN mkdir build-microchip

ENV TEMPLATECONF=../meta-atmel/conf

ENTRYPOINT ["/bin/bash"]