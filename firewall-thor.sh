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
#==============| IMPORT CONFIGURATIONS |=================
	source /opt/firewall-thor/firewall-thor.conf
#==============| IMPORT FUNCTIONS |=================
	source $THORFUNCTIONS
#==============| CORPO DO SCRIPT |=================
case "$1" in
	start)
			HEADERPRINT="${TXTGREEN} |${TXTYELLOW}          CARREGANDO CONFIGURACOES DO FIREWALL          ${TXTGREEN}|"
			FOOTERPRINT="${TXTGREEN} |${TXTYELLOW}                   FIREWALL CARREGADO!                  ${TXTGREEN}|"
			header
			check_user
			check_iptables
			check_modules
			check_backup
			check_source 
			footer
	;;
	stop)
			HEADERPRINT="${TXTGREEN} |${TXTYELLOW}            PARANDO CONFIGURACOES DO FIREWALL           ${TXTGREEN}|"
			FOOTERPRINT="${TXTGREEN} |${TXTYELLOW}                    FIREWALL PARADO!                    ${TXTGREEN}|"
			header
			check_user
			check_iptables
			clean_iptables
			footer
	;;
	restart)
			$PROGRAM stop
			$PROGRAM start
	;;
	status)
			HEADERPRINT="${TXTGREEN} |${TXTYELLOW}              LISTANDO STATUS DO FIREWALL!              ${TXTGREEN}|"
			FOOTERPRINT="${TXTGREEN} |${TXTYELLOW}                     FIM DA LISTA!                      ${TXTGREEN}|"
			header
			check_user
			check_iptables
			check_status
			footer
	;;
	logs)
			HEADERPRINT="${TXTGREEN} |${TXTYELLOW}               LISTANDO LOGS DO FIREWALL!               ${TXTGREEN}|"
			FOOTERPRINT="${TXTGREEN} |${TXTYELLOW}                     FIM DA LISTA!                      ${TXTGREEN}|"
			header
			check_user
			check_iptables
			check_logs
			footer
	;;
	menu)
						 
			HEADERPRINT="${TXTGREEN} |${TXTYELLOW}                     MENU PRINCIPAL                     ${TXTGREEN}|"
			header
			check_user
			check_menu
	;;
	*)
						 
			HEADERPRINT="${TXTGREEN} |${TXTYELLOW}                     MENU PRINCIPAL                     ${TXTGREEN}|"
			header
			check_user
			check_menu						
esac
exit 0
