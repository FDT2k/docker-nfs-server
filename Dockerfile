FROM ubuntu:xenial
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq \
    && apt-get install -y nfs-kernel-server runit inotify-tools -qq \
    && apt-get -yq remove fgetty \
    && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /var/tmp/*
RUN mkdir -p /exports

RUN mkdir -p /etc/sv/nfs
ADD nfs.init /etc/sv/nfs/run
ADD nfs.stop /etc/sv/nfs/finish

ADD nfs_setup.sh /usr/local/bin/nfs_setup

VOLUME /exports

EXPOSE 111/udp 2049/tcp

ENTRYPOINT ["/usr/local/bin/nfs_setup"]
