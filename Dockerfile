FROM ubuntu:18.04

LABEL version="2.3"
LABEL description="SIFT and REMnux Docker based on Ubuntu 18.04 LTS"
LABEL maintainer="https://github.com/digitalsleuth/sift-remnux"

ENV TERM linux

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && apt-get install sudo git nano curl wget gnupg -y
RUN wget -nv -O - https://repo.saltstack.com/py3/ubuntu/18.04/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add - && \
echo deb [arch=amd64] http://repo.saltstack.com/py3/ubuntu/18.04/amd64/3001 bionic main > /etc/apt/sources.list.d/saltstack.list && \
apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y salt-common salt-minion

RUN curl -Lo /usr/local/bin/remnux https://github.com/remnux/remnux-cli/releases/download/v1.3.1/remnux-cli-linux && \
chmod +x /usr/local/bin/remnux && \
curl -Lo /usr/local/bin/sift https://github.com/sans-dfir/sift-cli/releases/download/v1.9.2/sift-cli-linux && \
chmod +x /usr/local/bin/sift

RUN groupadd -r forensics && \
useradd -r -g forensics -d /home/forensics -s /bin/bash -c "Forensics User" forensics && \
mkdir /home/forensics && \
chown -R forensics:forensics /home/forensics && \
usermod -a -G sudo forensics && \
echo 'forensics:forensics' | chpasswd

RUN DEBIAN_FRONTEND=noninteractive sudo remnux install --mode=cloud --user=forensics
RUN sudo sift install --mode=packages-only --user=forensics --pre-release
RUN cd /mnt && mkdir aff bde e01 ewf ewf_mount iscsi shadow_mount usb vss windows_mount windows_mount1 windows_mount2 windows_mount3 windows_mount4 windows_mount5 && \
cd shadow_mount && for i in {1..30}; do mkdir vss$i; done
RUN rm -rf /var/cache/salt/* && \
rm -rf /srv/* && \
rm -rf /root/.cache/*

WORKDIR /home/forensics

RUN mkdir /var/run/sshd
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
