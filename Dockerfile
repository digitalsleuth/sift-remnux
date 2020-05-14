FROM digitalsleuth/remnux-docker:latest

LABEL version="1.5"
LABEL description="SIFT and REMnux Docker based on Ubuntu 18.04 LTS"
LABEL maintainer="https://github.com/digitalsleuth/sift-remnux"

ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive
ENV PATH "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RUN curl -Lo /usr/local/bin/sift https://github.com/sans-dfir/sift-cli/releases/download/v1.8.5/sift-cli-linux && \
chmod +x /usr/local/bin/sift && \
apt-get update && apt-get upgrade -y && \
pip uninstall rekall -y && rm /usr/local/bin/rek* && rm /usr/local/bin/densityscout && \
sudo sift install --mode=packages-only --user=remnux && \
cd /mnt && mkdir aff bde e01 ewf ewf_mount iscsi shadow_mount usb vss windows_mount windows_mount1 windows_mount2 windows_mount3 windows_mount4 windows_mount5 && \
cd shadow_mount && for i in {1..30}; do mkdir vss$i; done && \
# Add a couple of fixes until the next SIFT release
git clone https://github.com/keydet89/Tools.git /tmp/keydet && \
cp /tmp/keydet/source/*.pm /usr/share/perl5/ && \
mv /usr/share/perl5/pref.pm /usr/share/perl5/Pref.pm && \
apt-get install -y libcgi-pm-perl libdate-calc-perl libdbi-perl libimage-exiftool-perl libjson-perl libxml-xpath-perl

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
