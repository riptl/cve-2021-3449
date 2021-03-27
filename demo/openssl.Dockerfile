ARG BASE_IMAGE
FROM ${BASE_IMAGE}
WORKDIR /root
CMD ["gdb", "-batch", "-ex", "run", "-ex", "bt", "--args", "/usr/bin/openssl", "s_server"]
