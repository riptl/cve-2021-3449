ARG BASE_IMAGE
FROM ${BASE_IMAGE}
WORKDIR /root
RUN DEBIAN_FRONTEND=noninteractive \
    curl -fsSL https://deb.nodesource.com/setup_15.x | bash - \
 && apt-get install -y nodejs
COPY nodejs.js /root/
CMD ["gdb", "-batch", "-ex", "run", "-ex", "bt", "--args", "/usr/bin/node", "/root/nodejs.js"]
