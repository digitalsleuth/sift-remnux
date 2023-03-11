FROM ubuntu:20.04

LABEL version="5.0"
LABEL description="SIFT and REMnux Docker based on Ubuntu 20.04 LTS"
LABEL maintainer="https://github.com/digitalsleuth/sift-remnux"
ARG CAST=0.14.0
ARG REMNUX_VERSION=v2023.9.1
ARG SIFT_VERSION=v2023.02.06
ARG FOR_USER=forensics
ARG DESCR="Forensics User"
ARG PASS="forensics"

ENV TERM linux

USER root
WORKDIR /tmp
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y wget gnupg git openssh-server && \
    groupadd -r -g 1000 ${FOR_USER} && \
    useradd -r -g ${FOR_USER} -d /home/${FOR_USER} -s /bin/bash -c "${DESCR}" -u 1000 ${FOR_USER} && \
    mkdir /home/${FOR_USER} && \
    touch /home/${FOR_USER}/.Xauthority && \
    chown -R ${FOR_USER}:${FOR_USER} /home/${FOR_USER} && \
    usermod -a -G sudo ${FOR_USER} && \
    echo "${FOR_USER}:${PASS}" | chpasswd && \
    wget https://github.com/ekristen/cast/releases/download/v${CAST}/cast_v${CAST}_linux_amd64.deb && \
    dpkg -i /tmp/cast_v${CAST}_linux_amd64.deb && \
    rm /tmp/cast_v${CAST}_linux_amd64.deb

RUN cast install --mode server --user ${FOR_USER} sift && \
    cast install --mode cloud --user ${FOR_USER} remnux

RUN git clone https://github.com/digitalsleuth/color_ssh_terminal /tmp/colorssh && \
    cd /tmp/colorssh && cat color_ssh_terminal >> /home/${FOR_USER}/.bashrc && cd /tmp && rm -rf colorssh && \
    echo source .bashrc >> /home/${FOR_USER}/.bash_profile && \
    chown -R ${FOR_USER}:${FOR_USER} /home/${FOR_USER}

RUN cd /mnt && mkdir aff bde e01 ewf ewf_mount iscsi shadow_mount usb vss windows_mount windows_mount1 windows_mount2 windows_mount3 windows_mount4 windows_mount5 && \
cd shadow_mount && for i in {1..30}; do mkdir vss$i; done

RUN rm -rf /var/cache/salt/* && \
rm -rf /srv/* && \
rm -rf /root/.cache/*

WORKDIR /home/${FOR_USER}

RUN mkdir /var/run/sshd
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
