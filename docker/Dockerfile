FROM debian:12

# Specify the DNS_TTL to 0 by default. The user can override this at runtime.
ENV LOCAL_DNS_TTL=0

RUN apt-get update && apt-get dist-upgrade -y && apt-get install dnsmasq -y

COPY dnsmasq.conf /etc/dnsmasq.conf
COPY resolv.dnsmasq.conf /etc/resolv.dnsmasq.conf

EXPOSE 5353

COPY startup.sh /root/startup.sh
ENTRYPOINT ["/bin/bash", "/root/startup.sh"]

