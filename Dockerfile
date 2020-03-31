FROM digitalsleuth/remnux-docker:latest

LABEL version="1.1"
LABEL description="SIFT and REMnux Docker based on Ubuntu 18.04 LTS"
LABEL maintainer="https://github.com/digitalsleuth/remnux-docker"

ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive
ENV PATH "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RUN curl -Lo /usr/local/bin/sift https://github.com/sans-dfir/sift-cli/releases/download/v1.8.5/sift-cli-linux && \
chmod +x /usr/local/bin/sift && \
apt-get update && apt-get upgrade -y && \
pip uninstall rekall -y && rm /usr/local/bin/densityscout
RUN sudo sift install --mode=packages-only --user=remnux

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
