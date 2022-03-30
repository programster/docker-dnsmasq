FROM debian:11

RUN apt-get update && apt-get dist-upgrade -y && apt-get install dnsmasq -y

COPY dnsmasq.conf /etc/
COPY resolv.dnsmasq.conf /etc/

VOLUME /dnsmasq.hosts

EXPOSE 5353

ENTRYPOINT ["/usr/sbin/dnsmasq", "-d"]

