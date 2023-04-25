ARG base="ubuntu:22.10"

# final stage
FROM ${base}

ENV LANG de_DE.UTF-8
ENV LANGUAGE de_DE:de
ENV LC_ALL de_DE.UTF-8

RUN echo export TERM="xterm" >> /root/.bashrc

RUN apt-get update && apt-get install -y \
    db-util \
    iproute2 \
    locales \
    psmisc \
    tree \
    tzdata \
    vsftpd \
    xz-utils \
    # clean up
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# install s6 overlay
ARG S6_OVERLAY_VERSION=3.1.0.1
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

RUN locale-gen de_DE.UTF-8 && update-locale LANG=de_DE.UTF-8

ENV FTP_HOME=user \
    FTP_UID=1000

ADD dockerimage/ /

RUN mkdir -p /var/run/vsftpd/empty

EXPOSE 21

ENTRYPOINT ["/init"]
