FROM alpine:latest

RUN apk add --update openssh autossh supervisor && rm  -rf /tmp/* /var/cache/apk/*

COPY portforward.sh /usr/local/bin/portforward
RUN chmod +x /usr/local/bin/portforward

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisor/conf.d/supervisord.conf"]
