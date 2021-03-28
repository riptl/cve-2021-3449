ARG BASE_IMAGE
FROM ${BASE_IMAGE}
WORKDIR /root
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -y lighttpd
COPY lighttpd-10-ssl.conf /etc/lighttpd/conf-enabled/10-ssl.conf
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["lighttpd -D -f /etc/lighttpd/lighttpd.conf && true"]
