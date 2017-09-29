# Domain Grap

Extracts domain name from HTTP host header or TLS SNI extension to stdout from traffic on interface. 
  
## Description
Generate a log-line for each accessed recourses. It can be used to generate very basic statistic of Internet usage in small networks. Can be used with port mirror on switches. 


## Similarity to DNS statistics
It can be see as more accurate to DNS statistics because of the DNS caching (hosts use DNS cache to avoid resolving every time). On the other hand, TLS SNI also does not contain every request, since multiple request can be made 


#  There are some limitations:  
- TLS SNI extension is part of the client_hello handshake. There is no information how long the session was, how many request, volume etc. 
- User can browse 3h on the same page. IPv6 is supported but it is possible to miss some TLS handshakes - currenlty, IPv6/TCP header lenght is hardcoded (BPF bug)
- HTTP- greps only GET requests for host header and only on first HTTP request in case of pipelining. There is not information on size etc 

 If there is no TLS SNI extension or HTTP host header no output is provides (older versions of SSL and HTTP 1.0)

##  Requirements: 
- unix (not tested on windows)
- awk 
- tcpdump
- tshark

## Known bugs 
 Sudo in the script :-( do not need to run it with sudo. Need to be fixed. IPv6 header length is hardcoded due to BPF bug. Some IPv6 packets can be missed.  


## Output format 

Delimiter is tab  \t 

	Date  \t  "Domain_Grep"  \t  Source LAN IP \t Destination domain

## Example 

```
# ./domain_grap.sh eth0
listening on interface eth0

tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 1500 bytes
Sep 29, 2017 13:46:05.756451000 CEST	Domain_grep	192.168.1.36	https://www.wired.com
Sep 29, 2017 13:46:05.766029000 CEST	Domain_grep	192.168.1.36	https://acs.lavasoft.com
Sep 29, 2017 13:46:05.904757000 CEST	Domain_grep	192.168.1.36	https://assets.adobedtm.com
Sep 29, 2017 13:46:05.906292000 CEST	Domain_grep	192.168.1.36	https://media.wired.com
Sep 29, 2017 13:46:05.906807000 CEST	Domain_grep	192.168.1.36 	https://media.wired.com

```
