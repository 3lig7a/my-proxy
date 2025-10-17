FROM alpine:latest

RUN apk add --no-cache dante-server

RUN echo "logoutput: stdout" > /etc/sockd.conf && \
    echo "internal: 0.0.0.0 port = 1080" >> /etc/sockd.conf && \
    echo "external: eth0" >> /etc/sockd.conf && \
    echo "method: username none" >> /etc/sockd.conf && \
    echo "user.notprivileged: nobody" >> /etc/sockd.conf && \
    echo "client pass {" >> /etc/sockd.conf && \
    echo "    from: 0.0.0.0/0 to: 0.0.0.0/0" >> /etc/sockd.conf && \
    echo "    log: connect disconnect error" >> /etc/sockd.conf && \
    echo "}" >> /etc/sockd.conf && \
    echo "pass {" >> /etc/sockd.conf && \
    echo "    from: 0.0.0.0/0 to: 0.0.0.0/0" >> /etc/sockd.conf && \
    echo "    protocol: tcp udp" >> /etc/sockd.conf && \
    echo "}" >> /etc/sockd.conf

EXPOSE 1080
CMD ["sockd", "-f", "/etc/sockd.conf"]
