FROM alpine:latest

RUN apk add --no-cache tinyproxy

# تعديل الإعدادات الافتراضية لتسمح بالوصول الخارجي
RUN sed -i 's/^#Allow 127.0.0.1/Allow 0.0.0.0/' /etc/tinyproxy/tinyproxy.conf && \
    sed -i 's/^Port 8888/Port 8080/' /etc/tinyproxy/tinyproxy.conf && \
    sed -i 's/^#LogLevel Info/LogLevel Info/' /etc/tinyproxy/tinyproxy.conf && \
    sed -i 's/^#DisableViaHeader Yes/DisableViaHeader Yes/' /etc/tinyproxy/tinyproxy.conf && \
    echo "ConnectPort 443" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "ConnectPort 80" >> /etc/tinyproxy/tinyproxy.conf

EXPOSE 8080
CMD ["tinyproxy", "-d"]
