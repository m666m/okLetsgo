#!/bin/bash
# https://github.com/jacyl4/de_GWD/raw/main/client
clear
RED='\E[1;31m'
GREEN='\E[1;32m'
YELLOW='\E[1;33m'
BLUE='\E[1;34m'
PURPLE='\E[1;35m'
CYAN='\E[1;36m'
WHITE='\E[1;37m'
cRES='\E[0m'

chmod 777 /tmp
architecture=$(dpkg --print-architecture)
export DEBIAN_FRONTEND=noninteractive
piholeCoreRelease_reserved="v5.9"
piholeFTLRelease_reserved="v5.14"
piholeWebUIRelease_reserved="v5.11"
TTYD_Ver="1.6.3"
branch="main"


installCMD=`cat << EOF
bash <(wget --no-check-certificate -qO- https://de-gwd.accxio.workers.dev/client)
EOF
`


if [[ $architecture = "arm64" ]];then
chnAPTsource="mirrors.tuna.tsinghua.edu.cn"
elif [[ $architecture = "amd64" ]]; then
chnAPTsource="mirrors.aliyun.com"
fi

pkgDEP1(){
unset aptPKG
[[ -z $(dpkg -l | awk '{print$2}' | grep '^sudo$') ]] && aptPKG+=(sudo)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^wget$') ]] && aptPKG+=(wget)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^curl$') ]] && aptPKG+=(curl)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^git$') ]] && aptPKG+=(git)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^locales$') ]] && aptPKG+=(locales)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^netcat$') ]] && aptPKG+=(netcat)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^lsof$') ]] && aptPKG+=(lsof)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^dnsutils$') ]] && aptPKG+=(dnsutils)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^net-tools$') ]] && aptPKG+=(net-tools)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^resolvconf$') ]] && aptPKG+=(resolvconf)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^nftables$') ]] && aptPKG+=(nftables)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^ca-certificates$') ]] && aptPKG+=(ca-certificates)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^apt-transport-https$') ]] && aptPKG+=(apt-transport-https)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^gnupg2$') ]] && aptPKG+=(gnupg2)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^unzip$') ]] && aptPKG+=(unzip)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^jq$') ]] && aptPKG+=(jq)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^bc$') ]] && aptPKG+=(bc)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^moreutils$') ]] && aptPKG+=(moreutils)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^rng-tools$') ]] && aptPKG+=(rng-tools)
[[ -n $aptPKG ]] && apt install $(echo ${aptPKG[@]})
}

pkgDEP2(){
unset aptPKG
[[ -z $(dpkg -l | awk '{print$2}' | grep '^psmisc$') ]] && aptPKG+=(psmisc)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^dns-root-data$') ]] && aptPKG+=(dns-root-data)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^idn2$') ]] && aptPKG+=(idn2)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^ethtool$') ]] && aptPKG+=(ethtool)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^tmux$') ]] && aptPKG+=(tmux)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^socat$') ]] && aptPKG+=(socat)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^zip$') ]] && aptPKG+=(zip)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^lighttpd$') ]] && aptPKG+=(lighttpd)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^php7.4-fpm$') ]] && aptPKG+=(php7.4-fpm)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^php7.4-cgi$') ]] && aptPKG+=(php7.4-cgi)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^php7.4-sqlite3$') ]] && aptPKG+=(php7.4-sqlite3)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^php7.4-xml$') ]] && aptPKG+=(php7.4-xml)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^php7.4-intl$') ]] && aptPKG+=(php7.4-intl)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^php7.4-json$') ]] && aptPKG+=(php7.4-json)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^sqlite3$') ]] && aptPKG+=(sqlite3)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^redis-server$') ]] && aptPKG+=(redis-server)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^libjemalloc-dev$') ]] && aptPKG+=(libjemalloc-dev)
[[ -n $aptPKG ]] && apt install $(echo ${aptPKG[@]})
}

checkSum(){
sha256sumL=$(sha256sum $1 2>/dev/null | awk '{print$1}')
if [[ $sha256sumL = $2 ]]; then
  echo "true"
elif [[ $sha256sumL != $2 ]]; then
  echo "false"
fi
}



preDL(){
mkdir -p /opt/de_GWD
mkdir -p /opt/de_GWD/.repo

sha256sum_IPchnroute=$(curl -ksSLo- https://ghproxy.com/https://raw.githubusercontent.com/jacyl4/chnroute/main/IPchnroute.sha256sum)
if [[ $(checkSum /opt/de_GWD/.repo/IPchnroute $sha256sum_IPchnroute) = "false" ]]; then
rm -rf /tmp/IPchnroute
wget --no-check-certificate --show-progress -cqO /tmp/IPchnroute https://ghproxy.com/https://raw.githubusercontent.com/jacyl4/chnroute/main/IPchnroute
[[ $(checkSum /tmp/IPchnroute $sha256sum_IPchnroute) = "false" ]] && echo -e "${WHITE}IPchnroute${RED} Download Failed${cRES}" && exit
[[ $(checkSum /tmp/IPchnroute $sha256sum_IPchnroute) = "true" ]] && mv -f /tmp/IPchnroute /opt/de_GWD/.repo/IPchnroute
fi

if [[ -f "./de_GWD_$architecture.zip" ]]; then
    mv -f ./de_GWD_$architecture.zip /opt/de_GWD/.repo/de_GWD.zip
else
    sha256sum_de_GWD=$(curl -ksSLo- https://ghproxy.com/https://raw.githubusercontent.com/jacyl4/de_GWD/main/de_GWD_"$architecture".zip.sha256sum)
    if [[ $(checkSum /opt/de_GWD/.repo/de_GWD.zip $sha256sum_de_GWD) = "false" ]]; then
    rm -rf /tmp/de_GWD.zip
    wget --no-check-certificate --show-progress -cqO /tmp/de_GWD.zip https://ghproxy.com/https://raw.githubusercontent.com/jacyl4/de_GWD/main/de_GWD_"$architecture".zip
    [[ $(checkSum /tmp/de_GWD.zip $sha256sum_de_GWD) = "false" ]] && rm -rf /tmp/de_GWD.zip && wget --no-check-certificate --show-progress -cqO /tmp/de_GWD.zip https://de-gwd.accxio.workers.dev/de_GWD_"$architecture".zip
    [[ $(checkSum /tmp/de_GWD.zip $sha256sum_de_GWD) = "false" ]] && echo -e "${WHITE}de_GWD Zip${RED} Download Failed${cRES}" && exit
    [[ $(checkSum /tmp/de_GWD.zip $sha256sum_de_GWD) = "true" ]] && mv -f /tmp/de_GWD.zip /opt/de_GWD/.repo/de_GWD.zip
    fi
fi

[[ -z $(unzip -tq /opt/de_GWD/.repo/de_GWD.zip | grep "No errors detected in compressed data") ]] && echo -e "${WHITE}de_GWD Zip${RED} Download Failed${cRES}" && exit

cat << "EOF" >/opt/de_GWD/tcpTime
#!/bin/bash
echo
date -s "$(curl -sI aliyun.com| grep -i '^date:'|cut -d' ' -f2-)"
[[ $? -ne "0" ]] && date -s "$(wget -qSO- --max-redirect=0 --dns-timeout=3 baidu.com 2>&1 | grep Date: | cut -d' ' -f5-8)Z"
hwclock -w
echo
EOF
chmod +x /opt/de_GWD/tcpTime
/opt/de_GWD/tcpTime
}



repoDL(){
echo -e "${WHITE}[...]\c" && echo -e "\t${WHITE}Repo Download${cRES}\r\c"
sha256sum_nginx=$(curl -sSLo- https://raw.githubusercontent.com/jacyl4/de_GWD/$branch/resource/nginx/nginx_"$architecture".sha256sum)
sha256sum_nginxConf=$(curl -sSLo- https://raw.githubusercontent.com/jacyl4/de_GWD/$branch/resource/nginx/nginxConf.zip.sha256sum)
sha256sum_client=$(curl -sSLo- https://raw.githubusercontent.com/jacyl4/de_GWD/$branch/resource/client/Archive.zip.sha256sum)

if [[ $(checkSum /usr/sbin/nginx $sha256sum_nginx) = "false" ]]; then
rm -rf /tmp/nginx
wget --show-progress -cqO /tmp/nginx https://raw.githubusercontent.com/jacyl4/de_GWD/$branch/resource/nginx/nginx_"$architecture"
[[ $(checkSum /tmp/nginx $sha256sum_nginx) = "false" ]] && echo -e "${WHITE}NGINX Core${RED} Download Failed${cRES}" && exit
[[ $(checkSum /tmp/nginx $sha256sum_nginx) = "true" ]] && mv -f /tmp/nginx /usr/sbin/nginx && chmod +x /usr/sbin/nginx
fi

if [[ $(checkSum /opt/de_GWD/.repo/nginxConf.zip $sha256sum_nginxConf) = "false" ]]; then
rm -rf /tmp/nginxConf.zip
wget --show-progress -cqO /tmp/nginxConf.zip https://raw.githubusercontent.com/jacyl4/de_GWD/$branch/resource/nginx/nginxConf.zip
[[ $(checkSum /tmp/nginxConf.zip $sha256sum_nginxConf) = "false" ]] && echo -e "${RED}Download Failed${cRES}" && exit
[[ $(checkSum /tmp/nginxConf.zip $sha256sum_nginxConf) = "true" ]] && mv -f /tmp/nginxConf.zip /opt/de_GWD/.repo/nginxConf.zip
fi

if [[ $(ttyd -v 2>&1 | grep -o '[0-9]\.[0-9]\.[0-9]') != $TTYD_Ver ]]; then
wget --show-progress -cqO /tmp/ttyd https://github.com/tsl0922/ttyd/releases/download/$TTYD_Ver/ttyd.$(uname -m)
[[ $? -ne 0 ]] && echo -e "${WHITE}TTYD${RED} Download Failed${cRES}"
[[ $(du -sk /tmp/ttyd 2>/dev/null | awk '{print$1}') -gt 1000 ]] && mv -f /tmp/ttyd /usr/bin/ttyd && chmod +x /usr/bin/ttyd && TTYD_UPDATE="true"
fi

if [[ $(checkSum /opt/de_GWD/.repo/client.zip $sha256sum_client) = "false" ]]; then
rm -rf /tmp/client.zip
wget --show-progress -cqO /tmp/client.zip https://raw.githubusercontent.com/jacyl4/de_GWD/$branch/resource/client/Archive.zip
[[ $(checkSum /tmp/client.zip $sha256sum_client) = "false" ]] && echo -e "${WHITE}Client Zip${RED} Download Failed${cRES}" && exit
[[ $(checkSum /tmp/client.zip $sha256sum_client) = "true" ]] && mv -f /tmp/client.zip /opt/de_GWD/.repo/client.zip
fi

localVer=$(awk 'NR==1' /opt/de_GWD/.repo/version.php 2>/dev/null)
remoteVer=$(curl -sSLo- https://raw.githubusercontent.com/jacyl4/de_GWD/main/version.php | head -n 1)

if [[ $localVer != $remoteVer ]] || [[ ! -f '/opt/de_GWD/.repo/version.php' ]]; then
rm -rf /opt/de_GWD/.repo/version.php
wget --show-progress -cqO /opt/de_GWD/.repo/version.php https://raw.githubusercontent.com/jacyl4/de_GWD/main/version.php
[[ $? -ne 0 ]] && echo -e "${WHITE}Version file${RED} Download Failed${cRES}" && exit
fi

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}Repo Download${cRES}"
}



cleanDep(){
echo -e "${WHITE}[...]\c" && echo -e "\t${WHITE}Clean-up${cRES}\r\c"
service cron stop

sed -i "/nfsvers/d" /etc/fstab >/dev/null 2>&1
sed -i '/quic/d' /etc/nginx/conf.d/*.conf >/dev/null 2>&1

[[ $(jq '.v2nodeDIV.nodeSM' /opt/de_GWD/0conf) = "[]" ]] && jq '.v2nodeDIV.nodeSM={}' /opt/de_GWD/0conf | sponge /opt/de_GWD/0conf
[[ $(jq '.v2nodeDIV.nodeDT' /opt/de_GWD/0conf) = "[]" ]] && jq '.v2nodeDIV.nodeDT={}' /opt/de_GWD/0conf | sponge /opt/de_GWD/0conf
[[ $(jq '.v2nodeDIV.nodeCU' /opt/de_GWD/0conf) = "[]" ]] && jq '.v2nodeDIV.nodeCU={}' /opt/de_GWD/0conf | sponge /opt/de_GWD/0conf

[[ -n $(jq '.v2nodeDIV.nodeCU.custom' /opt/de_GWD/0conf | grep -v '^null$') ]] && jq 'del(.v2nodeDIV.nodeCU.custom)' /opt/de_GWD/0conf | sponge /opt/de_GWD/0conf
[[ -n $(jq '.v2nodeDIV.nodeDT.divert' /opt/de_GWD/0conf | grep -v '^null$') ]] && jq 'del(.v2nodeDIV.nodeDT.divert)' /opt/de_GWD/0conf | sponge /opt/de_GWD/0conf
[[ -n $(jq '.v2nodeDIV.nodeDT.ip' /opt/de_GWD/0conf | grep -v '^null$') ]] && jq 'del(.v2nodeDIV.nodeDT.ip)' /opt/de_GWD/0conf | sponge /opt/de_GWD/0conf
[[ -n $(jq '.listB' /opt/de_GWD/0conf | grep -v '^null$') ]] && jq 'del(.listB)' /opt/de_GWD/0conf | sponge /opt/de_GWD/0conf
[[ -n $(jq '.listW' /opt/de_GWD/0conf | grep -v '^null$') ]] && jq 'del(.listW)' /opt/de_GWD/0conf | sponge /opt/de_GWD/0conf
[[ -n $(jq '.listBlan' /opt/de_GWD/0conf | grep -v '^null$') ]] && jq 'del(.listBlan)' /opt/de_GWD/0conf | sponge /opt/de_GWD/0conf
[[ -n $(jq '.listWlan' /opt/de_GWD/0conf | grep -v '^null$') ]] && jq 'del(.listWlan)' /opt/de_GWD/0conf | sponge /opt/de_GWD/0conf
[[ -n $(jq '.dns.APPLEcn' /opt/de_GWD/0conf | grep -v '^null$') ]] && jq 'del(.dns.APPLEcn)' /opt/de_GWD/0conf | sponge /opt/de_GWD/0conf
[[ -n $(jq '.dns.STEAMcn' /opt/de_GWD/0conf | grep -v '^null$') ]] && jq 'del(.dns.STEAMcn)' /opt/de_GWD/0conf | sponge /opt/de_GWD/0conf
[[ -n $(jq '.v2nodeDIV.directApple' /opt/de_GWD/0conf | grep -v '^null$') ]] && jq 'del(.v2nodeDIV.directApple)' /opt/de_GWD/0conf | sponge /opt/de_GWD/0conf
[[ -n $(jq '.v2nodeDIV.directSteam' /opt/de_GWD/0conf | grep -v '^null$') ]] && jq 'del(.v2nodeDIV.directSteam)' /opt/de_GWD/0conf | sponge /opt/de_GWD/0conf

dohORI=$(jq -r '.dns.DOH' /opt/de_GWD/0conf | grep -v '^null$')
dogORI=$(jq -r '.dns.DoG' /opt/de_GWD/0conf | grep -v '^null$')
[[ -n $dohORI ]] && jq --argjson doh "$dohORI" '.dns.doh=$doh' /opt/de_GWD/0conf | jq 'del(.dns.DOH)' | sponge /opt/de_GWD/0conf
[[ -n $dogORI ]] && jq --arg dog "$dogORI" '.dns.dog=$dog' /opt/de_GWD/0conf | jq 'del(.dns.DoG)' | sponge /opt/de_GWD/0conf

[[ -d "/opt/bitwardenrs" ]] && mv -f /opt/bitwardenrs /opt/bitwarden

if [[ -f "/etc/systemd/system/doh-client.service" ]] || [[ -f "/lib/systemd/system/doh-client.service" ]]; then
    systemctl disable --now doh-client >/dev/null 2>&1
    rm -rf /lib/systemd/system/doh-client.service
    rm -rf /etc/systemd/system/doh-client.service
    rm -rf /opt/de_GWD/doh-client*
    rm -rf "/etc/NetworkManager/dispatcher.d"
    systemctl daemon-reload >/dev/null
fi

if [[ -f "/etc/systemd/system/doh-server.service" ]] || [[ -f "/lib/systemd/system/doh-server.service" ]]; then
    systemctl disable --now doh-server >/dev/null 2>&1
    rm -rf /lib/systemd/system/doh-server.service
    rm -rf /etc/systemd/system/doh-server.service
    rm -rf /opt/de_GWD/doh-server*
    rm -rf "/etc/NetworkManager/dispatcher.d"
    systemctl daemon-reload >/dev/null
fi

if [[ -f "/lib/systemd/system/frps.service" ]] || [[ -f "/lib/systemd/system/frpc.service" ]]; then
    systemctl disable frps >/dev/null 2>&1
    systemctl disable frpc >/dev/null 2>&1
    systemctl stop frps >/dev/null 2>&1
    systemctl stop frpc >/dev/null 2>&1
    rm -rf /lib/systemd/system/frps.service >/dev/null 2>&1
    rm -rf /etc/systemd/system/frps.service >/dev/null 2>&1
    rm -rf /lib/systemd/system/frpc.service >/dev/null 2>&1
    rm -rf /etc/systemd/system/frpc.service >/dev/null 2>&1
    systemctl daemon-reload >/dev/null
    rm -rf /opt/de_GWD/frps
    rm -rf /opt/de_GWD/frpc
fi

if [[ -f "/etc/systemd/system/iptables-proxy.service" ]] || [[ -f "/lib/systemd/system/iptables-proxy.service" ]]; then
    systemctl disable iptables-proxy >/dev/null 2>&1
    rm -rf /etc/systemd/system/iptables-proxy.service >/dev/null 2>&1
    rm -rf /lib/systemd/system/iptables-proxy.service >/dev/null 2>&1
    systemctl daemon-reload >/dev/null
    /opt/de_GWD/iptables-proxy-down
    rm -rf /opt/de_GWD/iptables-proxy-down
    rm -rf /opt/de_GWD/iptables-proxy-up
fi


if [[ -d "/opt/de_GWD/xDNSc" ]]; then
    systemctl disable xDNSc >/dev/null 2>&1
    systemctl stop xDNSc >/dev/null 2>&1
    rm -rf /etc/systemd/system/xDNSc.service
    rm -rf /lib/systemd/system/xDNSc.service
    systemctl daemon-reload >/dev/null
    rm -rf /opt/de_GWD/xDNSc
    jq 'del(.dns.xDNS)' /opt/de_GWD/0conf | sponge /opt/de_GWD/0conf
fi

if [[ -d "/opt/de_GWD/xDNSs" ]]; then
    systemctl disable xDNSs >/dev/null 2>&1
    systemctl stop xDNSs >/dev/null 2>&1
    rm -rf /etc/systemd/system/xDNSs.service
    rm -rf /lib/systemd/system/xDNSs.service
    systemctl daemon-reload >/dev/null
    rm -rf /opt/de_GWD/xDNSs
    jq 'del(.FORWARD.xDNSs)' /opt/de_GWD/0conf | sponge /opt/de_GWD/0conf
fi

if [[ `dpkg -l | grep php | grep fpm | awk '{print $2}'` = "php7.3-fpm" ]] || [[ `dpkg -l | grep php | grep fpm | awk '{print $2}'` = "php8.0-fpm" ]]; then
    rm -rf /etc/php/7.3/
    apt remove --purge '^php7.3.*'
    rm -rf /etc/php/8.0/
    apt remove --purge '^php8.0.*'
fi

[[ -n $(dpkg -l | awk '{print$2}' | grep '^ipset$') ]] && apt remove --purge ipset

[[ -f "/var/log/pihole-FTL.log" ]] && >/var/log/pihole-FTL.log
[[ -f "/var/log/pihole.log" ]] && >/var/log/pihole.log
[[ -f "/etc/nginx/off" ]] && rm -rf /etc/nginx/off
rm -rf /etc/dnsmasq.d/89-bogus-domains.china.conf
rm -rf /etc/dnsmasq.d/89-bogus-nxdomains.china.conf
[[ -n $(dpkg -l | awk '{print$2}' | grep '^smartdns$') ]] && rm -rf /etc/smartdns && apt remove --purge smartdns
[[ -n $(systemctl cat v2dns 2>/dev/null) ]] && systemctl disable --now v2dns >/dev/null 2>&1 && \
rm -rf /lib/systemd/system/v2dns.service && \
rm -rf /etc/systemd/system/v2dns.service && \
rm -rf /opt/de_GWD/v2dns
[[ -n $(dpkg -l | awk '{print$2}' | grep '^haveged$') ]] && apt remove --purge haveged



rm -rf /etc/apt/sources.list.d/unstable.list
rm -rf /etc/apt/preferences.d/limit-unstable
rm -rf /opt/de_GWD/.repo/vtrui.zip
rm -rf /opt/de_GWD/chnroute.txt
rm -rf /opt/de_GWD/Q4am
rm -rf /opt/de_GWD/Q4H
rm -rf /opt/de_GWD/Q2H
rm -rf /etc/dns-over-https
rm -rf /usr/bin/vtrui
rm -rf /usr/local/bin/yq
rm -rf /usr/sbin/yq
rm -rf /etc/vtrui
rm -rf /opt/de_GWD/ttyd
rm -rf /opt/de_GWD/IPxDNSSET
rm -rf /opt/de_GWD/chnrouteSET
rm -rf /opt/de_GWD/IPGlobalDNSSET
rm -rf /opt/de_GWD/IPlistBlanSET
rm -rf /opt/de_GWD/IPlistBSET
rm -rf /opt/de_GWD/IPlistWlanSET
rm -rf /opt/de_GWD/IPlistWSET
rm -rf /opt/de_GWD/IPv2nodeSET
rm -rf /opt/de_GWD/__MACOSX
rm -rf /var/www/html/__MACOSX
echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}Clean-up${cRES}"
}



preUpdate(){
echo -e "${BLUE}################################################################# ${cRES}"
echo -e "${GREEN}DNS information${cRES}"
echo

ethernetnum=$(ip --oneline link show up | grep -v "lo" | awk '{print$2;exit}' | cut -d':' -f1 | cut -d'@' -f1)
gatewayAddr=$(jq -r '.address.upstreamIP' /opt/de_GWD/0conf | grep -Po '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}')
localAddrCIDR=$(jq -r '.address.localIP' /opt/de_GWD/0conf | grep -v '^null$')
localAddr=$(echo $localAddrCIDR | cut -d / -f1)
netmask=$(echo $localAddrCIDR | sed -r 's/([0-9]{1,3}\.){3}[0-9]{1,3}//g')

[[ -z $netmask ]] && netmask="/24" && localAddrCIDR="$localAddr$netmask"

DoG=$(jq -r '.dns.dog' /opt/de_GWD/0conf 2>/dev/null | grep -v '^null$')
doh1=$(jq -r '.dns.doh[]' /opt/de_GWD/0conf 2>/dev/null | grep -v '^null$' | awk NR==1)
doh2=$(jq -r '.dns.doh[]' /opt/de_GWD/0conf 2>/dev/null | grep -v '^null$' | awk NR==2)

[[ -n $DoG ]] && echo -e "\t${WHITE}DNS over gRPC   : \c" && echo -e "${YELLOW}$DoG${cRES}"
[[ -n $doh1 ]] && echo -e "\t${WHITE}DNS over Https 1: \c" && echo -e "${YELLOW}$doh1${cRES}"
[[ -n $doh2 ]] && echo -e "\t${WHITE}DNS over Https 2: \c" && echo -e "${YELLOW}$doh2${cRES}"


domain=$(jq -r '.update.v2node.domain' /opt/de_GWD/0conf 2>/dev/null | grep -v '^null$')
tls=$(jq -r '.update.v2node.tls' /opt/de_GWD/0conf 2>/dev/null | grep -v '^null$')
port=$(jq -r '.update.v2node.port' /opt/de_GWD/0conf 2>/dev/null | grep -v '^null$')
uuid=$(jq -r '.update.v2node.uuid' /opt/de_GWD/0conf 2>/dev/null | grep -v '^null$')
path=$(jq -r '.update.v2node.path' /opt/de_GWD/0conf 2>/dev/null | grep -v '^null$')

if [[ -z $domain ]] || [[ -z $uuid ]]; then
  cp -f /opt/de_GWD/0conf_bak /opt/de_GWD/0conf
  clear
  preUpdate
fi

[[ -z $tls ]] && tls=$domain

piholePW=$(jq -r '.address.PWD' /opt/de_GWD/0conf 2>/dev/null | grep -v '^null$')

serverName=$(jq -r '.address.serverName' /opt/de_GWD/0conf 2>/dev/null | grep -v '^null$')
webUIport=$(jq -r '.address.webUIport' /opt/de_GWD/0conf 2>/dev/null | grep -v '^null$')
updatePort=$(jq -r '.update.updatePort' /opt/de_GWD/0conf 2>/dev/null | grep -v '^null$')

echo
echo -e "${GREEN}Xray node information${cRES}"
echo
echo -e "\t${WHITE}Domain          : \c" && echo -e "${YELLOW}$domain${cRES}"
echo -e "\t${WHITE}Port            : \c" && echo -e "${YELLOW}$port${cRES}"
echo -e "\t${WHITE}UUID            : \c" && echo -e "${YELLOW}$uuid${cRES}"
echo -e "\t${WHITE}Path            : \c" && echo -e "${YELLOW}$path${cRES}"
echo -e "${BLUE}################################################################# ${cRES}"
echo
}



de_GWDconnect(){
if [[ $1 = "u" ]]; then
echo -e "${WHITE}de_GWD server connect  ${cRES}\c" && echo -e "\t${WHITE}[...]${cRES}\r\c"
else
echo -e "\t${WHITE}de_GWD server connect${cRES}\r\c"
fi

local serverConnect1=$(curl -Is -m 5 google.com | grep 'HTTP')
local serverConnect2=$(curl -Is -m 5 youtube.com | grep 'HTTP')

if [[ $1 = "u" ]]; then
    if [[ $2 = "a" ]]; then
        preDL
        updateGWD_Green
        [[ -z $serverConnect1 ]] || [[ -z $serverConnect2 ]] && exit
    else
        if [[ -n $serverConnect1 ]] && [[ -n $serverConnect2 ]] && [[ $(systemctl is-active 'vtrui') = "active" ]]; then
        echo -e "${WHITE}de_GWD server connect  ${cRES}\c" && echo -e "\t${WHITE}[${GREEN} ✓ ${WHITE}]${cRES}"
        de_GWDconnect_check="OK"
            echo -e "${GREEN}================================= ${cRES}"
            echo -e "${GREEN}[Y]: Full Update${cRES}"
            echo -e "${GREEN}[*]: Any other key to Fast Update${cRES}"
            echo -e "${GREEN}================================= ${cRES}"
            read -s -n 1 updateDebian
            echo -e "${WHITE}[...]\c" && echo -e "\t${WHITE}Start Updating de_GWD${cRES}\r\c"

            if [[ $updateDebian = "Y" ]] || [[ $updateDebian = "y" ]]; then
            preDL
            updateAPT
            fi
            preDL
            updateGWD_Green
        else
        echo -e "${WHITE}de_GWD server connect  ${cRES}\c" && echo -e "\t${WHITE}[${RED} ✕ ${WHITE}]${cRES}"
        updateGWD_Red
        fi
    fi
else
    if [[ -n $serverConnect1 ]] && [[ -n $serverConnect2 ]] && [[ $(systemctl is-active 'vtrui') = "active" ]]; then
        echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}de_GWD server connect${cRES}"
    else
        echo -e "${WHITE}[ ${RED}✕ ${WHITE}]\c" && echo -e "\t${WHITE}de_GWD server connect${cRES}"
    fi


if [[ -z $serverConnect1 ]] || [[ -z $serverConnect2 ]]; then
cat << EOF >/etc/resolv.conf
nameserver 119.29.29.29
nameserver 182.254.118.118
nameserver 114.114.114.114
nameserver 223.5.5.5
EOF
systemctl stop smartdns >/dev/null 2>&1
systemctl stop nftables >/dev/null 2>&1
exit
fi
fi
}



preInstall(){
sync; echo 3 >/proc/sys/vm/drop_caches >/dev/null 2>&1

cat << EOF >/etc/apt/apt.conf.d/01InstallLess
APT::Get::Assume-Yes "true";
APT::Install-Recommends "false";
APT::Install-Suggests "false";
EOF

cat << EOF >/etc/apt/apt.conf.d/71debconf
Dpkg::Options {
   "--force-confdef";
   "--force-confold";
};
EOF

sed -i '/ulimit -SHn/d' /etc/profile
sed -i '/ulimit -c/d' /etc/profile
sed -i '/ulimit -d/d' /etc/profile
sed -i '/ulimit -f/d' /etc/profile
sed -i '/ulimit -m/d' /etc/profile
sed -i '/ulimit -s/d' /etc/profile
sed -i '/ulimit -t/d' /etc/profile
sed -i '/ulimit -u/d' /etc/profile
sed -i '/ulimit -v/d' /etc/profile
sed -i '/HISTCONTROL=/d' /etc/profile
sed -i '/alias reboot=/d' /etc/profile
cat << EOF >>/etc/profile
ulimit -SHn 1000000
ulimit -c unlimited
ulimit -d unlimited
ulimit -f unlimited
ulimit -m unlimited
ulimit -s unlimited
ulimit -t unlimited
ulimit -u 10000
ulimit -v unlimited

HISTCONTROL=ignoredups
alias reboot="sudo systemctl reboot"
EOF
source /etc/profile

cat << EOF >/etc/security/limits.conf
root     soft   nofile    1000000
root     hard   nofile    1000000
root     soft   nproc     1000000
root     hard   nproc     1000000
root     soft   core      1000000
root     hard   core      1000000
root     hard   memlock   unlimited
root     soft   memlock   unlimited

*     soft   nofile    1000000
*     hard   nofile    1000000
*     soft   nproc     1000000
*     hard   nproc     1000000
*     soft   core      1000000
*     hard   core      1000000
*     hard   memlock   unlimited
*     soft   memlock   unlimited
EOF

sed -i '/DefaultLimitCORE/d' /etc/systemd/system.conf
sed -i '/DefaultLimitNOFILE/d' /etc/systemd/system.conf
sed -i '/DefaultLimitNPROC/d' /etc/systemd/system.conf
cat << EOF >>/etc/systemd/system.conf
DefaultLimitCORE=infinity
DefaultLimitNOFILE=infinity
DefaultLimitNPROC=infinity
EOF
systemctl daemon-reload

dpkg --configure -a

pkgDEP1

cat << EOF >/etc/default/rng-tools-debian
# -*- mode: sh -*-
#-
# Configuration for the rng-tools-debian initscript

# Set to the input source for random data, leave undefined
# for the initscript to attempt auto-detection.  Set to /dev/null
# for the viapadlock driver.
#HRNGDEVICE=/dev/hwrng
#HRNGDEVICE=/dev/null
HRNGDEVICE=/dev/urandom

# Additional options to send to rngd. See the rngd(8) manpage for
# more information.  Do not specify -r/--rng-device here, use
# HRNGDEVICE for that instead.
#RNGDOPTIONS="--hrng=intelfwh --fill-watermark=90% --feed-interval=1"
#RNGDOPTIONS="--hrng=viakernel --fill-watermark=90% --feed-interval=1"
#RNGDOPTIONS="--hrng=viapadlock --fill-watermark=90% --feed-interval=1"
# For TPM (also add tpm-rng to /etc/initramfs-tools/modules or /etc/modules):
#RNGDOPTIONS="--fill-watermark=90% --feed-interval=1"

# If you need to configure which RNG to use, do it here:
#HRNGSELECT="virtio_rng.0"
# Use this instead of sysfsutils, which starts too late.
EOF
systemctl restart rng-tools

rm -rf /etc/systemd/resolved.conf >/dev/null 2>&1
systemctl daemon-reload >/dev/null
systemctl mask --now systemd-resolved >/dev/null 2>&1

[[ -n $(which setenforce) ]] && setenforce 0
[[ -f "/etc/selinux/config" ]] && sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

nft delete table ip de_GWD >/dev/null 2>&1
ip rule del table 220 >/dev/null 2>&1
ip route flush table 220 >/dev/null 2>&1
ip route flush cache >/dev/null 2>&1
ip route del local default dev lo table 220 >/dev/null 2>&1

[[ -n $(systemctl cat nftables 2>/dev/null) ]] && systemctl stop nftables >/dev/null 2>&1
[[ -n $(systemctl cat vtrui 2>/dev/null) ]] && systemctl stop vtrui >/dev/null 2>&1

if [[ -n "$(ps -e | grep 'pihole-FTL' )" ]]; then
cat << EOF >/etc/dnsmasq.conf
conf-dir=/etc/dnsmasq.d
listen-address=127.0.0.1
port=0
EOF
pihole restartdns >/dev/null 2>&1
fi

cat << EOF >/etc/resolv.conf
nameserver 119.29.29.29
nameserver 182.254.118.118
nameserver 114.114.114.114
nameserver 223.5.5.5
EOF
}



preConf(){
echo -e "${WHITE}[...]\c" && echo -e "\t${WHITE}System Config${cRES}\r\c"
localeSet=`cat << EOF
LANG=en_US.UTF-8
LANGUAGE=en_US.UTF-8
LC_CTYPE="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_PAPER="en_US.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_MEASUREMENT="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
LC_ALL=en_US.UTF-8
EOF
`
if [[ -z $(localectl list-locales | grep "en_US.UTF-8") ]]; then
echo "$localeSet" >/etc/default/locale
echo "en_US.UTF-8 UTF-8" >/etc/locale.gen
locale-gen "en_US.UTF-8"
localectl set-locale en_US.UTF-8
update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8
fi

if [[ $(date +"%Z %z") != "CST +0800" ]]; then
echo "Asia/Shanghai" >/etc/timezone
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
fi

modprobe nf_conntrack
sed -i '/nf_conntrack/d' /etc/modules-load.d/modules.conf
sed -i '/xt_conntrack/d' /etc/modules-load.d/modules.conf
sed -i '/ip_conntrack/d' /etc/modules-load.d/modules.conf
sed -i '/nf_nat/d' /etc/modules-load.d/modules.conf
sed -i '/xt_nat/d' /etc/modules-load.d/modules.conf
cat << EOF >>/etc/modules-load.d/modules.conf
nf_conntrack
EOF

cat << EOF >/etc/sysctl.conf
vm.overcommit_memory = 1
vm.swappiness = 10
vm.dirty_ratio = 10
vm.dirty_background_ratio = 5
fs.nr_open = 1000000
fs.file-max = 1000000
fs.inotify.max_user_instances = 819200
fs.inotify.max_queued_events = 32000
fs.inotify.max_user_watches = 64000
net.unix.max_dgram_qlen = 1024
net.nf_conntrack_max = 131072
net.netfilter.nf_conntrack_acct = 0
net.netfilter.nf_conntrack_checksum = 0
net.netfilter.nf_conntrack_events = 1
net.netfilter.nf_conntrack_timestamp = 0
net.netfilter.nf_conntrack_helper = 1
net.netfilter.nf_conntrack_max = 16384
net.netfilter.nf_conntrack_buckets = 65535
net.netfilter.nf_conntrack_tcp_loose = 1
net.netfilter.nf_conntrack_tcp_be_liberal = 1
net.netfilter.nf_conntrack_tcp_max_retrans = 3
net.netfilter.nf_conntrack_generic_timeout = 60
net.netfilter.nf_conntrack_tcp_timeout_unacknowledged = 30
net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 30
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 30
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 15
net.netfilter.nf_conntrack_tcp_timeout_close = 5
net.netfilter.nf_conntrack_tcp_timeout_last_ack = 30
net.netfilter.nf_conntrack_tcp_timeout_syn_recv = 30
net.netfilter.nf_conntrack_tcp_timeout_syn_sent = 30
net.netfilter.nf_conntrack_tcp_timeout_established = 3600
net.netfilter.nf_conntrack_sctp_timeout_established = 3600
net.netfilter.nf_conntrack_udp_timeout = 15
net.netfilter.nf_conntrack_udp_timeout_stream = 45
net.core.somaxconn = 65535
net.core.optmem_max = 4194304
net.core.netdev_max_backlog = 300000
net.core.rmem_default = 4194304
net.core.rmem_max = 4194304
net.core.wmem_default = 4194304
net.core.wmem_max = 4194304
net.ipv4.conf.all.arp_accept = 0
net.ipv4.conf.default.arp_accept = 0
net.ipv4.conf.all.arp_announce = 2
net.ipv4.conf.default.arp_announce = 2
net.ipv4.conf.all.arp_ignore = 1
net.ipv4.conf.default.arp_ignore = 1
net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.default.rp_filter = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.accept_redirects = 1
net.ipv4.conf.default.accept_redirects = 1
net.ipv4.conf.all.secure_redirects = 1
net.ipv4.conf.default.secure_redirects = 1
net.ipv4.conf.all.accept_source_route = 1
net.ipv4.conf.default.accept_source_route = 1
net.ipv4.ip_forward = 1
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.route.gc_timeout = 100
net.ipv4.udp_rmem_min = 16384
net.ipv4.udp_wmem_min = 16384
net.ipv4.tcp_base_mss = 1024
net.ipv4.tcp_mem = 181419 241895 362838
net.ipv4.tcp_rmem = 8192 87380 6291456
net.ipv4.tcp_wmem = 8192 65535 4194304
net.ipv4.tcp_max_tw_buckets = 65535
net.ipv4.tcp_max_syn_backlog = 32768
net.ipv4.tcp_max_orphans = 32768
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_workaround_signed_windows = 0
net.ipv4.tcp_no_metrics_save = 0
net.ipv4.tcp_no_ssthresh_metrics_save = 1
net.ipv4.tcp_ecn = 0
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_fastopen_key = 00000000-00000000-00000000-00000000
net.ipv4.tcp_keepalive_time = 1800
net.ipv4.tcp_keepalive_intvl = 15
net.ipv4.tcp_keepalive_probes = 4
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_syncookies = 0
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_syn_retries = 4
net.ipv4.tcp_synack_retries = 3
net.ipv4.tcp_retries1 = 3
net.ipv4.tcp_retries2 = 8
net.ipv4.tcp_challenge_ack_limit = 100000000
net.ipv4.tcp_frto = 0
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_rfc1337 = 1
EOF

sed -i "/net.core.default_qdisc/d" /etc/sysctl.conf
sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf

if [[ $(uname -r) =~ "bbrplus" ]]; then
  echo "net.core.default_qdisc = fq" >>/etc/sysctl.conf
  echo "net.ipv4.tcp_congestion_control = bbrplus" >>/etc/sysctl.conf
elif [[ $(uname -r) =~ "liquorix" ]]; then
  echo "net.core.default_qdisc = fq_pie" >>/etc/sysctl.conf
  echo "net.ipv4.tcp_congestion_control = bbr" >>/etc/sysctl.conf
elif [[ $(uname -r) =~ "xanmod" ]]; then
  echo "net.core.default_qdisc = fq_pie" >>/etc/sysctl.conf
  echo "net.ipv4.tcp_congestion_control = bbr" >>/etc/sysctl.conf
else
  echo "net.core.default_qdisc = fq_codel" >>/etc/sysctl.conf
  echo "net.ipv4.tcp_congestion_control = bbr" >>/etc/sysctl.conf
fi
sysctl -p >/dev/null
systemctl restart systemd-sysctl

if [[ -n $(dpkg -l | awk '{print$2}' | grep '^docker-ce$') ]] && [[ -n $(dpkg -l | awk '{print$2}' | grep '^containerd.io$') ]]; then
mkdir -p /etc/docker/
systemctl stop docker docker.socket containerd
cat << EOF >/etc/docker/daemon.json
{
  "iptables": false
}
EOF
systemctl restart docker
fi

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}System Config${cRES}"
}



installSmartDNS(){
echo -e "${WHITE}[...]\c" && echo -e "\t${WHITE}Proxy Components Prepared${cRES}\r\c"
if [[ -n $(unzip -tq /opt/de_GWD/.repo/de_GWD.zip | grep "No errors detected in compressed data") ]]; then
rm -rf /opt/de_GWD/smartdns
rm -rf /opt/de_GWD/coredns
rm -rf /opt/de_GWD/mosdns
rm -rf /opt/de_GWD/vtrui
mkdir -p /opt/de_GWD/smartdns
mkdir -p /opt/de_GWD/coredns
mkdir -p /opt/de_GWD/mosdns
mkdir -p /opt/de_GWD/vtrui

rm -rf /tmp/de_GWD
unzip /opt/de_GWD/.repo/de_GWD.zip -d /tmp/de_GWD >/dev/null
cp -f /tmp/de_GWD/yq /usr/bin/yq
cp -f /tmp/de_GWD/smartdns /opt/de_GWD/smartdns/smartdns
cp -f /tmp/de_GWD/coredns /opt/de_GWD/coredns/coredns
cp -f /tmp/de_GWD/mosdns /opt/de_GWD/mosdns/mosdns
cp -f /tmp/de_GWD/xray /opt/de_GWD/vtrui/vtrui
cp -f /tmp/de_GWD/private.dat /opt/de_GWD/vtrui/private.dat
chmod +x /usr/bin/yq
chmod +x /opt/de_GWD/smartdns/smartdns
chmod +x /opt/de_GWD/coredns/coredns
chmod +x /opt/de_GWD/mosdns/mosdns
chmod +x /opt/de_GWD/vtrui/vtrui
rm -rf /tmp/de_GWD*
else
rm -rf /opt/de_GWD/.repo/de_GWD.zip
echo -e "${WHITE}de_GWD Zip${RED} Download Failed${cRES}" && exit
fi
echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}Proxy Components prepared${cRES}"



rm -rf /lib/systemd/system/coredns.service
cat << EOF >/etc/systemd/system/coredns.service
[Unit]
Description=CoreDNS DNS server
After=network.target

[Service]
User=root
Type=simple
ExecStart=/opt/de_GWD/coredns/coredns -conf /opt/de_GWD/coredns/corefile
ExecReload=/bin/kill -SIGUSR1 \$MAINPID
KillMode=process
Restart=always
RestartSec=2
TimeoutStopSec=5

CapabilityBoundingSet=CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_BIND_SERVICE
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload >/dev/null



cat << EOF >/opt/de_GWD/smartdns/smartdns.conf
bind 127.0.0.1:53 -group DNS_global
bind-tcp 127.0.0.1:53 -group DNS_global

bind 127.0.0.1:5331 -no-speed-check -no-cache -group DNS_chn
bind-tcp 127.0.0.1:5331 -no-speed-check -no-cache -group DNS_chn

bind 127.0.0.1:5332 -no-speed-check -no-cache -group DNS_global
bind-tcp 127.0.0.1:5332 -no-speed-check -no-cache -group DNS_global

server 114.114.114.114 -exclude-default-group -group DNS_chn
server 114.114.115.115 -exclude-default-group -group DNS_chn
server 119.29.29.29 -exclude-default-group -group DNS_chn
server 119.28.28.28 -exclude-default-group -group DNS_chn
server 182.254.118.118 -exclude-default-group -group DNS_chn
server 223.5.5.5 -exclude-default-group -group DNS_chn
server 223.6.6.6 -exclude-default-group -group DNS_chn
EOF

kill $(ps -e | grep 'smartdns' | awk '{print$1}') >/dev/null 2>&1
rm -rf /run/smartdns.pid
rm -rf /lib/systemd/system/smartdns.service
cat << EOF >/etc/systemd/system/smartdns.service
[Unit]
Description=SmartDNS
After=network.target

[Service]
User=root
Type=forking
PIDFile=/run/smartdns.pid
ExecStart=/opt/de_GWD/smartdns/smartdns -p /run/smartdns.pid -c /opt/de_GWD/smartdns/smartdns.conf
ExecStopPost=$(which rm) -f /run/smartdns.pid
ExecStop=/bin/kill -s STOP \$MAINPID
KillMode=mixed
Restart=always
RestartSec=2
TimeoutStopSec=5

Nice=-9
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload >/dev/null
systemctl restart smartdns
if [[ $? -ne 0 ]]; then
sed -i '/Nice=/d' /etc/systemd/system/smartdns.service
systemctl daemon-reload >/dev/null
systemctl restart smartdns
fi
systemctl enable smartdns >/dev/null 2>&1

rm -rf /etc/resolvconf/resolv.conf.d/*
>/etc/resolvconf/resolv.conf.d/original
>/etc/resolvconf/resolv.conf.d/base
>/etc/resolvconf/resolv.conf.d/tail
rm -rf /etc/resolv.conf
rm -rf /run/resolvconf/interface
cat << EOF >/etc/resolvconf/resolv.conf.d/head
nameserver 127.0.0.1
EOF
if [[ -f "/etc/resolvconf/run/resolv.conf" ]]; then
ln -sf /etc/resolvconf/run/resolv.conf /etc/resolv.conf
elif [[ -f "/run/resolvconf/resolv.conf" ]]; then
ln -sf /run/resolvconf/resolv.conf /etc/resolv.conf
fi
resolvconf -u



echo
echo -e "${BLUE}################################################################# ${cRES}"
echo

if [[ -n $DoG ]]; then
echo -e "${WHITE}DNS over gRPC: ${cRES}"
echo -e "${WHITE}Domain: \c" && echo -e "\t${WHITE}IP: ${cRES}\r\c"
DoGcDomain=$(echo $DoG | cut -d: -f1)
DoGcIP=$(dig @127.0.0.1 $DoGcDomain -4p 5331 +short | grep -Po '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | grep -v "127.0.0.1" | xargs -n 1 | awk NR==1)
DoGcPort=$(echo $DoG | cut -d: -f2 | grep '^[[:digit:]]*$')
echo -e "${WHITE}Domain: ${YELLOW}$DoGcDomain\c" && echo -e "\t${WHITE}IP: ${YELLOW}$DoGcIP${cRES}"
echo

cat << EOF >>/opt/de_GWD/smartdns/smartdns.conf
server 127.0.0.1:5333 -group DNS_global
server-tcp 127.0.0.1:5333 -group DNS_global
EOF
fi

if [[ -n $doh1 ]]; then
echo -e "${WHITE}DNS over Https 1:\t${cRES}"
echo -e "${WHITE}Domain: \c" && echo -e "\t${WHITE}IP: ${cRES}\r\c"
doh1Domain=$(echo $doh1 | cut -d/ -f1 | cut -d: -f1)
doh1IP=$(dig @127.0.0.1 $doh1Domain -4p 5331 +short | grep -Po '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | grep -v "127.0.0.1" | xargs -n 1 | awk NR==1)
doh1Port=$(echo $doh1 | cut -d/ -f1 | cut -d: -f2 | grep '^[[:digit:]]*$')
if [[ -z $doh1Port ]]; then
    doh1Str="$doh1IP/dq"
else
    doh1Str="$doh1IP:$doh1Port/dq"
fi
cat << EOF >>/opt/de_GWD/smartdns/smartdns.conf
server-https https://$doh1Str -no-check-certificate -group DNS_global
EOF
doh1TEST(){
    if [[ -n $(curl -ksL -m 5 https://${doh1Str}?name=youtube.com | grep -Po '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}') ]]; then
        echo -e "\t${WHITE}[ ${GREEN}✓ ${WHITE}]${cRES}"
    else
        echo -e "\t${WHITE}[ ${RED}✕ ${WHITE}]${cRES}"
    fi
}
echo -e "${WHITE}Domain: ${YELLOW}$doh1Domain\c" && echo -e "\t${WHITE}IP: ${YELLOW}$doh1IP${cRES}\c" && doh1TEST
echo
fi

if [[ -n $doh2 ]]; then
echo -e "${WHITE}DNS over Https 2: ${cRES}"
echo -e "${WHITE}Domain: \c" && echo -e "\t${WHITE}IP: ${cRES}\r\c"
doh2Domain=$(echo $doh2 | cut -d/ -f1 | cut -d: -f1)
doh2IP=$(dig @127.0.0.1 $doh2Domain -4p 5331 +short | grep -Po '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | grep -v "127.0.0.1" | xargs -n 1 | awk NR==1)
doh2Port=$(echo $doh2 | cut -d/ -f1 | cut -d: -f2 | grep '^[[:digit:]]*$')
if [[ -z $doh2Port ]]; then
    doh2Str="$doh2IP/dq"
else
    doh2Str="$doh2IP:$doh2Port/dq"
fi
cat << EOF >>/opt/de_GWD/smartdns/smartdns.conf
server-https https://$doh2Str -no-check-certificate -group DNS_global
EOF
doh2TEST(){
    if [[ -n $(curl -ksL -m 5 https://${doh2Str}?name=youtube.com | grep -Po '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}') ]]; then
        echo -e "\t${WHITE}[ ${GREEN}✓ ${WHITE}]${cRES}"
    else
        echo -e "\t${WHITE}[ ${RED}✕ ${WHITE}]${cRES}"
    fi
}
echo -e "${WHITE}Domain: ${YELLOW}$doh2Domain\c" && echo -e "\t${WHITE}IP: ${YELLOW}$doh2IP${cRES}\c" && doh2TEST
echo
fi

systemctl restart smartdns

if [[ -n $DoGcIP ]]; then
cat << EOF >/opt/de_GWD/coredns/corefile
# DoGc_START
.:5333 {
  bind 127.0.0.1
  grpc . $DoGcIP:$DoGcPort {
    tls_servername $DoGcDomain
  }
  template ANY AAAA {
    rcode NXDOMAIN
  }
}
# DoGc_END
EOF
systemctl enable coredns >/dev/null 2>&1
systemctl restart coredns
fi

echo -e "${WHITE}V2 node: ${cRES}"
echo -e "${WHITE}Domain: \c" && echo -e "\t${WHITE}IP: ${cRES}\r\c"
sleep 3
domainIP=$(dig @127.0.0.1 $domain -4p 5332 +short | grep -Po '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | grep -v "127.0.0.1" | xargs -n 1 | awk NR==1)
echo -e "${WHITE}Domain: ${YELLOW}$domain\c" && echo -e "\t${WHITE}IP: ${YELLOW}$domainIP${cRES}"
echo
echo -e "${BLUE}################################################################# ${cRES}"
echo
echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}Deploy SmartDNS${cRES}"

rm -rf /lib/systemd/system/mosdns.service
cat << EOF >/etc/systemd/system/mosdns.service
[Unit]
Description=mosdns
ConditionFileIsExecutable=/opt/de_GWD/mosdns/mosdns

[Service]
User=root
Type=simple
ExecStart=/opt/de_GWD/mosdns/mosdns -s run -c /opt/de_GWD/mosdns/mosdns.yaml -dir /opt/de_GWD/mosdns
ExecStop=/bin/kill -s STOP \$MAINPID
KillMode=process
Restart=always
RestartSec=2
TimeoutStopSec=5
Nice=-9

CapabilityBoundingSet=CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_BIND_SERVICE
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload >/dev/null
}



installXray(){
echo -e "${WHITE}[...]\c" && echo -e "\t${WHITE}Deploy vtrui${cRES}\r\c"

cat << EOF >/opt/de_GWD/vtrui/config.json
{
  "dns":{
    "tag":"dnsflow",
    "hosts":{"$domain":"$domainIP"},
    "servers":[{"address":"127.0.0.1","port":5332}]
  },
  "routing":{
    "rules":[
      {"type":"field","ip":["ext:private.dat:private"],"outboundTag":"direct"},
      {"type":"field","inboundTag":["dnsflow"],"outboundTag":"direct"}
    ]
  },
  "inbounds":[
    {
      "port":9896,
      "listen":"127.0.0.1",
      "protocol":"dokodemo-door",
      "settings":{"network":"tcp,udp","followRedirect":true},
      "streamSettings":{"sockopt":{"tproxy":"tproxy"}}
    }
  ],
  "outbounds":[
    {
      "tag":"default"
    },
    {
      "tag":"direct",
      "protocol":"freedom",
      "streamSettings":{"sockopt":{"mark":255}}
    }
  ]
}
EOF

if [[ -z $path ]]; then
OBdefault=`cat << EOF
    {
      "tag": "default",
      "protocol": "vless",
      "settings": {
        "vnext": [
          {
            "address": "$domain",
            "port": $port,
            "users": [
              {
                "id": "$uuid",
                "encryption": "none",
                "flow": "xtls-rprx-splice",
                "level": 1
              }
            ]
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "xtls",
        "xtlsSettings": {
          "serverName": "$tls",
          "allowInsecure": false
        },
        "sockopt": {
          "mark": 255,
          "domainStrategy": "UseIP"
        }
      }
    }
EOF
`
else
OBdefault=`cat << EOF
{
      "tag": "default",
      "protocol": "vless",
      "settings": {
        "vnext": [
          {
            "address": "$domain",
            "port": $port,
            "users": [
              {
                "id": "$uuid",
                "encryption": "none",
                "level": 1
              }
            ]
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "$path"
        },
        "security": "tls",
        "tlsSettings": {
          "serverName": "$tls",
          "allowInsecure": false
        },
        "sockopt": {
          "mark": 255,
          "domainStrategy": "UseIP"
        }
      }
}
EOF
`
fi

jq --argjson OBdefault "$OBdefault" '.outbounds[0]=$OBdefault' /opt/de_GWD/vtrui/config.json | sponge /opt/de_GWD/vtrui/config.json

rm -rf /lib/systemd/system/vtrui.service
cat << EOF >/etc/systemd/system/vtrui.service
[Unit]
Description=vtrui
After=network.target nss-lookup.target

[Service]
User=root
Type=simple
ExecStart=/opt/de_GWD/vtrui/vtrui -c /opt/de_GWD/vtrui/config.json
Restart=always
RestartSec=2
TimeoutStopSec=5

CapabilityBoundingSet=CAP_NET_RAW CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_RAW CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
Nice=-11

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload >/dev/null
systemctl restart vtrui
if [[ $? -ne 0 ]]; then
sed -i '/Nice=/d' /etc/systemd/system/vtrui.service
systemctl daemon-reload >/dev/null
systemctl restart vtrui
fi
systemctl enable vtrui >/dev/null 2>&1

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}Deploy vtrui${cRES}"
}



installNftables(){
echo -e "${WHITE}[...]\c" && echo -e "\t${WHITE}Deploy nftables${cRES}\r\c"
cat << EOF >/etc/network/interfaces
source /etc/network/interfaces.d/*

auto lo
iface lo inet loopback

auto $ethernetnum
iface $ethernetnum inet static
    address $localAddrCIDR
    gateway $gatewayAddr
EOF

mkdir -p /opt/de_GWD/nftables
echo $DoGcIP $doh1IP $doh2IP | xargs -n1 | sort | uniq | sed 's/$/,/g' >/opt/de_GWD/nftables/IP_GlobalDNS
cat << EOF >/opt/de_GWD/nftables/SET_GlobalDNS.nft
#!/usr/sbin/nft -f
table ip de_GWD {
        set GlobalDNS {
                type ipv4_addr
                flags interval
                auto-merge
                elements = { $(cat /opt/de_GWD/nftables/IP_GlobalDNS) }
        }
}
EOF
chmod +x /opt/de_GWD/nftables/SET_GlobalDNS.nft
/opt/de_GWD/nftables/SET_GlobalDNS.nft &

cat << EOF >/opt/de_GWD/nftables/SET_V2NODE.nft
#!/usr/sbin/nft -f
table ip de_GWD {
        set V2NODE {
                type ipv4_addr
                flags interval
                auto-merge
                elements = { $domainIP }
        }
}
EOF
chmod +x /opt/de_GWD/nftables/SET_V2NODE.nft
/opt/de_GWD/nftables/SET_V2NODE.nft &

if [[ $(du -sk /opt/de_GWD/.repo/IPchnroute 2>/dev/null | awk '{print$1}') -gt 100 ]]; then
cp -f /opt/de_GWD/.repo/IPchnroute /opt/de_GWD/nftables/IP_CHNROUTE
sed -i '/^\s*$/d' /opt/de_GWD/nftables/IP_CHNROUTE
sed -i 's/$/,/g' /opt/de_GWD/nftables/IP_CHNROUTE
fi

[[ -n $(cat /opt/de_GWD/nftables/IP_CHNROUTE 2>&1 | grep -Po '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}') ]] && IP_CHNROUTE_elements="elements = { $(cat /opt/de_GWD/nftables/IP_CHNROUTE) }"
cat << EOF >/opt/de_GWD/nftables/SET_CHNROUTE.nft
#!/usr/sbin/nft -f
table ip de_GWD {
        set CHNROUTE {
                type ipv4_addr
                flags interval
                auto-merge
                $IP_CHNROUTE_elements
        }
}
EOF
chmod +x /opt/de_GWD/nftables/SET_CHNROUTE.nft
/opt/de_GWD/nftables/SET_CHNROUTE.nft &

[[ -n $(cat /opt/de_GWD/nftables/IP_listB 2>&1 | grep -Po '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}') ]] && IP_listB_elements="elements = { $(cat /opt/de_GWD/nftables/IP_listB) }"
cat << EOF >/opt/de_GWD/nftables/SET_listB.nft
#!/usr/sbin/nft -f
table ip de_GWD {
        set listB {
                type ipv4_addr
                flags interval
                auto-merge
                $IP_listB_elements
        }
}
EOF
chmod +x /opt/de_GWD/nftables/SET_listB.nft
/opt/de_GWD/nftables/SET_listB.nft &

[[ -n $(cat /opt/de_GWD/nftables/IP_listW 2>&1 | grep -Po '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}') ]] && IP_listW_elements="elements = { $(cat /opt/de_GWD/nftables/IP_listW) }"
cat << EOF >/opt/de_GWD/nftables/SET_listW.nft
#!/usr/sbin/nft -f
table ip de_GWD {
        set listW {
                type ipv4_addr
                flags interval
                auto-merge
                $IP_listW_elements
        }
}
EOF
chmod +x /opt/de_GWD/nftables/SET_listW.nft
/opt/de_GWD/nftables/SET_listW.nft &

[[ -n $(cat /opt/de_GWD/nftables/IP_listBlan 2>&1 | grep -Po '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}') ]] && IP_listBlan_elements="elements = { $(cat /opt/de_GWD/nftables/IP_listBlan) }"
cat << EOF >/opt/de_GWD/nftables/SET_listBlan.nft
#!/usr/sbin/nft -f
table ip de_GWD {
        set listBlan {
                type ipv4_addr
                flags interval
                auto-merge
                $IP_listBlan_elements
        }
}
EOF
chmod +x /opt/de_GWD/nftables/SET_listBlan.nft
/opt/de_GWD/nftables/SET_listBlan.nft &

[[ -n $(cat /opt/de_GWD/nftables/IP_listWlan 2>&1 | grep -Po '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}') ]] && IP_listWlan_elements="elements = { $(cat /opt/de_GWD/nftables/IP_listWlan) }"
cat << EOF >/opt/de_GWD/nftables/SET_listWlan.nft
#!/usr/sbin/nft -f
table ip de_GWD {
        set listWlan {
                type ipv4_addr
                flags interval
                auto-merge
                $IP_listWlan_elements
        }
}
EOF
chmod +x /opt/de_GWD/nftables/SET_listWlan.nft
/opt/de_GWD/nftables/SET_listWlan.nft &

cat << EOF >/opt/de_GWD/nftables/default.nft
#!/usr/sbin/nft -f
table inet filter {
        chain input {
                type filter hook input priority 0;
                iifname lo accept
                ct state established,related accept
                tcp flags != syn ct state new drop
                tcp flags & (fin|syn) == (fin|syn) drop
                tcp flags & (syn|rst) == (syn|rst) drop
                tcp flags & (fin|syn|rst|psh|ack|urg) < (fin) drop
                tcp flags & (fin|syn|rst|psh|ack|urg) == (fin|psh|urg) drop
                ct state invalid counter drop
                # Drop 53 in
        }
        chain forward {
                type filter hook forward priority 0;
                tcp flags & (syn|rst) == syn counter tcp option maxseg size set rt mtu
                # WireGuard traffic
                iifname wg0 accept
                oifname wg0 accept

                # Docker traffic
                counter jump DOCKER-USER
                counter jump DOCKER-ISOLATION-STAGE-1
                oifname docker0 ct state established,related counter accept
                oifname docker0 counter jump DOCKER
                iifname docker0 oifname != docker0 counter accept
                iifname docker0 oifname docker0 counter accept
        }
        chain output {
                type filter hook output priority 0;
                oifname lo accept
        }
        chain DOCKER {
        }
        chain DOCKER-USER {
                counter accept
        }
        chain DOCKER-ISOLATION-STAGE-1 {
                iifname docker0 oifname != docker0 counter jump DOCKER-ISOLATION-STAGE-2
                counter accept
        }
        chain DOCKER-ISOLATION-STAGE-2 {
                oifname docker0 counter drop
                counter accept
        }
}

table ip router {
        chain prerouting {
                type nat hook prerouting priority 0;
                # Docker
                fib daddr type local counter jump DOCKER
        }
        chain postrouting {
                type nat hook postrouting priority 0;
                # Wireguard masquerade traffic
                oifname $ethernetnum ip saddr 172.16.66.0/24 masquerade

                # Docker
                oifname != docker0 ip saddr 172.17.0.0/16 counter masquerade
        }
        chain input {
                type nat hook input priority 0;
        }
        chain output {
                type nat hook output priority 0;
                ip daddr != 127.0.0.0/8 fib daddr type local counter jump DOCKER
        }
        chain DOCKER {
                iifname docker0 counter accept
        }
}
EOF
chmod +x /opt/de_GWD/nftables/default.nft

cat << EOF >/opt/de_GWD/nftables/nftables
#!/usr/sbin/nft -f

include "/opt/de_GWD/nftables/*.nft"

define RESERVED_IP = {
        $localAddrCIDR,
        10.0.0.0/8,
        100.64.0.0/10,
        127.0.0.0/8,
        169.254.0.0/16,
        172.16.0.0/12,
        192.0.0.0/24,
        192.168.0.0/16,
        224.0.0.0/4,
        240.0.0.0/4,
        255.255.255.255/32,
        114.114.114.114/32,
        114.114.115.115/32,
        119.29.29.29/32,
        119.28.28.28/32,
        182.254.118.118/32,
        223.5.5.5/32,
        223.6.6.6/32
}

table ip de_GWD {
        set CHNROUTE {
                type ipv4_addr
                flags interval
                auto-merge
        }
        set GlobalDNS {
                type ipv4_addr
                flags interval
                auto-merge
        }
        set V2NODE {
                type ipv4_addr
                flags interval
                auto-merge
        }
        set listB {
                type ipv4_addr
                flags interval
                auto-merge
        }
        set listW {
                type ipv4_addr
                flags interval
                auto-merge
        }
        set listBlan {
                type ipv4_addr
                flags interval
                auto-merge
        }
        set listWlan {
                type ipv4_addr
                flags interval
                auto-merge
        }
        chain prerouting {
                type filter hook prerouting priority -310; policy accept;
                meta l4proto { tcp, udp } th dport 53 accept
                meta l4proto { tcp, udp } th dport 4711 accept
                meta l4proto { tcp, udp } th dport 5331 accept
                meta l4proto { tcp, udp } th dport 5332 accept
                meta l4proto { tcp, udp } th dport 5333 accept
                meta l4proto { tcp, udp } th dport 5341 accept
                meta l4proto { tcp, udp } th dport 5900 accept
                meta l4proto { udp } th dport 1900 accept
                meta l4proto { udp } th dport 5350 accept
                meta l4proto { udp } th dport 5351 accept
                meta l4proto { udp } th dport 5353 accept
                ip daddr @GlobalDNS accept
                ip saddr @listBlan meta l4proto { tcp, udp } tproxy to 127.0.0.1:9896 meta mark set 0x9
                ip saddr @listWlan accept
                ip daddr \$RESERVED_IP accept
                ip daddr @V2NODE accept
                ip daddr @listB meta l4proto { tcp, udp } tproxy to 127.0.0.1:9896 meta mark set 0x9
                ip daddr @listW accept
                ip daddr @CHNROUTE accept
                ip protocol { tcp, udp } tproxy to 127.0.0.1:9896 meta mark set 0x9
        }
        chain output {
                type route hook output priority -311; policy accept;
                meta l4proto { tcp, udp } th dport 53 accept
                meta l4proto { tcp, udp } th dport 4711 accept
                meta l4proto { tcp, udp } th dport 5331 accept
                meta l4proto { tcp, udp } th dport 5332 accept
                meta l4proto { tcp, udp } th dport 5333 accept
                meta l4proto { tcp, udp } th dport 5341 accept
                meta l4proto { tcp, udp } th dport 5900 accept
                meta l4proto { udp } th dport 1900 accept
                meta l4proto { udp } th dport 5350 accept
                meta l4proto { udp } th dport 5351 accept
                meta l4proto { udp } th dport 5353 accept
                ip daddr @GlobalDNS accept
                ip daddr @V2NODE accept
                ip daddr \$RESERVED_IP accept
                ip daddr @listB meta mark set 0x9
                ip daddr @listW accept
                ip daddr @CHNROUTE accept
                meta mark 0xff accept
                ip protocol { tcp, udp } meta mark set 0x9
        }
}
EOF
chmod +x /opt/de_GWD/nftables/nftables

rm -rf /lib/systemd/system/nftables.service
cat << EOF >/etc/systemd/system/nftables.service
[Unit]
Description=nftables
Wants=network-pre.target
Before=network-pre.target shutdown.target
Conflicts=shutdown.target
DefaultDependencies=no

[Service]
User=root
Type=oneshot
ExecStart=/usr/sbin/nft -f /opt/de_GWD/nftables/nftables ; $(which ip) route add local default dev lo scope host table 220 ; $(which ip) rule add fwmark 0x9 table 220 prio 100
ExecStop=/usr/sbin/nft flush ruleset ; $(which ip) rule del table 220 ; $(which ip) route del local default dev lo table 220
RemainAfterExit=yes

StandardInput=null
ProtectSystem=full
ProtectHome=true

[Install]
WantedBy=sysinit.target
EOF
systemctl daemon-reload >/dev/null
systemctl enable nftables >/dev/null 2>&1
systemctl restart nftables

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}Deploy nftables${cRES}"
}



updateAPT(){
echo -e "${WHITE}[...]\c" && echo -e "\t${WHITE}Debian Updated${cRES}\r\c"
dpkg --configure -a
cat << EOF >/etc/apt/sources.list
deb http://cloudfront.debian.net/debian bullseye main contrib non-free
deb http://cloudfront.debian.net/debian bullseye-updates main contrib non-free
deb http://cloudfront.debian.net/debian bullseye-backports main contrib non-free
deb http://cloudfront.debian.net/debian-security bullseye-security main contrib non-free
EOF

echo "deb https://packages.sury.org/php/ $(cat /etc/os-release | grep VERSION= | cut -d'(' -f2 | cut -d')' -f1) main" >/etc/apt/sources.list.d/php.list
apt-key del 95BD4743 >/dev/null 2>&1
wget --no-check-certificate -cqO /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
[[ $? -ne 0 ]] && echo -e "${WHITE}PHP apt key${RED} Download Failed${cRES}"

apt update --fix-missing && apt upgrade --allow-downgrades -y
apt full-upgrade -y && apt autoremove --purge -y && apt clean -y && apt autoclean -y

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}Debian ${GREEN}Updated${cRES}"
}



installDep(){
echo -e "${WHITE}[...]\c" && echo -e "\t${WHITE}Dependencies${cRES}\r\c"
sed -i "/www-data/d" /etc/sudoers
sed -i "/Allow members of group sudo to execute any command/a\www-data ALL=(root)  NOPASSWD:ALL" /etc/sudoers

pkgDEP1

pkgDEP2

cat << EOF >/etc/ld.so.preload
/usr/lib/$(uname -m)-linux-gnu/libjemalloc.so
EOF
ldconfig

kill $(ps -e | grep 'redis-server' | awk '{print$1}') >/dev/null 2>&1
rm -rf /dev/shm/redis-server.sock
cat << EOF >/etc/redis/redis.conf
bind 127.0.0.1
protected-mode yes
port 6379
tcp-backlog 49152
tcp-keepalive 0
unixsocket /dev/shm/redis-server.sock
unixsocketperm 777
requirepass de_GWD
daemonize yes
supervised no
pidfile /var/run/redis/redis-server.pid
loglevel warning
logfile ""
databases 16
save 3600 1
save 300 100
save 60 10000
rdbcompression no
rdbchecksum no
appendonly no
stop-writes-on-bgsave-error no
dbfilename dump.rdb
dir /var/lib/redis
requirepass de_GWD
maxclients 10000
maxmemory 64mb
maxmemory-policy allkeys-lfu
maxmemory-samples 5
lfu-log-factor 10
lfu-decay-time 1
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 32mb
EOF

rm -rf /lib/systemd/system/redis-server.service
cat << EOF >/etc/systemd/system/redis-server.service
[Unit]
Description=redis-server
After=network.target

[Service]
User=redis
Group=redis
Type=forking
ExecStart=/usr/bin/redis-server /etc/redis/redis.conf
Restart=always
RestartSec=2
TimeoutStopSec=5

Nice=-9
LimitCORE=infinity
LimitNOFILE=infinity
LimitNPROC=infinity

UMask=007
PrivateTmp=yes
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload >/dev/null
systemctl restart redis-server
if [[ $? -ne 0 ]]; then
sed -i '/Nice=/d' /etc/systemd/system/redis-server.service
systemctl daemon-reload >/dev/null
systemctl restart redis-server
fi
systemctl enable redis-server >/dev/null 2>&1



if [[ -z $(dpkg -l | awk '{print$2}' | grep '^lighttpd-mod-deflate$') ]]; then
[[ $(printf '%s\n' $(lighttpd -v 2>&1 | grep -Po '(\d+\.)+\d+') "1.4.42" | sort -rV | head -n 1) != "1.4.42" ]] && apt install lighttpd-mod-deflate
fi

DPKGclean=$(dpkg --list | grep "^rc" | cut -d " " -f 3)
[[ -n $DPKGclean ]] && echo $DPKGclean | xargs sudo dpkg --purge

rm -rf /var/log/journal/*
systemctl restart systemd-journald

if [[ -d "/usr/local/ioncube" ]]; then
echo "zend_extension = /usr/local/ioncube/ioncube_loader_lin_7.4.so" >/etc/php/7.4/mods-available/ioncube.ini
ln -sf /etc/php/7.4/mods-available/ioncube.ini /etc/php/7.4/fpm/conf.d/00-ioncube.ini
ln -sf /etc/php/7.4/mods-available/ioncube.ini /etc/php/7.4/cli/conf.d/00-ioncube.ini
fi

sed -i "/engine =/c\engine = off" /etc/php/7.4/fpm/php.ini
sed -i "/enable_dl =/c\enable_dl = off" /etc/php/7.4/fpm/php.ini
sed -i "/disable_functions =/c\disable_functions =" /etc/php/7.4/fpm/php.ini
sed -i "/disable_classes =/c\disable_classes =" /etc/php/7.4/fpm/php.ini
sed -i "/^upload_max_filesize/c\upload_max_filesize = 10M" /etc/php/7.4/fpm/php.ini
sed -i "/^post_max_size/c\post_max_size = 10M" /etc/php/7.4/fpm/php.ini
sed -i "/^memory_limit/c\memory_limit = 512m" /etc/php/7.4/fpm/php.ini
sed -i "/^max_execution_time/c\max_execution_time = 1800" /etc/php/7.4/fpm/php.ini
sed -i "/^max_input_time/c\max_input_time = 1800" /etc/php/7.4/fpm/php.ini
sed -i "/^max_input_vars/c\max_input_vars = 2000" /etc/php/7.4/fpm/php.ini
sed -i "/zend_extension/d" /etc/php/7.4/fpm/php.ini
sed -i "/zend_extension/d" /etc/php/7.4/cli/php.ini
sed -i "s/^opcache/;&/" /etc/php/7.4/fpm/php.ini
sed -i "s/^opcache/;&/" /etc/php/7.4/cli/php.ini

cat << EOF >/etc/php/7.4/mods-available/opcache.ini
; configuration for php opcache module
; priority=10
zend_extension=opcache.so
opcache.enable=1
opcache.enable_cli=1
opcache.jit_buffer_size=512M
opcache.memory_consumption=512
opcache.interned_strings_buffer=64
opcache.max_accelerated_files=10000
opcache.validate_timestamps=1
opcache.revalidate_freq=60
opcache.fast_shutdown=1
opcache.save_comments=1
EOF

rm -rf /var/log/php7.4-fpm.log
cat << EOF >/etc/php/7.4/fpm/php-fpm.conf
[global]
pid = /run/php/php7.4-fpm.pid
error_log = /var/log/php.log

include=/etc/php/7.4/fpm/pool.d/*.conf
EOF

cat << EOF >/etc/php/7.4/fpm/pool.d/www.conf
[www]
user = www-data
group = www-data
listen.owner = www-data
listen.group = www-data
listen.mode = 0666
listen = /run/php/php7.4-fpm.sock

pm = dynamic
pm.max_children = 25
pm.start_servers = 10
pm.min_spare_servers = 5
pm.max_spare_servers = 20
pm.max_requests = 500

env[HOSTNAME] = \$HOSTNAME
env[PATH] = /usr/local/bin:/usr/bin:/bin
env[TMP] = /tmp
env[TMPDIR] = /tmp
env[TEMP] = /tmp
EOF

rm -rf /lib/systemd/system/php7.4-fpm.service
cat << EOF >/etc/systemd/system/php7.4-fpm.service
[Unit]
Description=The PHP 7.4 FastCGI Process Manager
After=network.target

[Service]
User=root
Type=notify
PIDFile=/run/php7.4-fpm.pid
ExecStart=/usr/sbin/php-fpm7.4 --nodaemonize --fpm-config /etc/php/7.4/fpm/php-fpm.conf
ExecStopPost=$(which rm) -f /run/php7.4-fpm.pid
ExecReload=/bin/kill -USR2 \$MAINPID
Restart=always
RestartSec=2
TimeoutStopSec=5

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload >/dev/null
systemctl enable php7.4-fpm >/dev/null 2>&1
systemctl restart php7.4-fpm

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}Dependencies${cRES}"
}



installNginx(){
echo -e "${WHITE}[...]\c" && echo -e "\t${WHITE}Nginx${cRES}\r\c"
mkdir -p "/var/www/html"
mkdir -p "/var/www/ssl"
mkdir -p "/etc/nginx"
mkdir -p "/etc/nginx/conf.d"
mkdir -p "/var/log/nginx"
mkdir -p "/var/cache/nginx/client_temp"
mkdir -p "/var/cache/nginx/proxy_temp"
mkdir -p "/var/cache/nginx/fastcgi_temp"
mkdir -p "/var/cache/nginx/scgi_temp"
mkdir -p "/var/cache/nginx/uwsgi_temp"

if [[ -n $(unzip -tq /opt/de_GWD/.repo/nginxConf.zip | grep "No errors detected in compressed data") ]]; then
rm -rf /tmp/nginxConf
unzip /opt/de_GWD/.repo/nginxConf.zip -d /tmp >/dev/null
mv -f /tmp/nginxConf/* /etc/nginx
rm -rf /tmp/nginxConf
else
rm -rf /opt/de_GWD/.repo/nginxConf.zip
echo -e "${WHITE}NGINX Configure${RED} Download Failed${cRES}" && exit
fi

rm -rf /lib/systemd/system/nginx.service
cat << EOF >/etc/systemd/system/nginx.service
[Unit]
Description=NGINX
After=network.target

[Service]
User=root
Type=forking
PIDFile=/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf
ExecReload=/usr/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT \$MAINPID
ExecStopPost=$(which rm) -f /run/nginx.pid
KillMode=process
Restart=always
RestartSec=2
TimeoutStopSec=5

AmbientCapabilities=CAP_NET_RAW CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
EOF
mkdir -p "/etc/systemd/system/nginx.service.d"
printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" >/etc/systemd/system/nginx.service.d/override.conf
systemctl daemon-reload >/dev/null
systemctl restart nginx
systemctl enable nginx >/dev/null 2>&1
}



nginxSet(){
[[ ! -f "/var/www/ssl/dhparam.pem" ]] && openssl dhparam -out /var/www/ssl/dhparam.pem 2048

if [[ ! -f "/var/www/ssl/de_GWD.cer" ]] || [[ ! -f "/var/www/ssl/de_GWD.key" ]]; then
cd /var/www/ssl
openssl req -x509 -nodes -days 3650 \
  -subj "/C=CA/ST=QC/O=Company, Inc./CN=localhost.com" \
  -config <(cat /etc/ssl/openssl.cnf \
    <(printf '[SAN]\nsubjectAltName=DNS:localhost')) \
  -newkey rsa:2048 \
  -keyout de_GWD.key \
  -out de_GWD.cer
cd ~
fi

[[ -z $serverName ]] && serverName="de_GWD"

[[ -z $(echo $webUIport | grep '^[[:digit:]]*$') ]] && webUIport="443"
jq --arg webUIport $webUIport '.address.webUIport=$webUIport' /opt/de_GWD/0conf | sponge /opt/de_GWD/0conf

if [[ $webUIport = 443 ]]; then
cat << EOF >/etc/nginx/conf.d/80.conf
server {
  listen 80;
  server_name $serverName;
  return 301 https://\$host\$request_uri;
}
EOF
else
rm -rf /etc/nginx/conf.d/80.conf
fi

touch /etc/nginx/conf.d/default.conf
sed -i '/SERVER_BASE_START/,/SERVER_BASE_END/d' /etc/nginx/conf.d/default.conf
sed -i '/PHP_START/,/PHP_END/d' /etc/nginx/conf.d/default.conf
sed -i '/TTYD_START/,/TTYD_END/d' /etc/nginx/conf.d/default.conf
sed -i '/NETDATA_START/,/NETDATA_END/d' /etc/nginx/conf.d/default.conf
sed -i '$s/}$//' /etc/nginx/conf.d/default.conf

until [[ $(head -1 /etc/nginx/conf.d/default.conf | cat -e) != "$" ]]; do
   sed -i '1d' /etc/nginx/conf.d/default.conf
done

until [[ $(tail -1 /etc/nginx/conf.d/default.conf | cat -e) != "$" ]]; do
   sed -i '$d' /etc/nginx/conf.d/default.conf
done

cat << EOF >/etc/nginx/conf.d/default.conf
# SERVER_BASE_START
server {
  listen $webUIport ssl http2 fastopen=128 reuseport;
  server_name $serverName;
  root /var/www/html;
  index index.php index.html index.htm;

  ssl_certificate /var/www/ssl/de_GWD.cer;
  ssl_certificate_key /var/www/ssl/de_GWD.key;
  ssl_dhparam /var/www/ssl/dhparam.pem;
  ssl_protocols TLSv1.2 TLSv1.3;
  ssl_ecdh_curve CECPQ2:X25519:P-256;
  ssl_prefer_server_ciphers off;
  ssl_ciphers [ECDHE-ECDSA-AES128-GCM-SHA256|ECDHE-ECDSA-CHACHA20-POLY1305]:[ECDHE-RSA-AES128-GCM-SHA256|ECDHE-RSA-CHACHA20-POLY1305]:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256;
  ssl_session_cache builtin:1000 shared:SSL:10m;
  ssl_buffer_size 4k;

  ssl_early_data on;
  proxy_set_header Early-Data \$ssl_early_data;

  add_header Referrer-Policy                    "origin"            always;
  add_header X-Content-Type-Options             "nosniff"           always;
  add_header X-Download-Options                 "noopen"            always;
  add_header X-Frame-Options                    "SAMEORIGIN"        always;
  add_header X-Permitted-Cross-Domain-Policies  "none"              always;
  add_header X-Robots-Tag                       "none"              always;
  add_header X-XSS-Protection                   "1; mode=block"     always;
  add_header Strict-Transport-Security          "max-age=63072000"  always;
# SERVER_BASE_END

# PHP_START
location ~ [^/]\.php(/|$) {
  fastcgi_split_path_info ^(.+?\.php)(/.*)$;
  if (!-f \$document_root\$fastcgi_script_name) {
      return 404;
  }

  fastcgi_pass        unix:/run/php/php7.4-fpm.sock;
  fastcgi_index       index.php;
  include             fastcgi_params;
  fastcgi_param       HTTP_PROXY "";
  fastcgi_param       FQDN true;
}
# PHP_END

# TTYD_START
location ~ ^/ttyd(.*)$ {
  proxy_pass                  http://127.0.0.1:3000/\$1;
  proxy_http_version          1.1;
  proxy_set_header            Upgrade \$http_upgrade;
  proxy_set_header            Connection "upgrade";
  proxy_set_header            Host \$host;
  proxy_set_header            X-Forwarded-Proto \$scheme;
  proxy_set_header            X-Forwarded-For \$proxy_add_x_forwarded_for;
  keepalive_timeout           600s;
  proxy_connect_timeout       600s;
  proxy_read_timeout          600s;
  proxy_send_timeout          600s;
  proxy_redirect              off;
  proxy_store                 off;
  add_header                  X-Cache \$upstream_cache_status;
  add_header                  Cache-Control no-cache;
}
# TTYD_END

$(cat /etc/nginx/conf.d/default.conf 2>/dev/null)
}
EOF

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}Nginx${cRES}"
}



installWebUI(){
rm -rf /tmp/ui-script
rm -rf /tmp/ui-web
unzip /opt/de_GWD/.repo/client.zip -d /tmp >/dev/null 2>&1

rm -rf /opt/de_GWD/ui-*
rm -rf /opt/de_GWD/ui_*
rm -rf /var/www/html/*.php
rm -rf /var/www/html/*.ico
rm -rf /var/www/html/act
rm -rf /var/www/html/vendor
rm -rf /var/www/html/css
rm -rf /var/www/html/js

mv -f /tmp/ui-script/* /opt/de_GWD >/dev/null
mv -f /tmp/ui-web/* /var/www/html >/dev/null

mkdir -p /var/www/html/restore
chown -R www-data:www-data /var/www/html
chmod -R +x /var/www/html
chmod +x /opt/de_GWD/*

if [[ $TTYD_UPDATE = "true" ]]; then
[[ -z $(echo $updatePort | grep '^[[:digit:]]*$') ]] && updatePort="3000"

rm -rf /lib/systemd/system/updateGWD.service
cat << EOF >/etc/systemd/system/updateGWD.service
[Unit]
Description=updateGWD
After=network.target

[Service]
User=root
Type=oneshot
ExecStartPre=/usr/bin/chmod +x /opt/de_GWD/update
ExecStart=/usr/bin/tmux new -ds 'updateGWD' /usr/bin/ttyd -p $updatePort -o /opt/de_GWD/update
KillMode=process

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload >/dev/null
fi

if [[ $(du -sk /var/www/html/spt 2>/dev/null | awk '{print$1}') -lt 102400 ]]; then
  dd if=/dev/zero of=/var/www/html/spt bs=1k count=100k status=progress
fi

cp -f /opt/de_GWD/.repo/version.php /var/www/html/act/version.php
}



piholeConf(){
rm -rf /etc/pihole/setupVars*
cat << EOF >/etc/pihole/setupVars.conf
PIHOLE_INTERFACE=$ethernetnum
WEBPASSWORD=$piholePW
IPV4_ADDRESS=$localAddrCIDR
PIHOLE_DNS_1=127.0.0.1#5341
API_EXCLUDE_DOMAINS=www.google.com,www.baidu.com,raw.githubusercontent.com,api.cloudflare.com,myip.ipip.net,v4.yinghualuo.cn,www.f3322.org,*.in-addr.arpa,*._udp.lan
QUERY_LOGGING=true
INSTALL_WEB_SERVER=true
INSTALL_WEB_INTERFACE=true
LIGHTTPD_ENABLED=false
CACHE_SIZE=10000
DNS_FQDN_REQUIRED=true
DNS_BOGUS_PRIV=true
DNSSEC=false
REV_SERVER=false
DNSMASQ_LISTENING=single
BLOCKING_ENABLED=true
EOF
}



installPihole(){
echo -e "${WHITE}[...]\c" && echo -e "\t${WHITE}Install Pi-hole${cRES}\r\c"
piholeCoreRelease=$(curl -sSL "https://api.github.com/repos/pi-hole/pi-hole/releases/latest" | jq -r '.tag_name' | grep -v '^null$')
piholeFTLRelease=$(curl -sSL "https://api.github.com/repos/pi-hole/FTL/releases/latest" | jq -r '.tag_name' | grep -v '^null$')
piholeWebUIRelease=$(curl -sSL "https://api.github.com/repos/pi-hole/AdminLTE/releases/latest" | jq -r '.tag_name' | grep -v '^null$')

[[ -z $piholeCoreRelease ]] && piholeCoreRelease=$piholeCoreRelease_reserved
[[ -z $piholeFTLRelease ]] && piholeFTLRelease=$piholeFTLRelease_reserved
[[ -z $piholeWebUIRelease ]] && piholeWebUIRelease=$piholeWebUIRelease_reserved
[[ -z $piholePW ]] && piholePW="0000000000000000000000000000000000000000000000000000000000000000"

piholeCoreVer=$(awk '{print$1}' /etc/pihole/localversions 2>/dev/null | grep -Po "^v(\d+\.)+\d+")
piholeWebUIVer=$(awk '{print$2}' /etc/pihole/localversions 2>/dev/null | grep -Po "^v(\d+\.)+\d+")
piholeFTLVer=$(awk '{print$3}' /etc/pihole/localversions 2>/dev/null | grep -Po "^v(\d+\.)+\d+")

if [[ $piholeCoreVer != $piholeCoreRelease ]] || [[ $piholeFTLVer != $piholeFTLRelease ]] || [[ $piholeWebUIVer != $piholeWebUIRelease ]] || [[ $(systemctl is-active 'pihole-FTL') != "active" ]]; then
export PIHOLE_SKIP_OS_CHECK=true
rm -rf /etc/.pihole /etc/pihole /opt/pihole /usr/bin/pihole-FTL /usr/local/bin/pihole /var/www/html/pihole /var/www/html/admin /var/log/pihole* /etc/dnsmasq.d/*
systemctl unmask lighttpd >/dev/null 2>&1
systemctl unmask dhcpcd >/dev/null 2>&1

mkdir -p /etc/.pihole
mkdir -p /etc/pihole
cat << EOF >/etc/pihole/adlists.list
https://ewpratten.github.io/youtube_ad_blocklist/hosts.ipv4.txt
EOF

piholeConf

git clone https://github.com/pi-hole/pi-hole /etc/.pihole
curl -sSL https://install.pi-hole.net | bash /dev/stdin --unattended
chmod -R 755 /var/www/html
usermod -aG pihole www-data

/opt/pihole/updatecheck.sh

PIHOLE_UPDATE="true"
fi
}



piholeSet(){
systemctl disable --now lighttpd >/dev/null 2>&1
systemctl disable --now dhcpcd >/dev/null 2>&1
systemctl mask --now lighttpd >/dev/null 2>&1
systemctl mask --now dhcpcd >/dev/null 2>&1
systemctl daemon-reload >/dev/null

rm -rf /var/www/html/index.lighttpd.orig
update-rc.d -f dhcpd remove >/dev/null 2>&1

cat << EOF >/etc/hosts
127.0.0.1       localhost
$localAddr      $(hostname).local       $(hostname)

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

piholeConf

>/etc/pihole/dns-servers.conf
cat << EOF >/etc/pihole/pihole-FTL.conf
BLOCKINGMODE=NULL
CNAME_DEEP_INSPECT=true
BLOCK_ESNI=true
EDNS0_ECS=false
RATE_LIMIT=0/0
REPLY_WHEN_BUSY=ALLOW

MAXLOGAGE=24.0
PRIVACYLEVEL=0
IGNORE_LOCALHOST=no
AAAA_QUERY_ANALYSIS=no
ANALYZE_ONLY_A_AND_AAAA=false
SHOW_DNSSEC=false

SOCKET_LISTENING=localonly
FTLPORT=4711
RESOLVE_IPV6=no
RESOLVE_IPV4=yes
PIHOLE_PTR=HOSTNAME
DELAY_STARTUP=0
NICE=-10
MAXNETAGE=14
NAMES_FROM_NETDB=true
REFRESH_HOSTNAMES=IPV4
PARSE_ARP_CACHE=true
CHECK_LOAD=false
CHECK_SHMEM=90
CHECK_DISK=90

DBIMPORT=yes
MAXDBDAYS=14
DBINTERVAL=60.0
DBFILE=/etc/pihole/pihole-FTL.db
LOGFILE=/var/log/pihole-FTL.log
PIDFILE=/run/pihole-FTL.pid
PORTFILE=/run/pihole-FTL.port
SOCKETFILE=/run/pihole/FTL.sock
SETUPVARSFILE=/etc/pihole/setupVars.conf
MACVENDORDB=/etc/pihole/macvendor.db
GRAVITYDB=/etc/pihole/gravity.db
EOF

cat << "EOF" >/opt/de_GWD/pihole_hotfix
#!/bin/bash
localIP=$(jq -r '.address.localIP' /opt/de_GWD/0conf | grep -Po '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}')
sed -i "/dhcp-option=/c\dhcp-option=6,$localIP,$localIP" /etc/dnsmasq.d/02-pihole-dhcp.conf
pihole restartdns
EOF
chmod +x /opt/de_GWD/pihole_hotfix

sed -i '/pihole_hotfix/d' /var/www/html/admin/scripts/pi-hole/php/savesettings.php
sed -i "/sudo pihole -a enabledhcp/a\exec('sudo /opt/de_GWD/pihole_hotfix >/dev/null 2>&1 &');" /var/www/html/admin/scripts/pi-hole/php/savesettings.php

[[ PIHOLE_UPDATE = "true" ]] && /opt/de_GWD/ui-submitADList

wget --show-progress -cqO /etc/dnsmasq.d/89-bogus-nxdomain.china.conf https://cdn.jsdelivr.net/gh/felixonmars/dnsmasq-china-list@master/bogus-nxdomain.china.conf

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}Pi-hole Config ${cRES}"
}



postInstall(){
/opt/de_GWD/ui-NodeOne
/opt/de_GWD/ui_4am
/opt/de_GWD/ui_4h

if [[ $(jq -r '.FORWARD.block53' /opt/de_GWD/0conf 2>/dev/null) = "on" ]]; then
  /opt/de_GWD/ui-block53on
fi

rm -rf /etc/dnsmasq.conf.old
cat << EOF >/etc/dnsmasq.conf
conf-dir=/etc/dnsmasq.d
listen-address=127.0.0.1
port=53
EOF
if [[ -n $(find /sys/class/net | grep wg0) ]]; then
    echo "interface=wg0" >/etc/dnsmasq.d/00-wg.conf
else
    rm -rf /etc/dnsmasq.d/00-wg.conf
fi
echo
sed -i '/log-facility=/c\log-facility=/dev/null' /etc/dnsmasq.d/01-pihole.conf
sed -i '/server=/d' /etc/dnsmasq.d/01-pihole.conf
awk '/PIHOLE_DNS_/' /etc/pihole/setupVars.conf | cut -d = -f 2 | sed 's/^/server=/g' >>/etc/dnsmasq.d/01-pihole.conf

cat << EOF >/etc/dnsmasq.d/99-extra.conf
dns-forward-max=10000
edns-packet-max=1280
all-servers
EOF

if [[ $(jq -r '.address.dhcp' /opt/de_GWD/0conf 2>/dev/null) = "on" ]]; then
  /opt/de_GWD/ui-DHCPon
else
  /opt/de_GWD/ui-DHCPoff
fi

if [[ -n $(jq -r '.address.alias' /opt/de_GWD/0conf 2>/dev/null | grep -v '^null$') ]]; then
  /opt/de_GWD/ui-markThis >/dev/null 2>&1
fi

if [[ $(jq -r '.v2nodeDIV.nodeSM.status' /opt/de_GWD/0conf 2>/dev/null) = "on" ]]; then
  /opt/de_GWD/ui-NodeSM >/dev/null 2>&1
fi

if [[ $(jq -r '.v2nodeDIV.nodeCU.status' /opt/de_GWD/0conf 2>/dev/null) = "on" ]]; then
  /opt/de_GWD/ui-NodeCU >/dev/null 2>&1
fi

if [[ $(jq -r '.v2nodeDIV.nodeDT.status' /opt/de_GWD/0conf 2>/dev/null) = "on" ]]; then
  /opt/de_GWD/ui-NodeDT >/dev/null 2>&1
fi

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}V2 Split${cRES}"

if [[ $(jq -r '.FORWARD.FWD1.status' /opt/de_GWD/0conf 2>/dev/null) = "on" ]];then
  /opt/de_GWD/ui-FWD1save >/dev/null 2>&1
fi

if [[ $(jq -r '.FORWARD.DoGs.status' /opt/de_GWD/0conf 2>/dev/null) = "on" ]];then
  /opt/de_GWD/ui-DoGsSave >/dev/null 2>&1
fi

if [[ $(jq -r '.FORWARD.Rproxy.client.status' /opt/de_GWD/0conf 2>/dev/null) = "on" ]];then
  /opt/de_GWD/ui-RproxyCsave >/dev/null 2>&1
fi

if [[ $(jq -r '.FORWARD.Rproxy.server.status' /opt/de_GWD/0conf 2>/dev/null) = "on" ]];then
  /opt/de_GWD/ui-RproxySsave >/dev/null 2>&1
fi

systemctl restart vtrui

/opt/de_GWD/ui_2h

cat << EOF > /etc/rc.local
#!/bin/bash
find /sys/class/net ! -type d | xargs --max-args=1 realpath | awk -F\/ '/pci/{print \$NF}' | while read line; do
ethtool -s \$line duplex full >/dev/null 2>&1
ethtool -K \$line rx off tx off sg off tso off gso off gro off lro off rxvlan off txvlan off rx-gro-hw off >/dev/null 2>&1
done

ip route change \$(ip route show | grep '^default' | head -1) initcwnd 32 initrwnd 32 >/dev/null 2>&1
EOF
chmod +x /etc/rc.local
/etc/rc.local

crontab -l 2>/dev/null >/tmp/now.cron
sed -i '/\/opt\/de_GWD\/ui_4am/d' /tmp/now.cron
sed -i '/\/opt\/de_GWD\/ui_4h/d' /tmp/now.cron
sed -i '/\/opt\/de_GWD\/ui_2h/d' /tmp/now.cron
cat << EOF >>/tmp/now.cron
0 4 * * * /opt/de_GWD/ui_4am u
0 */4 * * * /opt/de_GWD/ui_4h
0 */2 * * * /opt/de_GWD/ui_2h
EOF
crontab /tmp/now.cron
rm -rf /tmp/now.cron
service cron restart

rm -rf /tmp/ui-script
rm -rf /tmp/ui-web
rm -rf /tmp/client.zip
rm -rf /opt/de_GWD/update

if [[ $(dpkg --list | grep linux-image | wc -l) != "1" ]]; then
echo -e "${WHITE}[ ${YELLOW}! ${WHITE}]\c" && echo -e "\t${YELLOW}Kernel updated${cRES}"
fi
}



install3rdKernel(){
bash <(wget --show-progress -cqO- https://raw.githubusercontent.com/jacyl4/de_GWD/main/resource/kernel/install3rdKernel)
}

restoreKernel(){
bash <(wget --show-progress -cqO- https://raw.githubusercontent.com/jacyl4/de_GWD/main/resource/kernel/installDefaultKernel)
}



changeWP(){
    echo -e "${GREEN}=========================== ${cRES}"
    echo -e "${GREEN} Web UI Port${cRES}"
    echo -e "${GREEN}=========================== ${cRES}"
    read webUIport

    echo -e "${GREEN}=========================== ${cRES}"
    echo -e "${GREEN} Web update Port${cRES}"
    echo -e "${GREEN}=========================== ${cRES}"
    read updatePort

serverName=$(jq -r '.address.serverName' /opt/de_GWD/0conf 2>/dev/null | grep -v '^null$')

nginxSet
systemctl force-reload nginx >/dev/null

sed -i "/ExecStart=/c\ExecStart=/usr/bin/ttyd -p $updatePort -o /opt/de_GWD/update" /etc/systemd/system/updateGWD.service
systemctl daemon-reload >/dev/null

jq --arg updatePort $updatePort '.update.updatePort=$updatePort' /opt/de_GWD/0conf | sponge /opt/de_GWD/0conf

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}Web UI Port & Web update Port ${GREEN}Updated${cRES}"
}



changePWD(){
sudo pihole -a -p

piholePW=$(awk '/WEBPASSWORD/' /etc/pihole/setupVars.conf 2>/dev/null | cut -d= -f2)

jq --arg piholePW "$piholePW" '.address.PWD = $piholePW' /opt/de_GWD/0conf | sponge /opt/de_GWD/0conf
chmod 666 /opt/de_GWD/0conf

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}Password ${GREEN}Changed${cRES}"
}



installGWD(){
    echo -e "${GREEN}=========================== ${cRES}"
    echo -e "${GREEN} de_GWD local IP address${cRES}"
    echo -e "${GREEN}=========================== ${cRES}"
    read localAddr

    echo -e "${GREEN}=========================== ${cRES}"
    echo -e "${GREEN} Upstream route IP address${cRES}"
    echo -e "${GREEN}=========================== ${cRES}"
    read gatewayAddr

    echo -e "${GREEN}=========================== ${cRES}"
    echo -e "${GREEN} DoG / DoH${cRES}"
    echo -e "${GREEN}=========================== ${cRES}"
    read DoGorDOH

    echo -e "${GREEN}=========================== ${cRES}"
    echo -e "${GREEN} Address${cRES}"
    echo -e "${GREEN}=========================== ${cRES}"
    read v2addr

    echo -e "${GREEN}=========================== ${cRES}"
    echo -e "${GREEN} UUID${cRES}"
    echo -e "${GREEN}=========================== ${cRES}"
    read uuid

    echo -e "${GREEN}=========================== ${cRES}"
    echo -e "${GREEN} Path${cRES}"
    echo -e "${GREEN}=========================== ${cRES}"
    read path

ethernetnum=$(ip --oneline link show up | grep -v "lo" | awk '{print$2;exit}' | cut -d':' -f1 | cut -d'@' -f1)
netmask=$(ip route | grep "$ethernetnum" | awk 'NR==2{print$1}' | sed -r 's/([0-9]{1,3}\.){3}[0-9]{1,3}//g')
localAddr=$(echo $localAddr | grep -Po '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}')
localAddrCIDR=$(echo "$localAddr$netmask")

if [[ $DoGorDOH =~ "/dq" ]]; then
doh1=$DoGorDOH
else
DoG=$DoGorDOH
fi

domain=$(echo $v2addr | cut -d: -f1)
port=$(echo $v2addr | cut -d: -f2 | grep '^[[:digit:]]*$')
[[ -z $port ]] && port="443"
tls=$domain

rm -rf /etc/resolv.conf
cat << EOF >/etc/resolv.conf
nameserver 119.29.29.29
nameserver 182.254.118.118
nameserver 114.114.114.114
nameserver 223.5.5.5
EOF

[[ $architecture = "arm64" ]] && apt-mark hold $(dpkg -l | grep 'linux-image-' | awk '{print $2}'); rm -rf /etc/apt/sources.list.d/armbian.list

dpkg --configure -a

if [[ $(cat /etc/os-release | grep VERSION= | cut -d'(' -f2 | cut -d')' -f1) = "stretch" ]]; then
cat << EOF >/etc/apt/sources.list
deb http://$chnAPTsource/debian buster main contrib non-free
deb http://$chnAPTsource/debian buster-updates main contrib non-free
deb http://$chnAPTsource/debian-security buster/updates main contrib non-free
EOF

sed -i "s/ stretch / buster /g" /etc/apt/sources.list.d/* >/dev/null 2>&1
apt update --fix-missing && apt upgrade --allow-downgrades -y
apt full-upgrade -y && apt autoremove --purge -y && apt clean -y && apt autoclean -y
fi

cat << EOF >/etc/apt/sources.list
deb http://$chnAPTsource/debian bullseye main contrib non-free
deb http://$chnAPTsource/debian bullseye-updates main contrib non-free
deb http://$chnAPTsource/debian bullseye-backports main contrib non-free
deb http://$chnAPTsource/debian-security bullseye-security main contrib non-free
EOF

sed -i "s/ buster / bullseye /g" /etc/apt/sources.list.d/* >/dev/null 2>&1
apt update --fix-missing && apt upgrade --allow-downgrades -y
apt full-upgrade -y && apt autoremove --purge -y && apt clean -y && apt autoclean -y

preInstall

preConf

preDL

installSmartDNS

installXray

installNftables

echo "{}" >/opt/de_GWD/0conf
jq '.address={}' /opt/de_GWD/0conf |\
jq '.dns={}' |\
jq '.v2node=[]' |\
jq '.update={}' |\
jq --arg localIP "$localAddrCIDR" '.address.localIP=$localIP' |\
jq --arg upstreamIP "$gatewayAddr" '.address.upstreamIP=$upstreamIP' |\
jq --arg domain "$v2addr" '.v2node[0].domain=$domain' |\
jq --arg name "$v2addr" '.v2node[0].name=$name' |\
jq --arg uuid "$uuid" '.v2node[0].uuid=$uuid' |\
jq --arg path "$path" '.v2node[0].path=$path' |\
jq --arg updateAddr "$localAddr" '.update.updateAddr=$updateAddr' |\
jq --arg updatePort "3000" '.update.updatePort=$updatePort' |\
jq --arg updateCMD "$installCMD" '.update.updateCMD=$updateCMD' |\
jq --arg domain "$domain" '.update.v2node.domain=$domain' |\
jq --arg port "$port" '.update.v2node.port=$port' |\
jq --arg tls "$tls" '.update.v2node.tls=$tls' |\
jq --arg uuid "$uuid" '.update.v2node.uuid=$uuid' |\
jq --arg path "$path" '.update.v2node.path=$path' | sponge /opt/de_GWD/0conf
[[ -n $DoG ]] && jq --arg DoG "$DoG" '.dns.DoG=$DoG' /opt/de_GWD/0conf | sponge /opt/de_GWD/0conf
[[ -n $doh1 ]] && jq --arg doh1 "$doh1" '.dns.doh+=[$doh1]' /opt/de_GWD/0conf | sponge /opt/de_GWD/0conf
chmod 666 /opt/de_GWD/0conf

de_GWDconnect

updateAPT

apt --reinstall install ca-certificates

installDep

repoDL

installNginx

nginxSet

installWebUI

installPihole

piholeSet

postInstall

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}de_GWD ${GREEN}Installed${cRES}"
}



updateGWD(){
[[ -f "/opt/de_GWD/version.php" ]] && echo -e "${RED}This is not client${cRES}" && exit

cleanDep

preUpdate

if [[ $1 = "auto" ]]; then
de_GWDconnect u a
else
de_GWDconnect u
fi

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}de_GWD ${GREEN}Updated${cRES}"
}



updateGWD_Green(){
repoDL

installDep

installNginx

nginxSet

installWebUI

installPihole

piholeSet

preInstall

preConf

installSmartDNS

installXray

installNftables

postInstall
}

updateGWD_Red(){
preInstall

preConf

preDL

installSmartDNS

installXray

installNftables

de_GWDconnect

installDep

repoDL

installNginx

nginxSet

installWebUI

installPihole

piholeSet

postInstall
}



start_menu(){
echo
if [[ $(systemctl is-active 'smartdns') = "active" ]]; then
  echo -e "${WHITE} SmartDNS       \c" && echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]${cRES}"
elif [[ ! -x "/opt/de_GWD/smartdns/smartdns" ]]; then
  echo -e "${WHITE} SmartDNS       \c" && echo -e "${WHITE}[ ${YELLOW}! ${WHITE}]${cRES}"
else
  echo -e "${WHITE} SmartDNS       \c" && echo -e "${WHITE}[ ${RED}✕ ${WHITE}]${cRES}"
fi

if [[ $(systemctl is-active 'mosdns') = "active" ]]; then
  echo -e "${WHITE} mosdns         \c" && echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]${cRES}"
elif [[ ! -x "/opt/de_GWD/mosdns/mosdns" ]]; then
  echo -e "${WHITE} mosdns         \c" && echo -e "${WHITE}[ ${YELLOW}! ${WHITE}]${cRES}"
else
  echo -e "${WHITE} mosdns         \c" && echo -e "${WHITE}[ ${RED}✕ ${WHITE}]${cRES}"
fi

if [[ $(systemctl is-active 'pihole-FTL') = "active" ]]; then
  echo -e "${WHITE} Pi-hole        \c" && echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]${cRES}"
elif [[ ! -x "/usr/local/bin/pihole" ]]; then
  echo -e "${WHITE} Pi-hole        \c" && echo -e "${WHITE}[ ${YELLOW}! ${WHITE}]${cRES}"
else
  echo -e "${WHITE} Pi-hole        \c" && echo -e "${WHITE}[ ${RED}✕ ${WHITE}]${cRES}"
fi

if [[ $(systemctl is-active 'vtrui') = "active" ]]; then
  echo -e "${WHITE} Xray           \c" && echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]${cRES}"
elif [[ ! -x "/opt/de_GWD/vtrui/vtrui" ]]; then
  echo -e "${WHITE} Xray           \c" && echo -e "${WHITE}[ ${YELLOW}! ${WHITE}]${cRES}"
else
  echo -e "${WHITE} Xray           \c" && echo -e "${WHITE}[ ${RED}✕ ${WHITE}]${cRES}"
fi

if [[ $(systemctl is-active 'nginx') = "active" ]]; then
  echo -e "${WHITE} Nginx          \c" && echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]${cRES}"
elif [[ ! -x "/usr/sbin/nginx" ]]; then
  echo -e "${WHITE} Nginx          \c" && echo -e "${WHITE}[ ${YELLOW}! ${WHITE}]${cRES}"
else
  echo -e "${WHITE} Nginx          \c" && echo -e "${WHITE}[ ${RED}✕ ${WHITE}]${cRES}"
fi

if [[ $(systemctl is-active 'php7.4-fpm') = "active" ]]; then
  echo -e "${WHITE} php7.4-FPM     \c" && echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]${cRES}"
elif [ ! -f "/etc/php/7.4/fpm/php-fpm.conf" ]; then
  echo -e "${WHITE} php7.4-FPM     \c" && echo -e "${WHITE}[ ${YELLOW}! ${WHITE}]${cRES}"
else
  echo -e "${WHITE} php7.4-FPM     \c" && echo -e "${WHITE}[ ${RED}✕ ${WHITE}]${cRES}"
fi

if [[ -n $(crontab -l 2>&1 | grep "autoUpdate") ]] && [[ -f "/opt/de_GWD/autoUpdate" ]]; then
  echo -e "${WHITE} AutoUpdate     \c" && echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]${cRES}"
else
  echo -e "${WHITE} AutoUpdate     \c" && echo -e "${WHITE}[ ${WHITE}- ${WHITE}]${cRES}"
fi

echo -e "${WHITE}---------------------- ${cRES}"

if [[ $(du -sk /opt/de_GWD/mosdns/geosite.dat 2>/dev/null | awk '{print$1}') -gt 4400 ]]; then
  echo -e "${WHITE} GeoSite        \c" && echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]${cRES}"
else
  echo -e "${WHITE} GeoSite        \c" && echo -e "${WHITE}[ ${RED}✕ ${WHITE}]${cRES}"
fi

if [[ $(du -sk /opt/de_GWD/vtrui/geoip.dat 2>/dev/null | awk '{print$1}') -ge 8000 ]]; then
  echo -e "${WHITE} GeoIP          \c" && echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]${cRES}"
else
  echo -e "${WHITE} GeoIP          \c" && echo -e "${WHITE}[ ${RED}✕ ${WHITE}]${cRES}"
fi

if [[ $(du -sk /opt/de_GWD/nftables/IP_CHNROUTE 2>/dev/null | awk '{print$1}') -gt 100 ]]; then
  echo -e "${WHITE} ChnrouteIP     \c" && echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]${cRES}"
else
  echo -e "${WHITE} ChnrouteIP     \c" && echo -e "${WHITE}[ ${RED}✕ ${WHITE}]${cRES}"
fi
 echo
 echo -e "${BLUE}---------------------------------------------------------------- ${cRES}"
 echo -e "${BLUE}Debian Version:                 $(cat /etc/os-release | grep VERSION= | cut -d'(' -f2 | cut -d')' -f1) ${cRES}"
 echo -e "${BLUE}Kernel:                         $(uname -r) ${cRES}"
 echo -e "${BLUE}Current tcp congestion control: $(sysctl net.ipv4.tcp_congestion_control 2>/dev/null | cut -d' ' -f3) + $(sysctl net.core.default_qdisc 2>/dev/null | cut -d' ' -f3) ${cRES}"
 echo -e "${BLUE}---------------------------------------------------------------- ${cRES}"

 echo -e "${GREEN}============CLIENT============================================== ${cRES}"
 echo -e "${GREEN}       __         _______       ______  ${cRES}"
 echo -e "${GREEN}  ____/ /__      / ____/ |     / / __ \ ${cRES}"
 echo -e "${GREEN} / __  / _ \    / / __ | | /| / / / / / ${cRES}"
 echo -e "${GREEN}/ /_/ /  __/   / /_/ / | |/ |/ / /_/ /  ${cRES}"
 echo -e "${GREEN}\__,_/\___/____\____/  |__/|__/_____/   ${cRES}"
 echo -e "${GREEN}         /_____/                        ${cRES}"
 echo
 echo -e "${GREEN}Require: Debian (amd64 && arm64) ${cRES}"
 echo -e "${GREEN}Author:  JacyL4${cRES}"
 echo -e "${GREEN}================================================================ ${cRES}"
 echo
 echo -e "${GREEN}1. Install de_GWD${cRES}"
 echo -e "${GREEN}2. Install BBRplus / Liquorix / XanMod kernel and reboot${cRES}"
  echo -e "${BLUE}3. Restore default kernel and reboot${cRES}"
echo -e "${YELLOW}8. Change Web UI port & Web update port${cRES}"
echo -e "${YELLOW}9. Change de_GWD password${cRES}"
echo -e "${YELLOW}0. Update de_GWD${cRES}"
echo -e "${RED}CTRL+C EXIT${cRES}"
echo ""
read -p "Select:" num
    case "$num" in
    1)
    installGWD
    start_menu
    ;;
    2)
    install3rdKernel
    start_menu
    ;;
    3)
    restoreKernel
    start_menu
    ;;
    8)
    changeWP
    start_menu
    ;;
    9)
    changePWD
    start_menu
    ;;
    0)
    updateGWD
    start_menu
    ;;
    *)
    clear
    echo -e "${RED}Wrong number${cRES}"
    sleep 1s
    start_menu
    ;;
    esac
}

start_menu