FROM debian:bullseye

ARG DEBIAN_FRONTEND=noninteractive

COPY entrypoint.sh /entrypoint.sh

RUN apt-get update \
&& apt-get install -y \
    device-tree-compiler \
    gcc-arm-linux-gnueabihf \
    build-essential:native debhelper quilt bc \
    kmod rsync bison flex libssl-dev \
    git git-buildpackage \
    eatmydata \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

RUN install -d /build

ENTRYPOINT ["/entrypoint.sh"]