########################################################
#DESCRIPTION = "Firewall Script to IPv4 and IPv6"      #
#PROCESSNAME = "firewall-thor.sh"                      #
#VERSION = "5.3.2"                                     #
#CREATED_BY = "Jeferson Padilha. All rigths reserved." #
#LICENSE = "MIT License"                               #
#E-MAIL = "jepasa@jepasa.com"                          #
#WEBSITE = "http://www.jepasa.com/"                    #
#USABILITY = "start|stop|restart|menu"                 #
########################################################
#
The Firewall-Thor, by Jeferson Padilha, is licensed under
the MIT License (MIT)

Copyright (c) 2019 jepasa.com - by Jeferson Padilha

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
========| Firewall-Thor Designed for IPTABLES |========
#
1º - Unzip the Firewall-thor in the current folder where you downloaded the server and then enter the uncompressed firewall-thor directory:
	tar -zxvf firewall-thor_vX.X.x.tar.gz
	cd firewall-thor
#
2º - In the firewall-thor.conf script you will be able to edit specific settings Firewall-Thor
		a) To configuration IP address by hostname
			i  - MYIPV4ADDRESS="192.168.10.254"				# Set the server IPv4
			II - MYIPV6ADDRESS="::1"						# Set the server IPv6
		b) To IP_FORWARD support configuration
			i  - IPFORWARDSUPPORT="no"                      # Enables IP_FORWARD redirection (no/yes) - Recommended="no" 
			ii - IPFORWARDETH="eth0"                        # Set the interface used for redirection
		c) To NAT support configuration
			i  - NATFORWARDSUPPORT="no"                     # Enable Internet sharing (no/yes) - Recomended="no" 
			ii - NATFORWARDETH="eth0"                       # Set the external interface used for sharing NAT
		d) To ICMP support Configuration
			i - ICMPSUPPORT="no"							# Allow ping response (no/yes) - Recommended="no"
			ii  - ICMPIPV4RANGEALLOW="192.168.10.0/20"      # IP Range to allow response in Ping on the IPv4 (0/0 to all)
			iii - ICMPIPV6RANGEALLOW="::1/128"              # IP Range to allow response in Ping on the IPv6 (0/0 to all)
		e) To IPTABLES IPV6 support configuration
			i - IPV6SUPPORT="no"							# Enable IPv6 in to Firewall? (no/yes) - Recommended="no"
		f) To LOGs support configuration
			i  - LOGSUPPORT="no"							# Allow iptables logs support? (no/yes)
        	ii - LOGSLEVEL="6"								# The logs priority level 
        								0 or ! = EMERG
        								1 or a = ALERT
        								2 or c = CRIT
        								3 or e = ERR
        								4 or w = WARNING
        								5 or n = NOTICE
        								6 or i = INFO
        								7 or d = DEBUG
		e) To SSH support configuration
			i    - SSHDSUPPORT="yes"						 # Customize security of SSH (no/yes). If it error, uninstall the firewall and mark "no" to install - Recommended="yes"
			ii   - SSHDPATH="/etc/ssh/sshd_config"			 # Configuration path SSHD
			iii  - SSHDNEWPORT="22"							 # Specify new port for SSH
			iv   - SSHDLISTENADDRESS="0.0.0.0"               # Specify IP internface with SSH access permission. Check SSH port in list/port_allow.list
			v    - SSHDPROTOCOL="2"							 # SSH protocol version - Recommended="2"
			vi   - SSHDLOGINGRACETIME="30"					 # Timeout to make an SSH connection to the server in seconds - Recommended="30"
			vii  - SSHDROOTLOGI="no"						 # Allow root login user on the SSH (yes/no) - Recommended="no"
			iix  - SSHDALLOWLOGIN="yes"						 # Specify unique sign in SSH to a group (default 'sudo') - Recommended="yes"
			ix   - SSHDX11FORWARDING="no"					 # Allow remote access in Graphical Mode X11 - Recommended="no"
			x    - SSHDBANNERPATH="$FPATH/list/banner.txt"	 # Set the path of BANNER for reading the Banner SSH
		f) To MAC ADDRESS support configuration
			i    - MACADDRESSSUPPORT="no"                    # Enable support to Mac Address access only (no/yes) - Recommended="no" || Recommended if MACADDRESSSTOIPSUPPORT="no"
			ii   - MACADDRESSSTOIPSUPPORT="no"               # Enable support to Mac Address access by IP only (no/yes) - Recommended="no" || Recommended if MACADDRESSSUPPORT="no"
		g) Para configurar o suporte ao erro NEIGHTBOUR OVERFLOW
			i    - SYSNEIGHBOURSUPPORT="no"                 # Enable support to NEIGHTBOUR TABLE OVERFLOW error - Recommended="no"
			ii   - SYSNEIGHBOURIPV4="/proc/sys/net/ipv4/neigh/default" # Patch to NEIGHTBOUR directory in IPv4
			iii  - SYSNEIGHBOURIPV6="/proc/sys/net/ipv6/neigh/default" # Patch to NEIGHTBOUR directory in IPv6
#
3º - In the firewall-thor/list folder, edit and add the allow/dany components in the document list respectively
		a) The list/mac_allow.list document contain the MAC ADDRESS list to allow
			i - Join Syntax: status_pc;mac_pc;name_pc
				Example: a;00:0E:A6:8E:1F:F2;Stive
				 		 b;00:0F:EA:2A:E0:36;Any

				PS. Attribution: a = allow and b = block
					Add or remove the whole line. This script does not support comments.
#
		b) The list/port_allow.list document contain the chain, protocol an the namber of ports list to allow
			i - Join Syntax: CHAIN;protocol;port_range;IPv4;IPv6
				Example: INPUT;tcp;22;0/0;::1/128
						 INPUT;tcp;53;0/0;2001::/32
						 INPUT;tcp;80;0/0;no
						 INPUT;tcp;443;0/0;no
						 INPUT;udp;53;0/0;2001::/32
						 INPUT;udp;80;0/0;no
						 INPUT;udp;123;0/0;no
						 INPUT;udp;161;0/0;no
						 INPUT;udp;443;0/0;no
						 OUTPUT;tcp;34;0/0;no
						 OUTPUT;tcp;53;0/0;2001::/32
						 OUTPUT;tcp;80;0/0;no
						 OUTPUT;tcp;443;0/0;no
						 OUTPUT;udp;53;0/0;2001::/32
						 OUTPUT;udp;80;0/0;no
						 OUTPUT;udp;123;0/0;no
						 OUTPUT;udp;161;0/0;no
						 OUTPUT;udp;443;0/0;no

				PS. Add or remove the whole line. This script does not support comments. To anule IPv4 or IPv6 set 'no' in place of IP
#
		c) The list/port_deny.list document contain the chain, protocol an the namber of ports list to deny
			i - Join Syntax: CHAIN;protocol;port_range
				Example: INPUT;tcp;0:21
						 INPUT;tcp;23:52
						 INPUT;tcp;54:79
						 INPUT;tcp;81:442
						 INPUT;tcp;444:65535
						 INPUT;udp;0:52
						 INPUT;udp;54:122
						 INPUT;udp;124:160
						 INPUT;udp;162:65535
						 OUTPUT;tcp;0:33
						 OUTPUT;tcp;35:52
						 OUTPUT;tcp;54:79
						 OUTPUT;tcp;81:442
						 OUTPUT;tcp;444:65535
						 OUTPUT;udp;0:52
						 OUTPUT;udp;54:79
						 OUTPUT;udp;81:122
						 OUTPUT;udp;124:160
						 OUTPUT;udp;162:442
						 OUTPUT;udp;444:65535
						 FORWARDER;tcp;0:65535

				PS. Add or remove the whole line. This script does not support comments.
#
		d) The list/redirect.list document contain the address redirect list
			i - Join Syntax: protocol;port;ip;name_server;name_host
				Example: tcp;4662;192.168.253.2;EMULE;debian-me
						 udp;4672;192.168.253.2;EMULE;debian-home
						 tcp;5900;192.168.253.2;VNC;debian-home

				PS. Add or remove the whole line. This script does not support comments.
#
		e)	The list/ipv4_deny.list document contain the IPv4 address list to DROP
			i - Join Syntax: CHAIN;ipaddress/mask or CHAIN;ipaddressonly
				Example: INPUT;43.229.53.0/24
						 OUTPUT;43.229.53.0/24
						 INPUT;36.70.19.0/24
						 INPUT;193.107.16.208
				PS. Consult the IP address blocks to specify the IP mask:
				Must Begin With		Number of IP Addresses		For Last Address Add
				xx.xx.xx.xx/32 		1			1				0.0.0.0
				xx.xx.xx.2n/31		2			2				0.0.0.1
				xx.xx.xx.4n/30		4			4				0.0.0.3
				xx.xx.xx.8n/29		8			8				0.0.0.7
				xx.xx.xx.16n/28		16			16				0.0.0.15
				xx.xx.xx.32n/27		32			32				0.0.0.31
				xx.xx.xx.64n/26		64			64				0.0.0.63
				xx.xx.xx.128n/25	128			128				0.0.0.127
				xx.xx.xx.0/24		256			256				0.0.0.255
				xx.xx.2n.0/23		512			256x2			0.0.1.255
				xx.xx.4n.0/22		1024		256x4			0.0.3.255
				xx.xx.8n.0/21		2048		256x8			0.0.7.255
				xx.xx.16n.0/20		4096		256x16			0.0.15.255
				xx.xx.32n.0/19		8192		256x32			0.0.31.255
				xx.xx.64n.0/18		16384		256x64			0.0.63.255
				xx.xx.128n.0/17		32768		256x128			0.0.127.255
				xx.xx.0.0/16		65536		256x256			0.0.255.255
				xx.2n.0.0/15		131072		256x256x2		0.1.255.255
				xx.4n.0.0/14		262144		256x256x4		0.3.255.255
				xx.8n.0.0/13		524288		256x256x8		0.7.255.255
				xx.16n.0.0/12		1048576		256x256x16		0.15.255.255
				xx.32n.0.0/11		2097152		256x256x32		0.31.255.255
				xx.64n.0.0/10		4194304		256x256x64		0.63.255.255
				xx.128n.0.0/9		8388608		256x256x128		0.127.255.255
				xx.0.0.0/8			16777216	256x256x256		0.255.255.255
				2n.0.0.0/7			33554432	256x256x256x2	1.255.255.255
				4n.0.0.0/6			67108864	256x256x256x4	3.255.255.255
				8n.0.0.0/5			134217728	256x256x256x8	7.255.255.255
				16n.0.0.0/4			268435456	256x256x256x16	15.255.255.255
				32n.0.0.0/3			536870912	256x256x256x32	31.255.255.255
				64n.0.0.0/2			1073741824	256x256x256x64	63.255.255.255
				128n.0.0.0/1		2147483648	256x256x256x128	127.255.255.255
				0.0.0.0/0			4294967296	256x256x256x256	255.255.255.255
#
		f)	The list/ipv6_deny.list document contain the IPv6 address list to DROP
			i - Join Syntax: CHAIN;ipaddress/mask or CHAIN;ipaddressonly
				Example: INPUT;2803:f800::/32
						 OUTPUT;2803:f800::/32
						 INPUT;2606:4700::/32
				PS. Consult the IPv6 address blocks to specify the IP mask:
				https://www.ripe.net/about-us/press-centre/understanding-ip-addressing
#
		g) The list/ipv4tomac_allow.list document contain the IPv4 to MAC ADDRESS list for allow
			i - Join Syntax: status_pc;ip_pc;mac_pc;name_pc
				Example: a;192.168.253.2;00:0E:A6:8E:1F:F2;Stive
				 		 b;192.168.253.3;00:0F:EA:2A:E0:36;Any

				PS. Attribution: a = allow and b = block
					Add or remove the whole line. This script does not support comments.
#
		g) The list/ipv6tomac_allow.list document contain the IPv6 to MAC ADDRESS list for allow
			i - Join Syntax: status_pc;ip_pc;mac_pc;name_pc
				Example: a;::1;00:0E:A6:8E:1F:F2;Stive
				 		 b;FF02::1;00:0F:EA:2A:E0:36;Any

				PS. Attribution: a = allow and b = block
					Add or remove the whole line. This script does not support comments.
#
4º - Check the main source script (script/thorsource) and comment or uncomment the functionality as desired.
#
6º - After you configure the Firewall-Thor, adding the allowed and denied door, it's time to install Firewall-Thor:
		./install-remove_thor.sh
#
6º - The script install auto add the command line in the of the script rc.x (/etc/init.d/firewall-thor)
#
7º - Restart you server
#
PS. To start, stop or restart the Thor Firewall, enter one of the following command lines:
	service firewall-thor start
	service firewall-thor stop
	service firewall-thor restart
	service firewall-thor menu
#
