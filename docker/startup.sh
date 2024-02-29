#!/bin/bash
# This script executes at startup, and provides the opportunity to specify a custom TTL for DNS results.

echo "Starting dnsmasq with a local TTL of: $LOCAL_DNS_TTL"
/usr/sbin/dnsmasq --local-ttl=$LOCAL_DNS_TTL -d
