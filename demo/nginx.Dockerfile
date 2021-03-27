ARG BASE_IMAGE
FROM ${BASE_IMAGE}
WORKDIR /root
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -y nginx
COPY nginx.conf /etc/nginx/
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["nginx && sleep 2 && tail -n+0 -f /var/log/nginx/error.log"]
