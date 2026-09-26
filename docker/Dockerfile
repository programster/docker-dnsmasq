FROM debian:13

# Specify the DNS_TTL to 0 by default. The user can override this at runtime.
ENV LOCAL_DNS_TTL=0

RUN apt-get update && apt-get dist-upgrade -y && apt-get install dnsmasq logrotate -y

COPY --chmod=640 logrotate.conf /etc/logrotate.d/dnsmasq
COPY dnsmasq.conf /etc/dnsmasq.conf
COPY resolv.dnsmasq.conf /etc/resolv.dnsmasq.conf

EXPOSE 5353
VOLUME /logs

# Create dnsmasq user to run everything so can read log files on host easily
# later, without hitting logrotate issues.
RUN groupadd -g 1000 dnsmasq

COPY remap-user.sh /root/remap-user.sh
COPY startup.sh /root/startup.sh
ENTRYPOINT ["/bin/bash", "/root/startup.sh"]

