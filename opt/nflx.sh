#!/usr/local/bin/sh

FAIL=0

if xtables-multi iptables-save | grep -qF 'j NFLXBLOCK_FWD'; then
	echo 'NflxBlock chain OK'
else
	echo 'NflxBlock chain FAIL'
	iptables -N NFLXBLOCK_FWD
	iptables -I FORWARD -s 192.168.2.0/24 -j NFLXBLOCK_FWD
	FAIL=1
fi

if xtables-multi iptables-save | grep -qF 'j NFLXBLOCK_DNSNAT'; then
	echo 'NflxDnsNAT chain OK'
else
	echo 'NflxDnsNAT chain FAIL'
	iptables -t nat -N NFLXBLOCK_DNSNAT
	iptables -t nat -I PREROUTING -s 192.168.2.0/24 -j NFLXBLOCK_DNSNAT
	FAIL=1
fi

if [ $FAIL -eq 0 ]; then
	echo 'All good -> quit'
	exit 0
fi

echo 'Redoing chains'

iptables -F NFLXBLOCK_FWD

# NFLX subnets
iptables -A NFLXBLOCK_FWD -d 108.175.32.0/255.255.240.0 -j REJECT
iptables -A NFLXBLOCK_FWD -d 198.38.96.0/255.255.224.0 -j REJECT
iptables -A NFLXBLOCK_FWD -d 198.45.48.0/255.255.240.0 -j REJECT
iptables -A NFLXBLOCK_FWD -d 185.2.220.0/255.255.252.0 -j REJECT
iptables -A NFLXBLOCK_FWD -d 23.246.0.0/255.255.192.0 -j REJECT
iptables -A NFLXBLOCK_FWD -d 37.77.184.0/255.255.248.0 -j REJECT
iptables -A NFLXBLOCK_FWD -d 45.57.0.0/255.255.128.0 -j REJECT

# DNS NAT
iptables -t nat -F NFLXBLOCK_DNSNAT

# Core
iptables -t nat -A NFLXBLOCK_DNSNAT -s 192.168.2.1 -j RETURN
iptables -t nat -A NFLXBLOCK_DNSNAT -s 192.168.2.2 -j RETURN
iptables -t nat -A NFLXBLOCK_DNSNAT -s 192.168.2.3 -j RETURN
iptables -t nat -A NFLXBLOCK_DNSNAT -s 192.168.2.4 -j RETURN
iptables -t nat -A NFLXBLOCK_DNSNAT -s 192.168.2.5 -j RETURN
iptables -t nat -A NFLXBLOCK_DNSNAT -s 192.168.2.6 -j RETURN
iptables -t nat -A NFLXBLOCK_DNSNAT -s 192.168.2.7 -j RETURN
iptables -t nat -A NFLXBLOCK_DNSNAT -s 192.168.2.8 -j RETURN
iptables -t nat -A NFLXBLOCK_DNSNAT -s 192.168.2.9 -j RETURN

# PC
iptables -t nat -A NFLXBLOCK_DNSNAT -s 192.168.2.50 -j RETURN
iptables -t nat -A NFLXBLOCK_DNSNAT -s 192.168.2.51 -j RETURN
iptables -t nat -A NFLXBLOCK_DNSNAT -s 192.168.2.52 -j RETURN
iptables -t nat -A NFLXBLOCK_DNSNAT -s 192.168.2.70 -j RETURN
iptables -t nat -A NFLXBLOCK_DNSNAT -s 192.168.2.71 -j RETURN
iptables -t nat -A NFLXBLOCK_DNSNAT -s 192.168.2.72 -j RETURN

# Other
iptables -t nat -A NFLXBLOCK_DNSNAT -p udp --dport 53 -j DNAT --to-destination 192.168.2.6
iptables -t nat -A NFLXBLOCK_DNSNAT -p tcp --dport 53 -j DNAT --to-destination 192.168.2.6
