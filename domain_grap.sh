#!/bin/bash
#
#  Extract the domain name from HTTP host header or TLS SNI extension to stdout from all traffic on interface. 
#  
#  Generate a line log pro accessed recourses. It can be used to get information for the tragic from small home network. It makes very basic and uncertain statistic on the usage.  
#
#  There are some limitations  
#    TLS	- SNI extension is part of the client_hello handshake. There is no information how long the session was, how many request, volume etc. User can browse 3h on the same page.
#    HTTP       - host header can present only on first HTTP rehouse access in the case of pipelining. There is not information on size etc 
#
# If there is no TLS SNI extension or HTTP host header no output is provides (older versions of SSL and HTTP 1.0)
#
#  Requirements: 
#	- unix (not tested on windows)
#	- awk 
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


# if no argument then print help
if [ $# -lt 1 ]; then
	echo "provide network interface, for exampel eth0 or enp1s0"  	
	echo "it requires privilidged user, so you can bind to the interface, aka sudo or root"  	
	echo ""
	echo "Usage: domain_grep.sh <devide>" 
		exit 2
	fi

DEVICE="$1"

echo "listening on interface $DEVICE"

# not nice to use sudo inside, but seems bug buffer pipe output of tshark  
sudo tshark  -q -l -i "$DEVICE" -T fields -e frame.time -e ip.src -e ipv6.src -e ssl.handshake.type -e http -e ssl.handshake.extensions_server_name -e http.host  -Y "ssl.handshake.extensions_server_name or http.host" | awk -f ./make_nice.awk 
