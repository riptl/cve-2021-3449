ARG BASE_IMAGE
FROM ${BASE_IMAGE}
WORKDIR /root
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -y haproxy
COPY haproxy.cfg /etc/haproxy/
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["haproxy -W -f /etc/haproxy/haproxy.cfg"]
