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
function installDeb() {
	echo -e " |                                                        |"
	if [[ -e /etc/init.d/firewall-thor ]]; then
		echo -e " | Configurando autostart-on-boot ...                     |"
        echo -e " | ERRO: O arquivo /etc/init.d/firewall-thor ja existe!   |"
        echo -e " |                                                        |"
        echo -e " |========================================================|"
	    FOOTERPRINT=" |    REMOVA O FIREWALL-THOR ANTES DE INSTALAR O NOVO!    |"
	    footer
	    sleep 2
	    exit 127
    else
        echo -e " | Configurando autostart-on-boot ...                     |"
	    cp -r /opt/firewall-thor/scripts/firewall-thor /etc/init.d/
	    chown root:root /etc/init.d/firewall-thor
	    chmod +x /etc/init.d/firewall-thor
	    update-rc.d firewall-thor defaults 2 95 1> /dev/null 2> /dev/stdout
        echo -e " | ... OK                                                 |"
	    echo -e " |                                                        |"
        echo -e " |========================================================|"
    fi
    if [ -e /opt/firewall-thor/backups/sshd_config-bkp_origianl ]; then
        cp -r /etc/ssh/sshd_config /opt/firewall-thor/backups/sshd_config-bkp_`date +%d%m%Y_%H%M%S`
    else
        cp -r /etc/ssh/sshd_config /opt/firewall-thor/backups/sshd_config-bkp_origianl
    fi
    cat /opt/firewall-thor/scripts/sshd_config-exemple_deb > /etc/ssh/sshd_config
}
function installRedhat() {
    if [[ -e /etc/init.d/firewall-thor ]]; then
        echo -e " | Configurando autostart-on-boot ...                     |"
        echo -e " | ERRO: O arquivo /etc/init.d/firewall-thor ja existe!   |"
        echo -e " |                                                        |"
        echo -e " |========================================================|"
        FOOTERPRINT=" |    REMOVA O FIREWALL-THOR ANTES DE INSTALAR O NOVO!    |"
        footer
        sleep 2
        exit 127
    else
        echo -e " | Configurando autostart-on-boot ...                     |"
        cp -r /opt/firewall-thor/scripts/firewall-thor /etc/init.d/
        chown root:root /etc/init.d/firewall-thor
        chmod +x /etc/init.d/firewall-thor
        chkconfig --add firewall-thor 1> /dev/null 2> /dev/stdout
        echo -e " | ... OK                                                 |"
        echo -e " |                                                        |"
        echo -e " |========================================================|"
	fi
    if [ -e /opt/firewall-thor/backups/sshd_config-bkp_origianl ]; then
        cp -r /etc/ssh/sshd_config /opt/firewall-thor/backups/sshd_config-bkp_`date +%d%m%Y_%H%M%S`
    else
        cp -r /etc/ssh/sshd_config /opt/firewall-thor/backups/sshd_config-bkp_origianl
    fi
    cat /opt/firewall-thor/scripts/sshd_config-exemple_hat > /etc/ssh/sshd_config
}
function installThor(){
    echo -e " |========================================================|"
    echo -e " |                                                        |"
    echo -e " | Reconhecendo diretorio atual ...                       |"
    LOCALFILE=`pwd`
    echo -e " | ${LOCALFILE} ... OK"
    echo -e " |                                                        |"
    echo -e " | Criando diretório de instalacao ...                    |"
    if [[ -d /opt/firewall-thor ]] ; then
        echo -e " | O diretorio /opt/firewall-thor ja existe!              |"
        echo -e " |                                                        |"
        echo -e " |========================================================|"
	    FOOTERPRINT=" |    REMOVA O FIREWALL-THOR ANTES DE INSTALAR O NOVO!    |"
	    footer
	    sleep 2
	    exit 127
    else
	    mkdir /opt/firewall-thor
        mkdir /etc/firewall-thor
        echo -e " | ... OK                                                 |"
	fi
    echo -e " |                                                        |"
    echo -e " | Copiando arquivos de instalcao ...                     |"
    cp -r $LOCALFILE/* /opt/firewall-thor
    cd /etc/firewall-thor/
    ln -s /opt/firewall-thor/firewall-thor.conf firewall-thor.conf
    ln -s /opt/firewall-thor/firewall-thor.sh firewall-thor.sh
    ln -s /opt/firewall-thor/list/port_allow.list port_allow.list
    ln -s /opt/firewall-thor/list/port_deny.list port_deny.list
    ln -s /opt/firewall-thor/list/ipv4_deny.list ipv4_deny.list
    ln -s /opt/firewall-thor/list/ipv6_deny.list ipv6_deny.list
    ln -s /opt/firewall-thor/list/redirect.list redirect.list
    echo -e " | ... OK                                                 |"

    echo -e " |                                                        |"
    echo -e " | Preparando grupo de acesso ao SSH ...                  |"
    SSHMYGROUP=$( cat /etc/group | grep ^sudo | cut -d ':' -f 1 )
    if [ -z $SSHMYGROUP ]; then
        groupadd sudo
    fi
    echo -e " | ... OK                                                 |"
    echo -e " |                                                        |"
    echo -e " | Definindo permissoes para o diretorio ...              |"
    chown -R root:root /etc/firewall-thor
    chown -R root:root /opt/firewall-thor
    chmod 750 /opt/firewall-thor/firewall-thor.sh
    chmod 444 /opt/firewall-thor/CC_Attribution-NonCommercial-NoDerivatives_4.0_International.xmp
    chmod 444 /opt/firewall-thor/README.txt
    chmod 444 /opt/firewall-thor/LEIAME.txt
    chmod 440 /opt/firewall-thor/scripts/thorfunctions
    chmod 750 /opt/firewall-thor/scripts/thorsource
    chmod 640 /opt/firewall-thor/list/*.list
    chmod 755 /opt/firewall-thor/scripts/firewall-thor
    cd ~/
    echo -e " | ... OK                                                 |"
}
function removeDeb() {
	echo -e " |                                                        |"
	echo -e " | Removendo configuracoes autostart-on-boot ...          |"
    update-rc.d -f firewall-thor remove 1> /dev/null 2> /dev/stdout
    if [[ -e /etc/init.d/firewall-thor ]]; then
        rm -Rf /etc/init.d/firewall-thor
    fi
    echo -e " | ... OK                                                 |"
    echo -e " |                                                        |"
    echo -e " |========================================================|"
}
function removeRedhat(){
	echo -e " |                                                        |"
	echo -e " | Removendo configuracoes autostart-on-boot ...          |"
    chkconfig --del firewall-thor 1> /dev/null 2> /dev/stdout
    if [[ -e /etc/init.d/firewall-thor ]]; then
        rm -Rf /etc/init.d/firewall-thor
    fi
    echo -e " | ... OK                                                 |"
    echo -e " |                                                        |"
    echo -e " |========================================================|"
}
function removeThor(){
    echo -e " |========================================================|"
    echo -e " |                                                        |"
    echo -e " | Efetuando backup do Firewall-Thor para /root/ ...      |"
    cd /opt/
    tar -zcf firewall-thor-backup-bkp_`date +%d%m%Y_%H%M%S`.tgz firewall-thor
    mv firewall-thor-backup-bkp_* /root/
    echo -e " | ... OK                                                 |"
    echo -e " |                                                        |"
    echo -e " | Restaurando o arquivo sysctl.conf em /etc/ ...         |"
    if [[ -e /opt/firewall-thor/backup/sysctl.conf-bkp_origianl ]]; then
    	cp -r /opt/firewall-thor/backup/sysctl.conf-bkp_origianl /etc/sysctl.conf
        echo -e " | ... OK                                                 |"
    else
    	echo -e " | OOPS: O arquivo sysctl.conf não pode ser restaurado.   |"
	    echo -e " | CALMA: Isso pode significar que o original nao foi     |"
	    echo -e " | alterado pelo Firewall-Thor.                           |"
	fi
    echo -e " |                                                        |"
    echo -e " | Restaurando o arquivo sshd_config em /etc/ssh/ ...     |"
    if [[ -e /opt/firewall-thor/backup/sshd_config-bkp_origianl ]]; then
        cp -r /opt/firewall-thor/backup/sshd_config-bkp_origianl /etc/ssh/sshd_config
        echo -e " | ... OK                                                 |"
    else
        echo -e " | OOPS: O arquivo sshd_config não pode ser restaurado.   |"
        echo -e " | CALMA: Isso pode significar que o original nao foi     |"
        echo -e " | alterado pelo Firewall-Thor.                           |"
    fi
    echo -e " |                                                        |"
    echo -e " | Restaurando o arquivo gc_thresh1 em /proc/sys/net ...  |"
    if [[ -e /opt/firewall-thor/backup/gc_thresh1-bkp_origianl ]]; then
        cp -r /opt/firewall-thor/backup/gc_thresh1-bkp_origianl /proc/sys/net/ipv4/neigh/default/gc_thresh1
        cp -r /opt/firewall-thor/backup/gc_thresh1-bkp_origianl /proc/sys/net/ipv6/neigh/default/gc_thresh1
        echo -e " | ... OK                                                 |"
    else
        echo -e " | OOPS: O arquivo gc_thresh1 não pode ser restaurado.    |"
        echo -e " | CALMA: Isso pode significar que o original nao foi     |"
        echo -e " | alterado pelo Firewall-Thor.                           |"
    fi
    echo -e " |                                                        |"
    echo -e " | Restaurando o arquivo gc_thresh2 em /proc/sys/net ...  |"
    if [[ -e /opt/firewall-thor/backup/gc_thresh2-bkp_origianl ]]; then
        cp -r /opt/firewall-thor/backup/gc_thresh2-bkp_origianl /proc/sys/net/ipv4/neigh/default/gc_thresh2
        cp -r /opt/firewall-thor/backup/gc_thresh2-bkp_origianl /proc/sys/net/ipv6/neigh/default/gc_thresh2
        echo -e " | ... OK                                                 |"
    else
        echo -e " | OOPS: O arquivo gc_thresh2 não pode ser restaurado.    |"
        echo -e " | CALMA: Isso pode significar que o original nao foi     |"
        echo -e " | alterado pelo Firewall-Thor.                           |"
    fi
    echo -e " |                                                        |"
    echo -e " | Restaurando o arquivo gc_thresh3 em /proc/sys/net ...  |"
    if [[ -e /opt/firewall-thor/backup/gc_thresh3-bkp_origianl ]]; then
        cp -r /opt/firewall-thor/backup/gc_thresh3-bkp_origianl /proc/sys/net/ipv4/neigh/default/gc_thresh3
        cp -r /opt/firewall-thor/backup/gc_thresh3-bkp_origianl /proc/sys/net/ipv6/neigh/default/gc_thresh3
        echo -e " | ... OK                                                 |"
    else
        echo -e " | OOPS: O arquivo gc_thresh3 não pode ser restaurado.    |"
        echo -e " | CALMA: Isso pode significar que o original nao foi     |"
        echo -e " | alterado pelo Firewall-Thor.                           |"
    fi
    echo -e " |                                                        |"
    echo -e " | Restaurando o arquivo hosts.allow em /etc/ ...         |"
    echo -e " | OOPS: O arquivo hosts.allow não pode ser restaurado.   |"
    echo -e " | CALMA: Ha um backup do original em                     |"
    echo -e " | /root/firewall-thor-bkp_*.tgz                          |"
    echo -e " |                                                        |"
    echo -e " | Restaurando o arquivo hosts.deny em /etc/ ...          |"
    echo -e " | OOPS: O arquivo hosts.deny não pode ser restaurado.    |"
    echo -e " | CALMA: Ha um backup do original em                     |"
    echo -e " | /root/firewall-thor-bkp_*.tgz                          |"
    echo -e " |                                                        |"
    echo -e " | Removendo o Firewall-Thor ...                          |"
    cd /opt
    rm -Rf firewall-thor
    cd /etc/
    rm -Rf firewall-thor
    cd /root/
    echo -e " | ... OK                                                 |"
}
function header() {
    echo -e ""
    echo -e " |========================================================|"
    echo -e " |                     FIREWALL-THOR                      |"
    echo -e " |--------------------------------------------------------|"
    echo -e "${HEADERPRINT}"
    echo -e " |========================================================|"
    echo -e "                            | |"
}
function footer() {
    echo -e "                            | |"
    echo -e " |======================| ATENCAO |=======================|"
    echo -e "${FOOTERPRINT}"
    echo -e " |========================================================|"
    echo $TXTRESET
    sleep 1
}
if [ $(id -u) -ne 0 ]; then
    HEADERPRINT=" |                   ARGUMENTO INVALIDO                   |"
    FOOTERPRINT=" |     VOCE PRECISA DOS PODERES ROOT PARA O INSTALAR!     |"
    header
    footer
    sleep 2
    exit 1
else
    echo -e " |========================================================|"
    echo -e " | Digite o numero equivalente a opcao desejada.          |"
    echo -e " |                                                        |"
    echo -e " | 1 - Instalar o Firewall-Thor;                          |"
    echo -e " | 2 - Remover o Firewall-Thor;                           |"
    echo -e " | 0 - Sair deste menu;                                   |"
    echo -e " |========================================================|"
    echo -e "                            | |"
    echo -e " |=======================| DIGITO |=======================|"
    echo -n " | => "
    read mymenu
    echo -e " |========================================================|"
    echo -e ""
    case  "$mymenu" in
        1)
            HEADERPRINT=" |                INSTALANDO FIREWALL-THOR                |"
            FOOTERPRINT=" |          FIREWALL-THOR INSTALADO COM SUCESSO!          |"
            header
            debian=`cat /etc/*-release | grep Debian`
            ubuntu=`cat /etc/*-release | grep Ubuntu`
            centos=`cat /etc/*-release | grep CentOS`
            suse=`cat /etc/*-release | grep SUSE`
            if [[ ! -z $debian ]] ; then
                distro="debian"
            elif [[ ! -z $ubuntu ]] ; then
                distro="ubuntu"
            elif [[ ! -z $centos ]] ; then
                distro="centos"
            elif [[ ! -z $suse ]] ; then
                distro="suse"
            else
                nosupport
            fi
            case $distro in
                "debian")
                    installThor
                    installDeb
                ;;

                "ubuntu")
                    installThor
                    installDeb
                ;;

                "centos")
                    installThor
                    installRedhat
                ;;

                "suse")
                    installThor
                    installRedhat
                ;;
                *)
                    FOOTERPRINT=" |        ERRO: SISTEMA OPERACIONAL DESCONHECIDO!         |"
                    footer
                    sleep 2
                    exit 127
            esac
            footer
            sleep 1
            if [[ -e /opt/firewall-thor/firewall-thor.sh ]]; then
		        /opt/firewall-thor/firewall-thor.sh start
		    else
		    	echo -e "\nERRO: Não foi possivel iniciar o Firewall-Thor"
		    	echo -e "Arquivo /opt/firewall-thor/firewall-thor.sh não encontrado!\n"
		    fi
            exit 0
        ;;
        2)
            HEADERPRINT=" |                 REMOVENDO FIREWALL-THOR                |"
            FOOTERPRINT=" |           FIREWALL-THOR REMOVIDO COM SUCESSO!          |"
            if [[ -e /opt/firewall-thor/firewall-thor.sh ]]; then
		        /opt/firewall-thor/firewall-thor.sh stop
		    fi
            header
            debian=`cat /etc/*-release | grep Debian`
            ubuntu=`cat /etc/*-release | grep Ubuntu`
            centos=`cat /etc/*-release | grep CentOS`
            xenserver=`cat /etc/*-release | grep XenServer`
            suse=`cat /etc/*-release | grep SUSE`
            if [[ ! -z $debian ]] ; then
                distro="debian"
            elif [[ ! -z $ubuntu ]] ; then
                distro="ubuntu"
            elif [[ ! -z $centos ]] ; then
                distro="centos"
            elif [[ ! -z $xenserver ]] ; then
                distro="xenserver"
            elif [[ ! -z $suse ]] ; then
                distro="suse"
            else
                nosupport
            fi
            case $distro in
                "debian")
                    removeThor
                    removeDeb
                ;;

                "ubuntu")
                    removeThor
                    removeDeb
                ;;

                "centos")
                    removeThor
                    removeRedhat
                ;;

                "xenserver")
                    installThor
                    installRedhat
                ;;

                "suse")
                    removeThor
                    removeRedhat
                ;;
                *)
                    FOOTERPRINT=" |        ERRO: SISTEMA OPERACIONAL DESCONHECIDO!         |"
                    footer
                    sleep 2
                    exit 127
            esac
            footer
            sleep 1
            exit 0
		;;
		0)
			exit 0
		;;
		*)
            HEADERPRINT=" |                   ARGUMENTO INVALIDO                   |"
            FOOTERPRINT=" |                SAINDO DESTE APLICATIVO                 |"
            header
            footer
            sleep 1
            exit 1
    esac
fi
