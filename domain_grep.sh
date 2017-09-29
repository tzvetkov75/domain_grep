#!/bin/bash
#
#  Extracts domain name from HTTP host header or TLS SNI extension to stdout from traffic on interface. 
#  
#  Generate a log-line for each accessed recourses. It can be used to generate very basic statistic of Internet usage in small networks. 
#  Can be used with port mirror on switches
#
#  There are some limitations:  
#    TLS	- SNI extension is part of the client_hello handshake. There is no information how long the session was, how many request, volume etc. 
#             User can browse 3h on the same page. IPv6 is supported but it is possible to miss some TLS handshakes - currently, IPv6/TCP header length is hard coded (BPF bug)
#    HTTP       - greps only GET requests for host header and only on first HTTP request in case of pipelining. There is not information on size etc 
#
# If there is no TLS SNI extension or HTTP host header no output is provides (older versions of SSL and HTTP 1.0)
#
#  Requirements: 
#	- unix (not tested on windows)
#	- awk 
#	- tcpdump
#	- tshark
#
#  Vesselin 19.09.2017 
#
#
#  License MIT 
#
set -u

test if `tshark` is available
tshark_path=`which tshark`
if [ -z $tshark_path ]; then
	echo 'Tshark is not available, please install it'
		exit 1
	fi


test if `tcpdump` is available
tcpdump_path=`which tcpdump`
if [ -z $tcpdump_path ]; then
	echo 'Tcpdump is not available, please install it'
		exit 2
	fi

	# if no argument then print help
if [ $# -lt 1 ]; then
	echo "provide network interface, for examplie eth0 or enp1s0"  	
	echo "the script will ask for sudo. Do not need to run with sudo (not nice bug)"  	
	echo ""
	echo "Usage: domain_grep.sh <device>" 
		exit 3
	fi

DEVICE="$1"

echo "listening on interface $DEVICE"
echo 
# not nice to use sudo inside, but seems bug buffer pipe output of tshark  
sudo tcpdump -i "$DEVICE" -l -s 1500 '(port 443 and ip6 and ip6[72:1]=0x16 and ip6[77:1]=0x01 ) or (port 80 and tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x47455420) or  (port 443 and (tcp[((tcp[12:1] & 0xf0) >> 2)+5:1] = 0x01) and (tcp[((tcp[12:1] & 0xf0) >> 2):1] = 0x16))' \
	-w -  | tshark -l -r - -T fields -e frame.time -e ip.src -e ipv6.src -e ssl.handshake.type -e http -e ssl.handshake.extensions_server_name -e http.host \
	-Y "ssl.handshake.extensions_server_name or http.host" | awk -f ./make_nice.awk


