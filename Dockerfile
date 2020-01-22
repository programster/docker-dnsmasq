FROM alpine:3.11

RUN apk add --update --no-cache dnsmasq

COPY dnsmasq.conf /etc/
COPY resolv.dnsmasq.conf /etc/

VOLUME /dnsmasq.hosts

EXPOSE 5353

ENTRYPOINT ["/usr/sbin/dnsmasq", "-d"]

