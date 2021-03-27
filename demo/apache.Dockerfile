ARG BASE_IMAGE
FROM ${BASE_IMAGE}
WORKDIR /root
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -y apache2
COPY apache-default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf
RUN a2enmod ssl
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/usr/sbin/apachectl start && sleep 2 && tail -n+0 -f /var/log/apache2/error.log"]
