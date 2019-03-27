#!/bin/bash 
#DESCRIPTION = "Firewall Script to IPv4 and IPv6"      #
#PROCESSNAME = "firewall-thor.sh"                      #
#VERSION = "5.3.2"                                     #
#CREATED_BY = "Jeferson Padilha. All rigths reserved." #
#LICENSE = "MIT License"                               #
#E-MAIL = "jepasa@jepasa.com"                          #
#WEBSITE = "http://www.jepasa.com/"                    #
#USABILITY = "start|stop|restart|menu"                 #
########################################################
#           See README.txt to Configurations           #
########################################################
#==============| DECLARE FUNCTIONS |=================

if [[ -e /opt/firewall-thor/firewall-thor.sh ]]; then
	ln -s /opt/firewall-thor/firewall-thor.sh start-firewall
	/opt/firewall-thor/firewall-thor.sh start
else
	./install-remove_thor.sh
fi