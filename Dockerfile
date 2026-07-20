# REMNUX_VERSION=v026.29.2
# SIFT_VERSION=v2026.04.21

FROM ubuntu:24.04

LABEL version="7.0"
LABEL description="SIFT and REMnux Docker based on Ubuntu 24.04 LTS"
LABEL maintainer="https://github.com/digitalsleuth/sift-remnux"
ARG CAST='1.0.23'
ARG FOR_USER=forensics
ARG DESCR="Forensics User"
ARG PASS="forensics"

ENV TERM=linux

USER root
WORKDIR /tmp
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y wget gnupg git openssh-server nano && \
    groupadd -r -g 1001 ${FOR_USER} && \
    useradd -m -g ${FOR_USER} -d /home/${FOR_USER} -s /bin/bash -c "${DESCR}" -u 1001 ${FOR_USER} && \
    touch /home/${FOR_USER}/.Xauthority && \
    chown -R ${FOR_USER}:${FOR_USER} /home/${FOR_USER} && \
    usermod -a -G sudo ${FOR_USER} && \
    echo "${FOR_USER}:${PASS}" | chpasswd && \
    wget https://github.com/ekristen/cast/releases/download/v${CAST}/cast-v${CAST}-linux-amd64.deb && \
    dpkg -i /tmp/cast-v${CAST}-linux-amd64.deb && \
    rm /tmp/cast-v${CAST}-linux-amd64.deb

RUN cast install --mode server --user ${FOR_USER} sift || true && \
    cast install --mode cloud --user ${FOR_USER} remnux || true

RUN git clone https://github.com/digitalsleuth/color_ssh_terminal /tmp/colorssh && \
    cd /tmp/colorssh && cat color_ssh_terminal >> /home/${FOR_USER}/.bashrc && cd /tmp && rm -rf colorssh && \
    echo source .bashrc >> /home/${FOR_USER}/.bash_profile && \
    chown -R ${FOR_USER}:${FOR_USER} /home/${FOR_USER}

RUN cd /mnt && mkdir aff bde e01 ewf ewf_mount iscsi shadow_mount usb vss windows_mount || true && \
    for i in $(seq 1 5); do mkdir windows_mount$i || true; done && cd shadow_mount && for i in $(seq 1 30); do mkdir vss$i || true; done

RUN rm -rf /var/cache/salt/* && \
    rm -rf /srv/* && \
    rm -rf /root/.cache/* && \
    rm -rf /usr/local/src/remnux/files/*

WORKDIR /home/${FOR_USER}

RUN mkdir /var/run/sshd
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
