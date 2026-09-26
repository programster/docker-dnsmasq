#!/bin/sh
set -e

# perform user remapping if necessary
/bin/bash /root/remap-user.sh

# ensure log file exists and has correct permissions, otherwise logrotate wont work.
mkdir -p /logs
chmod 640 /logs/* && chmod 750 /logs
chown --recursive dnsmasq:dnsmasq /logs

# This script executes at startup, and provides the opportunity to specify a custom TTL for DNS results.
echo "Starting dnsmasq with a local TTL of: ${LOCAL_DNS_TTL}"

exec /usr/sbin/dnsmasq \
  --local-ttl="${LOCAL_DNS_TTL}" \
  --log-facility=/logs/dnsmasq.log \
  --log-queries \
  --log-async \
  --pid-file=/var/run/dnsmasq.pid \
  --keep-in-foreground
