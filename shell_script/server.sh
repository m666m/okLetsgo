#!/bin/bash
# https://github.com/jacyl4/de_GWD/raw/main/server
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
virt_detect=$(systemd-detect-virt)
[[ -n $(echo "openvz lxc lxc-libvirt systemd-nspawn docker podman rkt wsl proot pouch" | grep $virt_detect) ]] && virt_type="container"
export DEBIAN_FRONTEND=noninteractive
piholeCoreRelease_reserved="v5.9"
piholeFTLRelease_reserved="v5.14"
branch="main"



pkgDEP(){
unset aptPKG
[[ -z $(dpkg -l | awk '{print$2}' | grep '^sudo$') ]] && aptPKG+=(sudo)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^wget$') ]] && aptPKG+=(wget)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^curl$') ]] && aptPKG+=(curl)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^git$') ]] && aptPKG+=(git)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^locales$') ]] && aptPKG+=(locales)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^psmisc$') ]] && aptPKG+=(psmisc)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^idn2$') ]] && aptPKG+=(idn2)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^dns-root-data$') ]] && aptPKG+=(dns-root-data)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^netcat$') ]] && aptPKG+=(netcat)
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
[[ -z $(dpkg -l | awk '{print$2}' | grep '^socat$') ]] && aptPKG+=(socat)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^screen$') ]] && aptPKG+=(screen)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^ethtool$') ]] && aptPKG+=(ethtool)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^qrencode$') ]] && aptPKG+=(qrencode)
[[ -z $(dpkg -l | awk '{print$2}' | grep '^sqlite3$') ]] && aptPKG+=(sqlite3)
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



repoDL(){
echo -e "${WHITE}[...]\c" && echo -e "\t${WHITE}Repository${cRES}\r\c"
sha256sum_de_GWD=$(curl -sSLo- https://raw.githubusercontent.com/jacyl4/de_GWD/$branch/de_GWD_"$architecture".zip.sha256sum)
sha256sum_don_server=$(curl -sSLo- https://raw.githubusercontent.com/jacyl4/de_GWD/$branch/resource/doh/doh_s_"$architecture".sha256sum)
sha256sum_nginx=$(curl -sSLo- https://raw.githubusercontent.com/jacyl4/de_GWD/$branch/resource/nginx/nginx_"$architecture".sha256sum)
sha256sum_nginxConf=$(curl -sSLo- https://raw.githubusercontent.com/jacyl4/de_GWD/$branch/resource/nginx/nginxConf.zip.sha256sum)
sha256sum_sample=$(curl -sSLo- https://raw.githubusercontent.com/jacyl4/de_GWD/$branch/resource/sample.zip.sha256sum)

if [[ $(checkSum /opt/de_GWD/doh-server $sha256sum_don_server) = "false" ]]; then
rm -rf /tmp/doh-server
wget --show-progress -cqO /tmp/doh-server https://raw.githubusercontent.com/jacyl4/de_GWD/$branch/resource/doh/doh_s_$architecture
[[ $(checkSum /tmp/doh-server $sha256sum_don_server) = "false" ]] && echo -e "${RED}Download Failed${cRES}" && exit
[[ $(checkSum /tmp/doh-server $sha256sum_don_server) = "true" ]] && mv -f /tmp/doh-server /opt/de_GWD/doh-server && chmod +x /opt/de_GWD/doh-server
fi

if [[ $(checkSum /usr/sbin/nginx $sha256sum_nginx) = "false" ]]; then
rm -rf /tmp/nginx
wget --show-progress -cqO /tmp/nginx https://raw.githubusercontent.com/jacyl4/de_GWD/$branch/resource/nginx/nginx_"$architecture"
[[ $(checkSum /tmp/nginx $sha256sum_nginx) = "false" ]] && echo -e "${RED}Download Failed${cRES}" && exit
[[ $(checkSum /tmp/nginx $sha256sum_nginx) = "true" ]] && mv -f /tmp/nginx /usr/sbin/nginx && chmod +x /usr/sbin/nginx
fi

if [[ $(checkSum /opt/de_GWD/.repo/de_GWD.zip $sha256sum_de_GWD) = "false" ]]; then
rm -rf /tmp/de_GWD.zip
wget --show-progress -cqO /tmp/de_GWD.zip https://raw.githubusercontent.com/jacyl4/de_GWD/$branch/de_GWD_"$architecture".zip
[[ $(checkSum /tmp/de_GWD.zip $sha256sum_de_GWD) = "false" ]] && echo -e "${RED}Download Failed${cRES}" && exit
[[ $(checkSum /tmp/de_GWD.zip $sha256sum_de_GWD) = "true" ]] && mv -f /tmp/de_GWD.zip /opt/de_GWD/.repo/de_GWD.zip
fi

if [[ $(checkSum /opt/de_GWD/.repo/nginxConf.zip $sha256sum_nginxConf) = "false" ]]; then
rm -rf /tmp/nginxConf.zip
wget --show-progress -cqO /tmp/nginxConf.zip https://raw.githubusercontent.com/jacyl4/de_GWD/$branch/resource/nginx/nginxConf.zip
[[ $(checkSum /tmp/nginxConf.zip $sha256sum_nginxConf) = "false" ]] && echo -e "${RED}Download Failed${cRES}" && exit
[[ $(checkSum /tmp/nginxConf.zip $sha256sum_nginxConf) = "true" ]] && mv -f /tmp/nginxConf.zip /opt/de_GWD/.repo/nginxConf.zip
fi

if [[ $(checkSum /opt/de_GWD/.repo/sample.zip $sha256sum_sample) = "false" ]]; then
rm -rf /tmp/sample.zip
wget --show-progress -cqO /tmp/sample.zip https://raw.githubusercontent.com/jacyl4/de_GWD/$branch/resource/sample.zip
[[ $(checkSum /tmp/sample.zip $sha256sum_sample) = "false" ]] && echo -e "${RED}Download Failed${cRES}" && exit
[[ $(checkSum /tmp/sample.zip $sha256sum_sample) = "true" ]] && mv -f /tmp/sample.zip /opt/de_GWD/.repo/sample.zip
fi

localVer=$(awk 'NR==1' /opt/de_GWD/version.php 2>/dev/null)
remoteVer=$(curl -sSLo- https://raw.githubusercontent.com/jacyl4/de_GWD/main/version.php | head -n 1)

if [[ $localVer != $remoteVer ]]; then
rm -rf /tmp/version.php
wget --show-progress -cqO /tmp/version.php https://raw.githubusercontent.com/jacyl4/de_GWD/main/version.php
[[ $? -ne 0 ]] && echo -e "${WHITE}Version File${RED} Download Failed${cRES}" && exit
[[ $(du -sk /tmp/version.php 2>/dev/null | awk '{print$1}') -ge 4 ]] && mv -f /tmp/version.php /opt/de_GWD/version.php
fi

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}Repository${cRES}"
}



preUpdate(){
if [[ -d "/opt/AdGuardHome" ]]; then
  systemctl stop AdGuardHome >/dev/null 2>&1
  rm -rf /etc/systemd/system/AdGuardHome.service
  rm -rf /lib/systemd/system/AdGuardHome.service
  rm -rf /opt/AdGuardHome
  rm -rf /usr/bin/yq
fi

if [[ -f "/lib/systemd/system/frps.service" ]] || [[ -f "/lib/systemd/system/frpc.service" ]]; then
  systemctl disable frps >/dev/null 2>&1
  systemctl disable frpc >/dev/null 2>&1
  systemctl stop frps >/dev/null 2>&1
  systemctl stop frpc >/dev/null 2>&1
  rm -rf /etc/systemd/system/frps.service >/dev/null 2>&1
  rm -rf /lib/systemd/system/frps.service >/dev/null 2>&1
  rm -rf /etc/systemd/system/frpc.service >/dev/null 2>&1
  rm -rf /lib/systemd/system/frpc.service >/dev/null 2>&1
  systemctl daemon-reload >/dev/null
  rm -rf /opt/de_GWD/frps
  rm -rf /opt/de_GWD/frpc
fi

if [[  -f "/opt/de_GWD/iptablesrules-up" ]]; then
  systemctl disable iptablesrules >/dev/null 2>&1
  systemctl stop iptablesrules >/dev/null 2>&1
  rm -rf /etc/systemd/system/iptablesrules.service >/dev/null 2>&1
  rm -rf /lib/systemd/system/iptablesrules.service >/dev/null 2>&1
  systemctl daemon-reload >/dev/null
  rm -rf /opt/de_GWD/iptablesrules-down
  rm -rf /opt/de_GWD/iptablesrules-up
  rm -rf /opt/de_GWD/Q4amSun
fi

[[ ! -f "/var/www/ssl/de_GWD.cer" ]] && mv -f /var/www/ssl/*.cer /var/www/ssl/de_GWD.cer && sed -i '/ssl_certificate /c\ssl_certificate \/var\/www\/ssl\/de_GWD.cer;' /etc/nginx/conf.d/default.conf
[[ ! -f "/var/www/ssl/de_GWD.key" ]] && mv -f /var/www/ssl/*.key /var/www/ssl/de_GWD.key && sed -i '/ssl_certificate_key /c\ssl_certificate_key \/var\/www\/ssl\/de_GWD.key;' /etc/nginx/conf.d/default.conf

[[ -f "/etc/nginx/conf.d/merge.sh" ]] && rm -rf /etc/nginx/conf.d/*

[[ -n $(dpkg -l | awk '{print$2}' | grep '^ipset$') ]] && apt remove --purge ipset
[[ -n $(dpkg -l | awk '{print$2}' | grep '^haveged$') ]] && apt remove --purge haveged

[[ -f "/var/log/pihole-FTL.log" ]] && >/var/log/pihole-FTL.log
[[ -f "/var/log/pihole.log" ]] && >/var/log/pihole.log
rm -rf /var/log/auth.log
rm -rf /opt/de_GWD/.repo/vtrui.zip
rm -rf /opt/de_GWD/.repo/IPchnroute
rm -rf /usr/local/bin/autoUpdate
rm -rf /usr/local/bin/iptablesrules*
rm -rf /usr/local/bin/Q2H
rm -rf /usr/local/bin/version.php
rm -rf /usr/local/bin/vtrui
rm -rf /usr/bin/yq
rm -rf /etc/dns-over-https
rm -rf /etc/nginx/conf.d/0_serverUpstream
rm -rf /etc/nginx/conf.d/4_v2Proxy
rm -rf /dev/shm/de_GWD.socket*



service cron stop

ethernetnum=$(ip --oneline link show up | grep -v "lo" | awk '{print$2;exit}' | cut -d':' -f1 | cut -d'@' -f1)
localaddr=$(ip route | grep "$ethernetnum" | awk NR==2 | grep -Po '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | awk NR==2)

domain=$(awk '/server_name/ {print$2;exit}' /etc/nginx/conf.d/default.conf | sed 's/.$//')
topDomain=$(echo $domain | rev | awk -F. '{print $1"."$2}' | rev)
port=$(awk '/ssl http2 fastopen=128 reuseport/ {print$2}' /etc/nginx/conf.d/default.conf | grep '^[[:digit:]]*$')
[[ -z $port ]] && port="443"

path=$(jq -r '.inbounds[0].streamSettings.wsSettings.path' /opt/de_GWD/vtrui/config.json 2>/dev/null | grep -v '^null$')
uuids=$(jq -r '.inbounds[0].settings.clients[].id' /opt/de_GWD/vtrui/config.json 2>/dev/null | grep -v '^null$')

upDomain=$(jq -r '.outbounds[0].settings.vnext[0].address' /opt/de_GWD/vtrui/config.json 2>/dev/null | grep -v '^null$')
upPort=$(jq -r '.outbounds[0].settings.vnext[0].port' /opt/de_GWD/vtrui/config.json 2>/dev/null | grep -v '^null$')
upUUID=$(jq -r '.outbounds[0].settings.vnext[0].users[0].id' /opt/de_GWD/vtrui/config.json 2>/dev/null | grep -v '^null$')
xtlsPort=$(jq -r '.inbounds[] | select(.tag == "forward") | .port' /opt/de_GWD/vtrui/config.json 2>/dev/null | grep -v '^null$')
}



preInstall(){
sync; echo 3 >/proc/sys/vm/drop_caches >/dev/null 2>&1

if [[ -n "$(ps -e | grep 'pihole-FTL' )" ]]; then
cat << EOF >/etc/dnsmasq.conf
conf-dir=/etc/dnsmasq.d
listen-address=127.0.0.1
port=0
EOF
pihole restartdns
fi

rm -rf /etc/resolv.conf
cat << EOF >/etc/resolv.conf
nameserver 1.1.1.1
nameserver 8.8.8.8
EOF

if [[ $(free -m | awk 'NR==3{print$2}') = "0" ]] && [[ $virt_type != "container" ]]; then
fallocate -l 1G /swapfile
dd if=/dev/zero of=/swapfile bs=1k count=1024k status=progress
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
sed -i "/swapfile/d" /etc/fstab
echo "/swapfile swap swap defaults 0 0" >>/etc/fstab
echo "RESUME=" >/etc/initramfs-tools/conf.d/resume
fi

mkdir -p /opt/de_GWD
mkdir -p /opt/de_GWD/.repo
cat << "EOF" >/opt/de_GWD/tcpTime
date -s "$(wget -qSO- --max-redirect=0 whatismyip.akamai.com 2>&1 | grep Date: | cut -d' ' -f5-8)Z"
[[ $? -ne "0" ]]&& date -s "$(curl -sI cloudflare.com| grep -i '^date:'|cut -d' ' -f2-)"
hwclock -w
EOF
chmod +x /opt/de_GWD/tcpTime
[[ $virt_type != "container" ]] && /opt/de_GWD/tcpTime

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
cat >>'/etc/systemd/system.conf' <<EOF
DefaultLimitCORE=infinity
DefaultLimitNOFILE=infinity
DefaultLimitNPROC=infinity
EOF
systemctl daemon-reload

dpkg --configure -a

cat << EOF >/etc/apt/sources.list
deb http://cloudfront.debian.net/debian bullseye main contrib non-free
deb http://cloudfront.debian.net/debian bullseye-updates main contrib non-free
deb http://cloudfront.debian.net/debian bullseye-backports main contrib non-free
deb http://cloudfront.debian.net/debian-security bullseye-security main contrib non-free
EOF

apt update --fix-missing && apt upgrade --allow-downgrades -y
apt full-upgrade -y && apt autoremove --purge -y && apt clean -y && apt autoclean -y

pkgDEP

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

cat << EOF >/etc/ld.so.preload
/usr/lib/$(uname -m)-linux-gnu/libjemalloc.so
EOF
ldconfig

DPKGclean=$(dpkg --list | grep "^rc" | cut -d " " -f 3)
[[ -n $DPKGclean ]] && echo $DPKGclean | xargs sudo dpkg --purge

rm -rf /var/log/journal/*
systemctl restart systemd-journald

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

if [[ $virt_type != "container" ]]; then
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
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
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
net.ipv4.tcp_tw_reuse = 2
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
fi

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
}



piholeConf(){
rm -rf /etc/pihole/setupVars*
cat << EOF >/etc/pihole/setupVars.conf
PIHOLE_INTERFACE=$ethernetnum
WEBPASSWORD=0000000000000000000000000000000000000000000000000000000000000000
IPV4_ADDRESS=$localaddr/24
PIHOLE_DNS_1=1.1.1.1
PIHOLE_DNS_2=1.0.0.1
PIHOLE_DNS_3=8.8.8.8
PIHOLE_DNS_4=8.8.4.4
PIHOLE_DNS_5=9.9.9.9
PIHOLE_DNS_6=208.67.222.222
QUERY_LOGGING=true
INSTALL_WEB_SERVER=false
INSTALL_WEB_INTERFACE=false
LIGHTTPD_ENABLED=false
CACHE_SIZE=10000
DNS_FQDN_REQUIRED=true
DNS_BOGUS_PRIV=true
DNSSEC=false
REV_SERVER=false
DNSMASQ_LISTENING=local
BLOCKING_ENABLED=true
EOF
}



installPihole(){
rm -rf /etc/resolv.conf
cat << EOF >/etc/resolv.conf
nameserver 1.1.1.1
nameserver 8.8.8.8
EOF

piholeCoreRelease=$(curl -sSL "https://api.github.com/repos/pi-hole/pi-hole/releases/latest" | jq -r '.tag_name' | grep -v '^null$')
piholeFTLRelease=$(curl -sSL "https://api.github.com/repos/pi-hole/FTL/releases/latest" | jq -r '.tag_name' | grep -v '^null$')

[[ -z $piholeCoreRelease ]] && piholeCoreRelease=$piholeCoreRelease_reserved
[[ -z $piholeFTLRelease ]] && piholeFTLRelease=$piholeFTLRelease_reserved

piholeCoreVer=$(awk '{print$1}' /etc/pihole/localversions 2>/dev/null | grep -Po "^v(\d+\.)+\d+")
piholeFTLVer=$(awk '{print$2}' /etc/pihole/localversions 2>/dev/null | grep -Po "^v(\d+\.)+\d+")

[[ $piholeCoreVer = $piholeCoreRelease ]] && [[ $piholeFTLVer = $piholeFTLRelease ]] && [[ $(systemctl is-active 'pihole-FTL') = "active" ]] && return

export PIHOLE_SKIP_OS_CHECK=true
rm -rf /etc/.pihole /etc/pihole /opt/pihole /usr/bin/pihole-FTL /usr/local/bin/pihole /var/www/html/pihole /var/www/html/admin /var/log/pihole* /etc/dnsmasq.d/*
systemctl unmask --now dhcpcd >/dev/null 2>&1

mkdir -p /etc/.pihole
mkdir -p /etc/pihole
>/etc/pihole/adlists.list

piholeConf

git clone https://github.com/pi-hole/pi-hole /etc/.pihole
curl -sSL https://install.pi-hole.net | bash /dev/stdin --unattended
}



piholeSet(){
systemctl disable --now lighttpd >/dev/null 2>&1
systemctl disable --now dhcpcd >/dev/null 2>&1
systemctl mask --now lighttpd >/dev/null 2>&1
systemctl mask --now dhcpcd >/dev/null 2>&1
systemctl daemon-reload >/dev/null

update-rc.d -f dhcpd remove >/dev/null 2>&1

cat << EOF >/etc/hosts
127.0.0.1       localhost
$localaddr      $(hostname).local       $(hostname)

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

piholeConf

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
PIHOLE_PTR=NONE
DELAY_STARTUP=0
NICE=-10
MAXNETAGE=14
NAMES_FROM_NETDB=true
REFRESH_HOSTNAMES=IPV4
PARSE_ARP_CACHE=true
CHECK_LOAD=false

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

rm -rf /etc/dnsmasq.conf.old
cat << EOF >/etc/dnsmasq.conf
conf-dir=/etc/dnsmasq.d
listen-address=127.0.0.1
port=53
EOF

cat << EOF >/etc/dnsmasq.d/01-pihole.conf
addn-hosts=/etc/pihole/local.list
addn-hosts=/etc/pihole/custom.list

localise-queries
no-resolv

cache-size=10000

log-queries
log-facility=/dev/null

log-async
domain-needed
expand-hosts
bogus-priv
local-service
EOF
awk '/PIHOLE_DNS_/' /etc/pihole/setupVars.conf | cut -d = -f 2 | sed 's/^/server=/g' >>/etc/dnsmasq.d/01-pihole.conf

cat << EOF >/etc/dnsmasq.d/99-extra.conf
dns-forward-max=10000
edns-packet-max=1280
all-servers
EOF

systemctl stop pihole-FTL
rm -rf rm /etc/pihole/pihole-FTL.db
pihole restartdns

/opt/pihole/updatecheck.sh

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
}



installNftables(){
mkdir -p /opt/de_GWD/nftables
cat << EOF >/opt/de_GWD/nftables/default.nft
#!/usr/sbin/nft -f
table inet filter {
        chain input {
                type filter hook input priority -310;
                iifname lo accept
                ct state established,related accept
                tcp flags != syn ct state new drop
                tcp flags & (fin|syn) == (fin|syn) drop
                tcp flags & (syn|rst) == (syn|rst) drop
                tcp flags & (fin|syn|rst|psh|ack|urg) < (fin) drop
                tcp flags & (fin|syn|rst|psh|ack|urg) == (fin|psh|urg) drop
                ct state invalid counter drop
                # Drop 53 in
                meta l4proto { tcp, udp } th dport 53 drop
                meta l4proto { tcp, udp } th dport 4711 drop
        }
        chain forward {
                type filter hook forward priority -309;
                tcp flags & (syn|rst) == syn counter tcp option maxseg size set rt mtu
                # Docker traffic
                counter jump DOCKER-USER
                counter jump DOCKER-ISOLATION-STAGE-1
                oifname docker0 ct state established,related counter accept
                oifname docker0 counter jump DOCKER
                iifname docker0 oifname != docker0 counter accept
                iifname docker0 oifname docker0 counter accept
        }
        chain output {
                type filter hook output priority -308;
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
ExecStart=/usr/sbin/nft -f /opt/de_GWD/nftables/default.nft
ExecStop=/usr/sbin/nft flush ruleset
RemainAfterExit=yes

[Install]
WantedBy=sysinit.target
EOF
systemctl daemon-reload >/dev/null
systemctl enable nftables >/dev/null 2>&1
systemctl restart nftables
}



installDOH(){
echo -e "${WHITE}[...]\c" && echo -e "\t${WHITE}Install DoH Serve${cRES}\r\c"
cat << EOF >/opt/de_GWD/doh-server.conf
listen = [ "127.0.0.1:8053" ]
path = "/dq"
upstream = [
	"udp:127.0.0.1:53",
	"tcp:127.0.0.1:53"
]
timeout = 10
tries = 3
verbose = false
log_guessed_client_ip = false
ecs_allow_non_global_ip = true
ecs_use_precise_ip = false
EOF

mkdir -p /etc/NetworkManager/dispatcher.d
cat << "EOF" > /etc/NetworkManager/dispatcher.d/doh-server
#!/bin/bash
case "$2" in
    up)
        /usr/bin/systemctl is-active doh-server.service >/dev/null && /usr/bin/systemctl restart doh-server.service
        ;;
    down)
        /usr/bin/systemctl is-active doh-server.service >/dev/null && /usr/bin/systemctl restart doh-server.service
        ;;
    *)
        exit 0
        ;;
esac
EOF
chmod +x /etc/NetworkManager/dispatcher.d/doh-server

rm -rf /lib/systemd/system/doh-server.service
cat << "EOF" >/etc/systemd/system/doh-server.service
[Unit]
Description=DNS-over-HTTPS server
After=network.target

[Service]
User=root
Type=simple
ExecStart=/opt/de_GWD/doh-server -conf /opt/de_GWD/doh-server.conf
Restart=always
RestartSec=2
TimeoutStopSec=5

Nice=-8
CapabilityBoundingSet=CAP_NET_RAW CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_RAW CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload >/dev/null
systemctl enable doh-server >/dev/null 2>&1

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}Install DoH Serve${cRES}"
}



installXray(){
echo -e "${WHITE}[...]\c" && echo -e "\t${WHITE}Install Xray${cRES}\r\c"
mkdir -p /opt/de_GWD/vtrui

if [[ -n $(unzip -tq /opt/de_GWD/.repo/de_GWD.zip | grep "No errors detected in compressed data") ]]; then
rm -rf /tmp/de_GWD
unzip /opt/de_GWD/.repo/de_GWD.zip -d /tmp/de_GWD >/dev/null 2>&1
mv -f /tmp/de_GWD/xray /opt/de_GWD/vtrui/vtrui
mv -f /tmp/de_GWD/private.dat /opt/de_GWD/vtrui/private.dat
chmod +x /opt/de_GWD/vtrui/vtrui
rm -rf /tmp/de_GWD*
else
rm -rf /opt/de_GWD/.repo/de_GWD.zip
echo -e "${WHITE}de_GWD Zip${RED} Download Failed${cRES}" && exit
fi

rm -rf /lib/systemd/system/vtrui.service
cat << EOF >/etc/systemd/system/vtrui.service
[Unit]
Description=vtrui
After=network.target nss-lookup.target

[Service]
User=www-data
Type=simple
ExecStartPre=$(which rm) -rf /dev/shm/de_GWD.socket*
ExecStart=/opt/de_GWD/vtrui/vtrui -c /opt/de_GWD/vtrui/config.json
ExecStopPost=$(which rm) -rf /dev/shm/de_GWD.socket*
Restart=always
RestartSec=2
TimeoutStopSec=5

CapabilityBoundingSet=CAP_NET_RAW CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_RAW CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload >/dev/null

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}Install Xray${cRES}"
}



installNginx(){
echo -e "${WHITE}[...]\c" && echo -e "\t${WHITE}Install NGINX${cRES}\r\c"
mkdir -p "/etc/nginx"
mkdir -p "/etc/nginx/conf.d"
mkdir -p "/var/www/html"
mkdir -p "/var/www/ssl"
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
Nice=-9

[Install]
WantedBy=multi-user.target
EOF
mkdir -p "/etc/systemd/system/nginx.service.d"
printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" >/etc/systemd/system/nginx.service.d/override.conf

if [[ $virt_type = "container" ]]; then
sed -i '/Nice=/d' /etc/systemd/system/nginx.service
fi
systemctl daemon-reload >/dev/null

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}Install NGINX${cRES}"
}



makeSSL_D(){
crontab -l 2>/dev/null >/tmp/now.cron
sed -i '/acme.sh/d' /tmp/now.cron
crontab /tmp/now.cron
rm -rf /tmp/now.cron
rm -rf "/root/.acme.sh"

export CF_Key="$CFapikey"
export CF_Email="$CFemail"

if [[ $(systemctl is-active 'nginx') != "active" ]]; then
  systemctl restart nginx
  if [[ $? -ne 0 ]]; then
  sed -i '/Nice=/d' /etc/systemd/system/nginx.service
  systemctl daemon-reload >/dev/null
  systemctl restart nginx
  fi
else
systemctl force-reload nginx
fi

rm -rf /var/www/ssl/*.cer
rm -rf /var/www/ssl/*.key
if [[ -f "/var/www/ssl/bundle.pem" ]]; then
  ls /var/www/ssl/*.pem | xargs -n 1 | grep -v "dhparam.pem" | while read line; do
  rm -rf $line
  done
fi

[[ ! -f "/var/www/ssl/dhparam.pem" ]] && openssl dhparam -out /var/www/ssl/dhparam.pem 2048

curl https://get.acme.sh | sh
"/root/.acme.sh"/acme.sh --upgrade  --auto-upgrade
"/root/.acme.sh"/acme.sh --set-default-ca  --server letsencrypt
"/root/.acme.sh"/acme.sh --issue --dns dns_cf -d $topDomain -d *.$topDomain -k ec-256
"/root/.acme.sh"/acme.sh --installcert -d $topDomain \
               --key-file       /var/www/ssl/de_GWD.key  \
               --fullchain-file /var/www/ssl/de_GWD.cer \
               --reloadcmd     "systemctl force-reload nginx" \
               --ecc

chmod 644 /var/www/ssl/*.key
}



makeSSL_W(){
crontab -l 2>/dev/null >/tmp/now.cron
sed -i '/acme.sh/d' /tmp/now.cron
crontab /tmp/now.cron
rm -rf /tmp/now.cron
rm -rf "/root/.acme.sh"

rm -rf /etc/nginx/conf.d/80.conf
rm -rf /etc/nginx/conf.d/default.conf
cat << EOF >/etc/nginx/conf.d/default.conf
# SERVER_BASE_START
server {
    listen      80;
    server_name $domain;
    root        /var/www/html;
    index       index.php index.html index.htm;
# SERVER_BASE_END
}
EOF

if [[ $(systemctl is-active 'nginx') != "active" ]]; then
  systemctl restart nginx
  if [[ $? -ne 0 ]]; then
  sed -i '/Nice=/d' /etc/systemd/system/nginx.service
  systemctl daemon-reload >/dev/null
  systemctl restart nginx
  fi
else
systemctl force-reload nginx
fi

rm -rf /var/www/ssl/*.cer
rm -rf /var/www/ssl/*.key
if [[ -f "/var/www/ssl/bundle.pem" ]]; then
  ls /var/www/ssl/*.pem | xargs -n 1 | grep -v "dhparam.pem" | while read line; do
  rm -rf $line
  done
fi

[[ ! -f "/var/www/ssl/dhparam.pem" ]] && openssl dhparam -out /var/www/ssl/dhparam.pem 2048

curl https://get.acme.sh | sh
"/root/.acme.sh"/acme.sh --upgrade  --auto-upgrade
"/root/.acme.sh"/acme.sh --set-default-ca  --server letsencrypt
"/root/.acme.sh"/acme.sh --issue -d $domain -w /var/www/html -k ec-256
"/root/.acme.sh"/acme.sh --installcert -d $domain \
               --key-file       /var/www/ssl/de_GWD.key  \
               --fullchain-file /var/www/ssl/de_GWD.cer \
               --reloadcmd     "systemctl force-reload nginx" \
               --ecc

chmod 644 /var/www/ssl/*.key
}


ocspStapling(){
cat << "EOF" >/var/www/ssl/update_ocsp_cache
#!/bin/bash
if [[ -n $(openssl x509 -enddate -noout -in /var/www/ssl/de_GWD.cer -checkend 86400 | grep ' not ') ]]; then
[[ ! -f "/var/www/ssl/intermediate.pem" ]] && wget --show-progress -cqO /var/www/ssl/intermediate.pem https://letsencrypt.org/certs/lets-encrypt-r3-cross-signed.pem
[[ ! -f "/var/www/ssl/root.pem" ]] && wget --show-progress -cqO /var/www/ssl/root.pem https://letsencrypt.org/certs/isrgrootx1.pem

[[ ! -f "/var/www/ssl/bundle.pem" ]] && cat /var/www/ssl/intermediate.pem >/var/www/ssl/bundle.pem && cat /var/www/ssl/root.pem >>/var/www/ssl/bundle.pem

openssl ocsp -no_nonce \
    -issuer  /var/www/ssl/intermediate.pem \
    -cert    /var/www/ssl/*.cer \
    -CAfile  /var/www/ssl/bundle.pem \
    -VAfile  /var/www/ssl/bundle.pem \
    -url     http://r3.o.lencr.org \
    -respout /var/www/ssl/ocsp.resp

chmod 644 /var/www/ssl/*.key
systemctl force-reload nginx >/dev/null
fi
EOF

chmod +x /var/www/ssl/update_ocsp_cache
/var/www/ssl/update_ocsp_cache
}



nginxWebConf(){
if [[ $port = "443" ]]; then
cat << EOF >/etc/nginx/conf.d/80.conf
server {
  listen 80;
  server_name $domain;
  return 301 https://\$server_name\$request_uri;
}
EOF
else
rm -rf /etc/nginx/conf.d/80.conf
fi

touch /etc/nginx/conf.d/default.conf
sed -i '/SERVER_BASE_START/,/SERVER_BASE_END/d' /etc/nginx/conf.d/default.conf
sed -i '/DOH_START/,/DOH_END/d' /etc/nginx/conf.d/default.conf
sed -i '/V2_START/,/V2_END/d' /etc/nginx/conf.d/default.conf
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
  listen $port ssl http2 fastopen=128 reuseport;
  server_name $domain;
  root /var/www/html;
  index index.php index.html index.htm;

  ssl_certificate /var/www/ssl/de_GWD.cer;
  ssl_certificate_key /var/www/ssl/de_GWD.key;
  ssl_dhparam /var/www/ssl/dhparam.pem;
  ssl_protocols TLSv1.2 TLSv1.3;
  ssl_ecdh_curve CECPQ2:X25519:P-256;
  ssl_prefer_server_ciphers off;
  ssl_ciphers [ECDHE-ECDSA-AES128-GCM-SHA256|ECDHE-ECDSA-CHACHA20-POLY1305]:[ECDHE-RSA-AES128-GCM-SHA256|ECDHE-RSA-CHACHA20-POLY1305]:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256;
  ssl_session_timeout 10m;
  ssl_session_cache builtin:1000 shared:SSL:10m;
  ssl_buffer_size 4k;

  ssl_early_data on;
  proxy_set_header Early-Data \$ssl_early_data;

  ssl_stapling on;
  ssl_stapling_verify on;
  ssl_stapling_file /var/www/ssl/ocsp.resp;

  add_header Referrer-Policy                    "no-referrer"       always;
  add_header X-Content-Type-Options             "nosniff"           always;
  add_header X-Download-Options                 "noopen"            always;
  add_header X-Frame-Options                    "SAMEORIGIN"        always;
  add_header X-Permitted-Cross-Domain-Policies  "none"              always;
  add_header X-Robots-Tag                       "none"              always;
  add_header X-XSS-Protection                   "1; mode=block"     always;
  add_header Strict-Transport-Security          "max-age=63072000"  always;
# SERVER_BASE_END

# DOH_START
location /dq {
  proxy_pass                  http://127.0.0.1:8053/dq;
  proxy_set_header            Host \$host;
  proxy_set_header            X-Real-IP \$remote_addr;
}
# DOH_END

# V2_START
location $path {
  if (\$http_upgrade != "websocket") { return 404; }
  proxy_pass                  http://unix:/dev/shm/de_GWD.socket;
  proxy_http_version          1.1;
  proxy_set_header            Host \$http_host;
  proxy_set_header            Upgrade \$http_upgrade;
  proxy_set_header            Connection "upgrade";
  proxy_set_header            X-Real-IP \$remote_addr;
  proxy_set_header            X-Forwarded-For \$proxy_add_x_forwarded_for;
  keepalive_requests          100000;
  keepalive_timeout           600s;
  proxy_connect_timeout       600s;
  proxy_read_timeout          600s;
  proxy_send_timeout          600s;
  proxy_redirect              off;
  proxy_buffering             off;
  proxy_buffer_size           8k;
  add_header                  X-Cache \$upstream_cache_status;
  add_header                  Cache-Control no-cache;
}
# V2_END

$(cat /etc/nginx/conf.d/default.conf 2>/dev/null)
}
EOF
}



xrayInbound(){
cat << EOF >/opt/de_GWD/vtrui/config.json
{
  "dns":{
    "tag":"dnsflow",
    "servers":[{"address":"127.0.0.1","port":53}]
  },
  "routing": {
    "rules": [
      {"type":"field","port":53,"network":"tcp,udp","outboundTag":"direct"},
      {"type":"field","ip":["ext:private.dat:private"],"outboundTag":"direct"},
      {"type":"field","inboundTag":["dnsflow"],"outboundTag":"direct"}
    ]
  },
  "inbounds":[
    {
      "listen":"/dev/shm/de_GWD.socket",
      "protocol":"vless",
      "settings":{
        "decryption":"none",
        "clients":[]
      },
      "streamSettings":{
        "network":"ws",
        "security":"none",
        "wsSettings":{
          "path":"$path"
        }
      }
    }
  ]
}
EOF

for uuid in $uuids; do
uuidStr='{"id": "'$uuid'", "level": 1}'
jq --argjson uuidStr "$uuidStr" '.inbounds[0].settings.clients+=[$uuidStr]' /opt/de_GWD/vtrui/config.json | sponge /opt/de_GWD/vtrui/config.json
done
}

xrayInboundForward(){
chmod 644 /var/www/ssl/*.key
IBup=`cat << EOF
    {
      "tag": "forward",
      "port": $xtlsPort,
      "protocol": "vless",
      "settings":{
        "decryption": "none",
        "clients":[]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "xtls",
        "xtlsSettings": {
          "rejectUnknownSni": true,
          "alpn":["h2","http/1.1"],
          "certificates": [
            {
              "ocspStapling": 3600,
              "oneTimeLoading": false,
              "certificateFile": "/var/www/ssl/de_GWD.cer",
              "keyFile": "/var/www/ssl/de_GWD.key"
            }
          ]
        }
      }
    }
EOF
`

jq 'del(.inbounds[] | select(.tag == "forward"))' /opt/de_GWD/vtrui/config.json |\
jq --argjson IBup "$IBup" '.inbounds+=[$IBup]' | sponge /opt/de_GWD/vtrui/config.json

IFNO=$(jq -r '.inbounds | to_entries[] | select(.value.tag == "forward") | .key' /opt/de_GWD/vtrui/config.json 2>/dev/null | grep -v '^null$')
for uuid in $uuids; do
xuuidStr='{"id": "'$uuid'", "flow": "xtls-rprx-direct", "level": 1}'
jq --argjson IFNO "$IFNO" --argjson xuuidStr "$xuuidStr" '.inbounds[$IFNO].settings.clients+=[$xuuidStr]' /opt/de_GWD/vtrui/config.json | sponge /opt/de_GWD/vtrui/config.json
done
}

xrayOutboundForward(){
OBup=`cat << EOF
    {
      "protocol": "vless",
      "settings": {
        "vnext": [
          {
            "address": "$upDomain",
            "port": $upPort,
            "users": [
              {
                "id": "$upUUID",
                "encryption": "none",
                "flow": "xtls-rprx-direct",
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
          "serverName": "$upDomain",
          "allowInsecure": false
        },
        "sockopt":{
          "domainStrategy":"UseIP"
        }
      }
    }
EOF
`

OBdir=`cat << EOF
    {
      "tag":"direct",
      "protocol":"freedom"
    }
EOF
`

OBblo=`cat << EOF
    {
      "tag":"blocked",
      "protocol":"blackhole",
      "settings":{"response":{"type":"http"}}
    }
EOF
`

jq '.outbounds=[]' /opt/de_GWD/vtrui/config.json |\
jq --argjson OBup "$OBup" '.outbounds+=[$OBup]' |\
jq --argjson OBdir "$OBdir" '.outbounds+=[$OBdir]' |\
jq --argjson OBblo "$OBblo" '.outbounds+=[$OBblo]' | sponge /opt/de_GWD/vtrui/config.json

[[ $virt_type = "container" ]] && jq --arg flow "xtls-rprx-direct" '.outbounds[0].settings.vnext[0].users[0].flow=$flow' /opt/de_GWD/vtrui/config.json | sponge /opt/de_GWD/vtrui/config.json
}

xrayOutboundDirect(){
OBdir=`cat << EOF
    {
      "tag":"direct",
      "protocol":"freedom"
    }
EOF
`

OBblo=`cat << EOF
    {
      "tag":"blocked",
      "protocol":"blackhole",
      "settings":{"response":{"type":"http"}}
    }
EOF
`

jq '.outbounds=[]' /opt/de_GWD/vtrui/config.json |\
jq --argjson OBdir "$OBdir" '.outbounds+=[$OBdir]' |\
jq --argjson OBblo "$OBblo" '.outbounds+=[$OBblo]' | sponge /opt/de_GWD/vtrui/config.json
}



postInstall(){
echo -e "${WHITE}[...]\c" && echo -e "\t${WHITE}Post Install${cRES}\r\c"
if [[ $(ls /var/www/html/* 2>/dev/null | wc -l) -lt 5 ]]; then
if [[ -n $(unzip -tq /opt/de_GWD/.repo/sample.zip | grep "No errors detected in compressed data") ]]; then
rm -rf /tmp/sample
unzip /opt/de_GWD/.repo/sample.zip -d /tmp >/dev/null 2>&1
cp -rf /tmp/sample/* /var/www/html/
rm -rf /tmp/sample
else
rm -rf /opt/de_GWD/.repo/sample.zip
echo -e "${WHITE}Sample Zip${RED} Download Failed${cRES}" && exit
fi
fi

if [[ $(du -sk /var/www/html/spt 2>/dev/null | awk '{print$1}') -lt 102400 ]]; then
  dd if=/dev/zero of=/var/www/html/spt bs=1k count=100k status=progress
fi



cat << "EOF" >/opt/de_GWD/Q2H
#!/bin/bash
virt=$(systemd-detect-virt)
virtCON="openvz lxc lxc-libvirt systemd-nspawn docker podman rkt wsl proot pouch"

[[ $virt_type != "container" ]] && /opt/de_GWD/tcpTime

rm -rf ~/server*
rm -rf ~/wget-log
rm -rf /var/log/*1
rm -rf /var/log/*2
rm -rf /var/log/*gz

>/var/log/pihole.log
>/var/log/pihole-FTL.log
EOF
chmod +x /opt/de_GWD/Q2H
/opt/de_GWD/Q2H


cat << "EOF" >/opt/de_GWD/Qday
#!/bin/bash
if [[ -n $(openssl x509 -enddate -noout -in /var/www/ssl/de_GWD.cer -checkend 259200 | grep "Certificate will expire") ]] && [[ -d "/root/.acme.sh" ]]; then
"/root/.acme.sh"/acme.sh --set-default-ca  --server letsencrypt
"/root/.acme.sh"/acme.sh --cron --force --home "/root/.acme.sh"

sslFolder=$(ls "/root/.acme.sh" | grep '_ecc')
cp -f "/root/.acme.sh"/$sslFolder/fullchain.cer /var/www/ssl/de_GWD.cer
cp -f "/root/.acme.sh"/$sslFolder/*.key /var/www/ssl/de_GWD.key

chmod 644 /var/www/ssl/*.key
fi

/var/www/ssl/update_ocsp_cache
EOF
chmod +x /opt/de_GWD/Qday


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
sed -i '/\/opt\/de_GWD\/Qprobe/d' /tmp/now.cron
sed -i '/\/opt\/de_GWD\/Q2H/d' /tmp/now.cron
sed -i '/\/opt\/de_GWD\/Qday/d' /tmp/now.cron
sed -i '/\/opt\/de_GWD\/Q4amSun/d' /tmp/now.cron
cat << EOF >>/tmp/now.cron
0 */2 * * * /opt/de_GWD/Q2H
0 0 * * * /opt/de_GWD/Qday
EOF
crontab /tmp/now.cron
rm -rf /tmp/now.cron
service cron restart

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}Post Install${cRES}"

cat << "EOF" >/tmp/comRestart
#!/bin/bash
virt=$(systemd-detect-virt)
[[ -n $(echo "openvz lxc lxc-libvirt systemd-nspawn docker podman rkt wsl proot pouch" | grep $virt) ]] && virt_type="container"

if [[ $virt_type = "container" ]]; then
sed -i '/de_GWD.socket/c\proxy_pass http://127.0.0.1:9896;' /etc/nginx/conf.d/default.conf
jq 'del(.inbounds[0].listen)' /opt/de_GWD/vtrui/config.json |\
jq '.inbounds[0].port=9896' | sponge /opt/de_GWD/vtrui/config.json
fi

systemctl restart doh-server
if [[ $? -ne 0 ]]; then
sed -i '/Nice=/d' /etc/systemd/system/doh-server.service
systemctl daemon-reload >/dev/null
systemctl restart doh-server
fi
systemctl enable vtrui >/dev/null 2>&1

systemctl restart vtrui
if [[ $? -ne 0 ]]; then
sed -i '/Nice=/d' /etc/systemd/system/vtrui.service
systemctl daemon-reload >/dev/null
systemctl restart vtrui
fi
systemctl enable vtrui >/dev/null 2>&1

systemctl restart nginx
if [[ $? -ne 0 ]]; then
sed -i '/Nice=/d' /etc/systemd/system/nginx.service
systemctl daemon-reload >/dev/null
systemctl restart nginx
fi
systemctl enable nginx >/dev/null 2>&1

rm -rf /tmp/comRestart
EOF
chmod +x /tmp/comRestart
screen -dmS comRestart /tmp/comRestart
sleep 3
}


checkKernel(){
if [[ $(dpkg --list | grep linux-image | wc -l) != "1" ]]; then
echo -e "${WHITE}[ ${YELLOW}! ${WHITE}]\c" && echo -e "\t${YELLOW}Kernel updated & reboot${cRES}"
sleep 2
sudo reboot
exit
fi
}



install3rdKernel(){
bash <(wget --show-progress -cqO- https://raw.githubusercontent.com/jacyl4/de_GWD/main/resource/kernel/install3rdKernel)
}

restoreKernel(){
bash <(wget --show-progress -cqO- https://raw.githubusercontent.com/jacyl4/de_GWD/main/resource/kernel/installDefaultKernel)
}



changeDomain(){
    echo -e "${GREEN}================== ${cRES}"
    echo -e "${GREEN} Input new domain${cRES}"
    echo -e "${GREEN}================== ${cRES}"
    read vpsdomainP

domain=$(echo $vpsdomainP | cut -d: -f1)
topDomain=$(echo $domain | rev | awk -F. '{print $1"."$2}' | rev)
port=$(echo $vpsdomainP | cut -d: -f2| grep '^[[:digit:]]*$')
[[ -z $port ]] && port="443"

path=$(jq -r '.inbounds[0].streamSettings.wsSettings.path' /opt/de_GWD/vtrui/config.json 2>/dev/null | grep -v '^null$')

if [[ $port = "443" ]]; then
makeSSL_W

ocspStapling
else
    echo -e "${GREEN}=============================== ${cRES}"
    echo -e "${GREEN} Cloudflare API KEY${cRES}"
    echo -e "${GREEN}=============================== ${cRES}"
    read CFapikey

    echo -e "${GREEN}=============================== ${cRES}"
    echo -e "${GREEN} Cloudflare Email${cRES}"
    echo -e "${GREEN}=============================== ${cRES}"
    read CFemail

makeSSL_D

ocspStapling
fi

nginxWebConf

systemctl force-reload nginx

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}Domain and Certificates ${GREEN}Changed${cRES}"
}



changeXrayVerify(){
    echo -e "${GREEN}========== ${cRES}"
    echo -e "${GREEN} New UUID${cRES}"
    echo -e "${GREEN}========== ${cRES}"
    read nuuid

    echo -e "${GREEN}========== ${cRES}"
    echo -e "${GREEN} New Path${cRES}"
    echo -e "${GREEN}========== ${cRES}"
    read npath

domain=$(awk '/server_name/ {print$2;exit}' /etc/nginx/conf.d/default.conf | sed 's/.$//')
topDomain=$(echo $domain | rev | awk -F. '{print $1"."$2}' | rev)
port=$(awk '/ssl http2 fastopen=128 reuseport/ {print$2}' /etc/nginx/conf.d/default.conf | grep '^[[:digit:]]*$')

path=$npath
uuids=$nuuid

upDomain=$(jq -r '.outbounds[0].settings.vnext[0].address' /opt/de_GWD/vtrui/config.json 2>/dev/null | grep -v '^null$')
upPort=$(jq -r '.outbounds[0].settings.vnext[0].port' /opt/de_GWD/vtrui/config.json 2>/dev/null | grep -v '^null$')
upUUID=$(jq -r '.outbounds[0].settings.vnext[0].users[0].id' /opt/de_GWD/vtrui/config.json 2>/dev/null | grep -v '^null$')
xtlsPort=$(jq -r '.inbounds[] | select(.tag == "forward") | .port' /opt/de_GWD/vtrui/config.json 2>/dev/null | grep -v '^null$')

nginxWebConf

systemctl force-reload nginx

xrayInbound

if [[ -n $xtlsPort ]]; then
  xrayInboundForward
fi

if [[ -n $upDomain ]]; then
  xrayOutboundForward
else
  xrayOutboundDirect
fi

systemctl restart vtrui >/dev/null 2>&1

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}Xray UUID & Path ${GREEN}Changed${cRES}"
}



changeWGCF(){
    echo -e "${GREEN}================================================ ${cRES}"
    echo -e "${GREEN}[1]: Enable Cloudflare wireguard upstream (WARP) ${cRES}"
    echo -e "${GREEN}[2]: Delete Cloudflare wireguard upstream (WARP) ${cRES}"
    echo -e "${GREEN}================================================ ${cRES}"
    read -s -n 1 WGCFswitch
    echo -e "${WHITE}[...${WHITE}]\c" && echo -e "\t${WHITE}Switching Cloudflare wireguard upstream (WARP)${cRES}\r\c"

if [[ $WGCFswitch = "1" ]]; then
uname -r 2>&1 | grep -o '[0-9.]*' | head -n 1 >/tmp/kernelVer
echo "5.6" >>/tmp/kernelVer

if [[ $(cat /tmp/kernelVer |sort -rV | head -n 1) = "5.6" ]]; then
echo -e "${WHITE}[ ${YELLOW}! ${WHITE}]\c" && echo -e "\t${YELLOW}Update kernel first! ${cRES}"
else
cat << EOF >/etc/resolv.conf
nameserver 1.1.1.1
nameserver 8.8.8.8
EOF

ethernetnum=$(ip --oneline link show up | grep -v "lo" | awk '{print$2;exit}' | cut -d':' -f1 | cut -d'@' -f1)
localaddrIPv4=$(ip route | grep "$ethernetnum" | awk NR==2 | grep -Po '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | awk NR==2)

localaddrIPv4=$(ip -4 a | grep inet | grep -v '127.0.0.1' | awk '{print $2}' | cut -d'/' -f1 | head -n 1)
if [[ -n $localaddrIPv4 ]]; then
unset aptPKG
[[ -z $(dpkg -l | awk '{print$2}' | grep '^wireguard-tools$') ]] && aptPKG+=(wireguard-tools)
[[ -n $aptPKG ]] && apt update && apt install $(echo ${aptPKG[@]})

ghREPO="ViRb3/wgcf"
ghPackage="linux_$architecture"
curl -sSL https://api.github.com/repos/${ghREPO}/releases/latest | grep -E 'browser_download_url' | grep $ghPackage | cut -d '"' -f 4 | wget --show-progress -qi - -O /tmp/wgcf
[[ $(du -sk /tmp/wgcf 2>/dev/null | awk '{print$1}') -gt 8000 ]] && mv /tmp/wgcf /usr/local/bin/wgcf && chmod +x /usr/local/bin/wgcf

if [[ -x "/usr/local/bin/wgcf" ]]; then
echo | wgcf register
wgcf generate

PrivateKey=$(cat wgcf-profile.conf | awk '/PrivateKey/{print$3}')
PublicKey=$(cat wgcf-profile.conf | awk '/PublicKey/{print$3}')

cat << EOF >/etc/wireguard/wgcf.conf
[Interface]
PrivateKey = $PrivateKey
Address = 172.16.0.2/32
PostUp = ip rule add from $localaddrIPv4 lookup main
PostDown = ip rule del from $localaddrIPv4 lookup main
DNS = 127.0.0.1
MTU = 1420
[Peer]
PublicKey = $PublicKey
AllowedIPs = 0.0.0.0/0
AllowedIPs = ::/0
EndPoint = 162.159.193.10:2408
EOF

rm -rf wgcf-account.toml >/dev/null 2>&1
rm -rf wgcf-profile.conf >/dev/null 2>&1
fi

rm -rf /lib/systemd/system/wg-quick@.service
cat << "EOF" >/etc/systemd/system/wg-quick@.service
[Unit]
Description=WireGuard via wg-quick(8) for %I
After=network-online.target nss-lookup.target
Wants=network-online.target nss-lookup.target
PartOf=wg-quick.target

[Service]
User=root
Type=oneshot
Environment=WG_ENDPOINT_RESOLUTION_RETRIES=infinity
ExecStart=/usr/bin/wg-quick up %i
ExecStop=/usr/bin/wg-quick down %i
ExecReload=/bin/bash -c 'exec /usr/bin/wg syncconf %i <(exec /usr/bin/wg-quick strip %i)'
RemainAfterExit=yes

CapabilityBoundingSet=CAP_NET_RAW CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_RAW CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload >/dev/null

cat << "EOF" >/tmp/WGCFstart
#!/bin/bash
systemctl enable wg-quick@wgcf
systemctl restart wg-quick@wgcf

rm -rf /run/resolvconf/interface
resolvconf -u

rm -rf /tmp/WGCFstart
EOF
chmod +x /tmp/WGCFstart

screen -dmS WGCFstart /tmp/WGCFstart
sleep 3

wanIP=$(curl -4sSL whatismyip.akamai.com | grep -Po '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}')
[[ -z $wanIP ]] && wanIP=$(curl -4sSL ifconfig.me | grep -Po '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}')

echo -e "${BLUE}------------------------------------------------------------- ${cRES}"
[[ $localaddrIPv4 != $wanIP ]] && echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}Cloudflare wireguard upstream (WARP) ${GREEN}Enabled${cRES}"
[[ $localaddrIPv4 == $wanIP ]] && echo -e "${WHITE}[ ${RED}✕ ${WHITE}]\c" && echo -e "\t${WHITE}Cloudflare wireguard upstream (WARP) ${RED}Failed${cRES}"
echo -e "${BLUE}------------------------------------------------------------- ${cRES}"
else
echo -e "${WHITE}[ ${RED}✕ ${WHITE}]\c" && echo -e "\t${RED}This vps has no IPv4 address${cRES}"
fi
fi
elif [[ $WGCFswitch = "2" ]]; then
cat << "EOF" >/tmp/WGCFstop
#!/bin/bash
systemctl stop wg-quick@wgcf
systemctl disable wg-quick@wgcf

rm -rf /run/resolvconf/interface
resolvconf -u

rm -rf /tmp/WGCFstop
EOF
chmod +x /tmp/WGCFstop

screen -dmS WGCFstop /tmp/WGCFstop

echo -e "${WHITE}[ ${RED}✕ ${WHITE}]\c" && echo -e "\t${WHITE}Cloudflare wireguard upstream (WARP) ${RED}Disabled${cRES}"
fi
}



changeXTLSF(){
    echo -e "${GREEN}=========================== ${cRES}"
    echo -e "${GREEN}[1]: Connect to XTLS server${cRES}"
    echo -e "${GREEN}[2]: Set XTLS Server${cRES}"
    echo -e "${GREEN}[3]: Delete XTLS forward${cRES}"
    echo -e "${GREEN}=========================== ${cRES}"
    read -s -n 1 xtlsSet
    echo -e "${WHITE}[...${WHITE}]\c" && echo -e "\t${WHITE}Modifying XTLS settings${cRES}\r\c"

if [[ $xtlsSet = "1" ]]; then
    echo -e "${GREEN}=========================== ${cRES}"
    echo -e "${GREEN}XTLS upstream Domain & Port${cRES}"
    echo -e "${GREEN}=========================== ${cRES}"
    read upDomainP

    echo -e "${GREEN}=========================== ${cRES}"
    echo -e "${GREEN}XTLS upstream UUID${cRES}"
    echo -e "${GREEN}=========================== ${cRES}"
    read upUUID

upDomain=$(echo $upDomainP | cut -d: -f1)
upPort=$(echo $upDomainP | cut -d: -f2| grep '^[[:digit:]]*$')

xrayOutboundForward

systemctl restart vtrui >/dev/null 2>&1

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}XTLS Client ${GREEN}Deployed${cRES}"

elif [[ $xtlsSet = "2" ]]; then
    echo -e "${GREEN}======================= ${cRES}"
    echo -e "${GREEN}XTLS Port${cRES}"
    echo -e "${GREEN}======================= ${cRES}"
    read xtlsPort

port=$(awk '/ssl http2 fastopen=128 reuseport/ {print$2}' /etc/nginx/conf.d/default.conf)
uuids=$(jq -r '.inbounds[0].settings.clients[].id' /opt/de_GWD/vtrui/config.json 2>/dev/null | grep -v '^null$')

xrayInboundForward

systemctl restart vtrui >/dev/null 2>&1

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}XTLS Client ${GREEN}Deployed${cRES}"

elif [[ $xtlsSet = "3" ]]; then
jq 'del(.inbounds[] | select(.tag == "forward"))' /opt/de_GWD/vtrui/config.json | sponge /opt/de_GWD/vtrui/config.json
xrayOutboundDirect

systemctl restart vtrui >/dev/null 2>&1

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}XTLS Client ${GREEN}Deleted${cRES}"
fi
}



changeTCPPF(){
    echo -e "${GREEN}============================ ${cRES}"
    echo -e "${GREEN}[1]: Set TCP Port Forward${cRES}"
    echo -e "${GREEN}[2]: Delete TCP Port Forward${cRES}"
    echo -e "${GREEN}============================ ${cRES}"
    read -s -n 1 tcpPFsw
    echo -e "${WHITE}[...${WHITE}]\c" && echo -e "\t${WHITE}Modifying TCP Port Forward settings${cRES}\r\c"

if [[ $tcpPFsw = "1" ]]; then
    echo -e "${GREEN}======================= ${cRES}"
    echo -e "${GREEN}Upstream Domain & Port${cRES}"
    echo -e "${GREEN}======================= ${cRES}"
    read upDomainP

    echo -e "${GREEN}======================= ${cRES}"
    echo -e "${GREEN}Local Port${cRES}"
    echo -e "${GREEN}======================= ${cRES}"
    read localP

upDomain=$(echo $upDomainP | cut -d: -f1)
upPort=$(echo $upDomainP | cut -d: -f2| grep '^[[:digit:]]*$')

unset aptPKG
[[ -z $(dpkg -l | awk '{print$2}' | grep '^haproxy$') ]] && aptPKG+=(haproxy)
[[ -n $aptPKG ]] && apt update && apt install $(echo ${aptPKG[@]})

cat << EOF >/etc/haproxy/haproxy.cfg
global
  ulimit-n              500000
  maxconn               200000

defaults
  mode                  tcp
  option                dontlognull
  timeout connect       10s
  timeout client        1m
  timeout server        1m
  timeout check         10s

resolvers local
  nameserver            dns 127.0.0.1:53
  resolve_retries       3
  timeout retry         3s
  hold valid            10s
  accepted_payload_size 8192

frontend $upDomain
  bind                  *:$localP
  default_backend       $upDomain

backend $upDomain
  server endpoint $upDomainP check resolvers local init-addr none
EOF


rm -rf /lib/systemd/system/haproxy.service
cat << "EOF" >/etc/systemd/system/haproxy.service
[Unit]
Description=HAProxy
After=network.target rsyslog.service

[Service]
User=root
Type=notify
EnvironmentFile=-/etc/default/haproxy
Environment="CONFIG=/etc/haproxy/haproxy.cfg" "PIDFILE=/run/haproxy.pid"
ExecStartPre=/usr/sbin/haproxy -f $CONFIG -c -q $EXTRAOPTS
ExecStart=/usr/sbin/haproxy -Ws -f $CONFIG -p $PIDFILE $EXTRAOPTS
ExecReload=/usr/sbin/haproxy -f $CONFIG -c -q $EXTRAOPTS
ExecReload=/bin/kill -USR2 $MAINPID
KillMode=mixed
Restart=always
RestartSec=2
TimeoutStopSec=5

CapabilityBoundingSet=CAP_NET_RAW CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_RAW CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload >/dev/null
systemctl enable haproxy >/dev/null 2>&1
systemctl restart haproxy

domain=$(awk '/server_name/ {print$2;exit}' /etc/nginx/conf.d/default.conf | sed 's/.$//')

echo -e "${BLUE}------------------------------------------------ ${cRES}"
echo -e "${GREEN}TCP Port Forward${cRES}"
echo
echo -e "${BLUE}Address:       ${YELLOW}$domain:$localP${cRES}"
echo -e "${BLUE}tls:           ${YELLOW}$upDomain${cRES}"
echo -e "${BLUE}------------------------------------------------ ${cRES}"
echo
echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}TCP Port Forward ${GREEN}Deployed${cRES}"
elif [[ $tcpPFsw = "2" ]]; then
systemctl stop haproxy
systemctl disable haproxy

rm -rf /etc/haproxy/haproxy.cfg >/dev/null 2>&1

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}TCP Port Forward ${GREEN}Deleted${cRES}"
fi
}



printNode(){
vpsdomain=$(awk '/server_name/ {print$2;exit}' /etc/nginx/conf.d/default.conf | sed 's/.$//')
port=$(awk '/ssl http2 fastopen=128 reuseport/ {print$2}' /etc/nginx/conf.d/default.conf)

if [[ $port = "443" ]]; then
vpsdomainP=$vpsdomain
else
vpsdomainP=$vpsdomain:$port
fi

path=$(jq -r '.inbounds[0].streamSettings.wsSettings.path' /opt/de_GWD/vtrui/config.json 2>/dev/null | grep -v '^null$')
uuids=$(jq -r '.inbounds[0].settings.clients[].id' /opt/de_GWD/vtrui/config.json 2>/dev/null | grep -v '^null$')

xtlsPort=$(jq -r '.inbounds[] | select(.tag == "forward") | .port' /opt/de_GWD/vtrui/config.json 2>/dev/null | grep -v '^null$')

if [[ $(systemctl is-active 'haproxy') == "active" ]]; then
echo -e "${BLUE}-------------------------------------------------- ${cRES}"
echo -e "${GREEN}HAProxy TCP Port Forward${cRES}"
echo
awk '/frontend/' /etc/haproxy/haproxy.cfg | while read line; do
upDomain=$(echo $line | awk '{print$2}')
localPort=$(awk "/frontend $upDomain/{getline; print}" /etc/haproxy/haproxy.cfg | cut -d: -f2)
upDomainP=$(awk "/backend $upDomain/{getline; print\$3}" /etc/haproxy/haproxy.cfg)

echo -e "${BLUE}Address:       ${YELLOW}$vpsdomain:$localPort${cRES}"
echo -e "${BLUE}tls:           ${YELLOW}$upDomain${cRES}"
echo
done
fi

if [[ -n $xtlsPort ]]; then
echo -e "${BLUE}-------------------------------------------------- ${cRES}"
echo -e "${GREEN}XTLS Server${cRES}"
echo
echo -e "${BLUE}XTLS Port:         ${YELLOW}$xtlsPort${cRES}"
echo
fi
echo -e "${BLUE}-------------------------------------------------- ${cRES}"
echo -e "${GREEN}Xray node information${cRES}"
echo
echo -e "${BLUE}DoH:       ${YELLOW}$vpsdomainP/dq${cRES}"
echo -e "${BLUE}Address:   ${YELLOW}$vpsdomainP${cRES}"
echo -e "${BLUE}UUID:      ${YELLOW}$uuids${cRES}"
echo -e "${BLUE}Path:      ${YELLOW}$path?ed=2048${cRES}"
echo
echo -e "${BLUE}QR code: ${cRES}"
subAddr=$(echo -n "$(jq -r '.inbounds[0].settings.clients[0].id' /opt/de_GWD/vtrui/config.json 2>/dev/null | grep -v '^null$')@$vpsdomain:$port")
subUrl="vless://"$subAddr"?encryption=none&security=tls&sni="$vpsdomain"&type=ws&path="$path"&tfo=1&mux=1"
qrencode -t UTF8 -s 1 -m 3 $subUrl
echo
echo -e "${BLUE}-------------------------------------------------- ${cRES}"
}



installGWD(){
    echo -e "${GREEN}================== ${cRES}"
    echo -e "${GREEN} Input VPS domain${cRES}"
    echo -e "${GREEN}================== ${cRES}"
    read vpsdomainP

domain=$(echo $vpsdomainP | cut -d: -f1)
topDomain=$(echo $domain | rev | awk -F. '{print $1"."$2}' | rev)
port=$(echo $vpsdomainP | cut -d: -f2 | grep '^[[:digit:]]*$')
[[ -z $port ]] && port="443"

if [[ $port != "443" ]]; then
    echo -e "${GREEN}=============================== ${cRES}"
    echo -e "${GREEN} Cloudflare API KEY${cRES}"
    echo -e "${GREEN}=============================== ${cRES}"
    read CFapikey

    echo -e "${GREEN}=============================== ${cRES}"
    echo -e "${GREEN} Cloudflare Email${cRES}"
    echo -e "${GREEN}=============================== ${cRES}"
    read CFemail
fi

uuids=$(cat /proc/sys/kernel/random/uuid)
path="/$(echo $uuids | awk '{print substr($0,length($1)-5)}')"

ethernetnum=$(ip --oneline link show up | grep -v "lo" | awk '{print$2;exit}' | cut -d':' -f1 | cut -d'@' -f1)
localaddr=$(ip route | grep "$ethernetnum" | awk NR==2 | grep -Po '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | awk NR==2)

dpkg --configure -a

if [[ $(cat /etc/os-release | grep VERSION= | cut -d'(' -f2 | cut -d')' -f1) == "stretch" ]]; then
cat << EOF >/etc/apt/sources.list
deb http://cloudfront.debian.net/debian buster main contrib non-free
deb http://cloudfront.debian.net/debian buster-updates main contrib non-free
deb http://cloudfront.debian.net/debian-security buster/updates main contrib non-free
EOF

sed -i "s/ stretch / buster /g" /etc/apt/sources.list.d/* >/dev/null 2>&1
apt update --fix-missing && apt upgrade --allow-downgrades -y
apt full-upgrade -y && apt autoremove --purge -y && apt clean -y && apt autoclean -y
fi

cat << EOF >/etc/apt/sources.list
deb http://cloudfront.debian.net/debian bullseye main contrib non-free
deb http://cloudfront.debian.net/debian bullseye-updates main contrib non-free
deb http://cloudfront.debian.net/debian bullseye-backports main contrib non-free
deb http://cloudfront.debian.net/debian-security bullseye-security main contrib non-free
EOF

sed -i "s/ buster / bullseye /g" /etc/apt/sources.list.d/* >/dev/null 2>&1
apt update --fix-missing && apt upgrade --allow-downgrades -y
apt full-upgrade -y && apt autoremove --purge -y && apt clean -y && apt autoclean -y

preInstall

installPihole

piholeSet

[[ $virt_type != "container" ]] && installNftables

repoDL

installDOH

installNginx

installXray

if [[ $port == "443" ]]; then
makeSSL_W
else
makeSSL_D
fi

ocspStapling

nginxWebConf

xrayInbound

xrayOutboundDirect

postInstall

enableAutoUpdate

printNode

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}de_GWD ${GREEN}Installed${cRES}"
}



updateGWD(){
[[ ! -f "/opt/de_GWD/version.php" ]] && echo -e "${RED}This is not server${cRES}" && exit

preUpdate

preInstall

installPihole

piholeSet

[[ $virt_type != "container" ]] && installNftables

repoDL

installDOH

installNginx

installXray

nginxWebConf

xrayInbound

if [[ -n $xtlsPort ]]; then
  xrayInboundForward
fi

if [[ -n $upDomain ]]; then
  xrayOutboundForward
else
  xrayOutboundDirect
fi

postInstall

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}de_GWD ${GREEN}Updated${cRES}"

checkKernel
}



enableAutoUpdate(){
cat << "EOF" >/opt/de_GWD/autoUpdate
#!/bin/bash
localVer=$(awk 'NR==1' /opt/de_GWD/version.php)
remoteVer=$(curl -sSLo- https://raw.githubusercontent.com/jacyl4/de_GWD/main/version.php | head -n 1)

echo $localVer >/tmp/de_GWD_Ver
echo $remoteVer >>/tmp/de_GWD_Ver

VerCP=$(cat /tmp/de_GWD_Ver | sort -rV | uniq | awk NR==2)

if [[ $VerCP == $localVer ]]; then
rm -rf /tmp/autoUpdate
wget -t 5 -T 10 -cqO /tmp/autoUpdate https://raw.githubusercontent.com/jacyl4/de_GWD/main/server

if [[ $(du -sk /tmp/autoUpdate 2>/dev/null | awk '{print$1}') -gt 70 ]]; then
sed -i '$d' /tmp/autoUpdate
echo "updateGWD" >>  /tmp/autoUpdate
chmod +x /tmp/autoUpdate
/tmp/autoUpdate
rm -rf /tmp/autoUpdate
fi
fi

rm -rf /tmp/de_GWD_Ver
rm -rf /tmp/autoUpdate
EOF
chmod +x /opt/de_GWD/autoUpdate

crontab -l 2>/dev/null > /tmp/now.cron
sed -i '/autoUpdate/d' /tmp/now.cron
echo '30 4 * * *  /opt/de_GWD/autoUpdate' >> /tmp/now.cron
crontab /tmp/now.cron
rm -rf /tmp/now.cron
}



autoUpdateGWD(){
    echo -e "${GREEN}======================== ${cRES}"
    echo -e "${GREEN}[Y]: Turn on AutoUpdate${cRES}"
    echo -e "${GREEN}[N]: Turn off AutoUpdate${cRES}"
    echo -e "${GREEN}======================== ${cRES}"
    read -s -n 1 autoUpdateswitch
    echo -e "${WHITE}[...${WHITE}]\c" && echo -e "\t${WHITE}Modifying AutoUpdate settings${cRES}\r\c"

if [[ $autoUpdateswitch = "Y" ]] || [[ $autoUpdateswitch = "y" ]]; then

enableAutoUpdate

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}AutoUpdate ${GREEN}On${cRES}"

elif [[ $autoUpdateswitch = "N" ]] || [[ $autoUpdateswitch = "n" ]]; then

crontab -l 2>/dev/null > /tmp/now.cron
sed -i '/autoUpdate/d' /tmp/now.cron
crontab /tmp/now.cron
rm -rf /tmp/now.cron

rm -rf /opt/de_GWD/autoUpdate

echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]\c" && echo -e "\t${WHITE}AutoUpdate ${RED}Off${cRES}"
fi
}



CFspeedTest(){
ghREPO="makotom/cfspeed"
ghPackage="linux-$architecture.tar.gz"

if [[ $(/var/www/html/cfspeed -v 2>/dev/null | awk '{print$2}') != $(curl -sSL https://api.github.com/repos/${ghREPO}/releases/latest | grep -E 'tag_name' | cut -d '"' -f 4) ]]; then
rm -rf /tmp/cfspeed*
curl -sSL https://api.github.com/repos/${ghREPO}/releases/latest | grep -E 'browser_download_url' | grep $ghPackage | cut -d '"' -f 4 | wget --show-progress -qi - -O /tmp/cfspeed.tar.gz

tar -zxvf /tmp/cfspeed.tar.gz -C /tmp >/dev/null 2>&1
mv -f /tmp/cfspeed /var/www/html/cfspeed >/dev/null 2>&1
chmod +x /var/www/html/cfspeed >/dev/null 2>&1
fi
/var/www/html/cfspeed
exit
}





start_menu(){
echo
if [[ -f "/var/www/ssl/de_GWD.cer" ]]; then
  sslExpireDate=$(openssl x509 -enddate -noout -in /var/www/ssl/de_GWD.cer | sed 's/notAfter=//')
else
  sslExpireDate="not exist"
fi

if [[ $(systemctl is-active 'pihole-FTL') = "active" ]]; then
  echo -e "${WHITE} Pi-hole        \c" && echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]${cRES}"
elif [[ ! -x "/usr/local/bin/pihole" ]]; then
  echo -e "${WHITE} Pi-hole        \c" && echo -e "${WHITE}[ ${YELLOW}! ${WHITE}]${cRES}"
else
  echo -e "${WHITE} Pi-hole        \c" && echo -e "${WHITE}[ ${RED}✕ ${WHITE}]${cRES}"
fi

if [[ $(systemctl is-active 'nginx') = "active" ]]; then
  echo -e "${WHITE} Nginx          \c" && echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]${cRES}"
elif [[ ! -x "/usr/sbin/nginx" ]]; then
  echo -e "${WHITE} Nginx          \c" && echo -e "${WHITE}[ ${YELLOW}! ${WHITE}]${cRES}"
else
  echo -e "${WHITE} Nginx          \c" && echo -e "${WHITE}[ ${RED}✕ ${WHITE}]${cRES}"
fi

if [[ $(systemctl is-active 'vtrui') = "active" ]]; then
  echo -e "${WHITE} Xray           \c" && echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]${cRES}"
elif [[ ! -x "/opt/de_GWD/vtrui/vtrui" ]]; then
  echo -e "${WHITE} Xray           \c" && echo -e "${WHITE}[ ${YELLOW}! ${WHITE}]${cRES}"
else
  echo -e "${WHITE} Xray           \c" && echo -e "${WHITE}[ ${RED}✕ ${WHITE}]${cRES}"
fi

if [[ $(systemctl is-active 'doh-server') = "active" ]]; then
  echo -e "${WHITE} DoH server     \c" && echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]${cRES}"
elif [[ ! -f "/opt/de_GWD/doh-server" ]]; then
  echo -e "${WHITE} DoH server     \c" && echo -e "${WHITE}[ ${YELLOW}! ${WHITE}]${cRES}"
else
  echo -e "${WHITE} DoH server     \c" && echo -e "${WHITE}[ ${RED}✕ ${WHITE}]${cRES}"
fi

if [[ -n $(crontab -l 2>&1 | grep "autoUpdate") ]] && [[ -f "/opt/de_GWD/autoUpdate" ]]; then
  echo -e "${WHITE} AutoUpdate     \c" && echo -e "${WHITE}[ ${GREEN}✓ ${WHITE}]${cRES}"
else
  echo -e "${WHITE} AutoUpdate     \c" && echo -e "${WHITE}[ ${WHITE}- ${WHITE}]${cRES}"
fi

echo -e "${BLUE}$virt${cRES}"
[[ -f "/opt/de_GWD/version.php" ]] && echo -e "${BLUE}Version: ${YELLOW}$(echo $(awk 'NR==1' /opt/de_GWD/version.php)) ${cRES}"
[[ $(systemctl is-active 'wg-quick@wgcf') = "active" ]] && echo -e "${PURPLE}[Enabled] Cloudflare wireguard upstream (WARP) ${cRES}"
[[ $(systemctl is-active 'haproxy') = "active" ]] && echo -e "${PURPLE}[Enabled] HAProxy TCP Port Forward${cRES}"

if [[ $virt_type = "container" ]]; then
 echo -e "${BLUE}---------------------------------------------------------------- ${cRES}"
 echo -e "${BLUE}Debian Version:                 $(cat /etc/os-release | grep VERSION= | cut -d'(' -f2 | cut -d')' -f1) ${cRES}"
 echo -e "${BLUE}Kernel:                         $(uname -r) ${cRES}"
 echo -e "${BLUE}---------------------------------------------------------------- ${cRES}"
 echo -e "${BLUE}SSL certificate expires on:     $sslExpireDate${cRES}"
 echo -e "${GREEN}============SERVER============================================== ${cRES}"
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
 echo -e "${GREEN}2. Install lkl-bbrplus${cRES}"
   echo -e "${RED}4. Change domain and generate new certificate${cRES}"
   echo -e "${RED}5. Change Xray path & UUID${cRES}"
echo -e "${YELLOW}6. Change XTLS Forward${cRES}"
echo -e "${YELLOW}0. Update de_GWD${cRES}"
   echo -e "${RED}00.AutoUpdate turn on/off${cRES}"
 echo -e "${GREEN}11.Print Xray node information${cRES}"
 echo -e "${GREEN}12.Localhost cloudflare speedtest${cRES}"
  echo -e "${CYAN}44.Set TCP Port Forward${cRES}"
echo -e "${RED}CTRL+C EXIT${cRES}"
echo
read -p "Select:" num
    case "$num" in
    1)
    installGWD
    start_menu
    ;;
    2)
    installBBRplus
    start_menu
    ;;
    4)
    changeDomain
    start_menu
    ;;
    5)
    changeXrayVerify
    start_menu
    ;;
    6)
    changeXTLSF
    start_menu
    ;;
    0)
    updateGWD
    start_menu
    ;;
    00)
    autoUpdateGWD
    start_menu
    ;;
    11)
    printNode
    start_menu
    ;;
    12)
    CFspeedTest
    start_menu
    ;;
    44)
    changeTCPPF
    start_menu
    ;;
    *)
    clear
    echo -e "${RED}Wrong number${cRES}"
    sleep 1s
    start_menu
    ;;
    esac

else
 echo -e "${BLUE}---------------------------------------------------------------- ${cRES}"
 echo -e "${BLUE}Debian Version:                 $(cat /etc/os-release | grep VERSION= | cut -d'(' -f2 | cut -d')' -f1) ${cRES}"
 echo -e "${BLUE}Kernel:                         $(uname -r) ${cRES}"
 echo -e "${BLUE}Current tcp congestion control: $(sysctl net.ipv4.tcp_congestion_control 2>/dev/null | cut -d' ' -f3) + $(sysctl net.core.default_qdisc 2>/dev/null | cut -d' ' -f3) ${cRES}"
 echo -e "${BLUE}---------------------------------------------------------------- ${cRES}"
 echo -e "${BLUE}SSL certificate expires on:     $sslExpireDate${cRES}"
 echo -e "${GREEN}============SERVER============================================== ${cRES}"
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
   echo -e "${RED}4. Change domain and generate new certificate${cRES}"
   echo -e "${RED}5. Change Xray path & UUID${cRES}"
echo -e "${YELLOW}6. Change XTLS Forward${cRES}"
echo -e "${YELLOW}0. Update de_GWD${cRES}"
   echo -e "${RED}00.AutoUpdate turn on/off${cRES}"
 echo -e "${GREEN}11.Print Xray node information${cRES}"
 echo -e "${GREEN}12.Localhost cloudflare speedtest${cRES}"
  echo -e "${CYAN}33.Set Cloudflare wireguard upstream (WARP) ${cRES}"
  echo -e "${CYAN}44.Set TCP Port Forward${cRES}"
echo -e "${RED}CTRL+C EXIT${cRES}"
echo
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
    4)
    changeDomain
    start_menu
    ;;
    5)
    changeXrayVerify
    start_menu
    ;;
    6)
    changeXTLSF
    start_menu
    ;;
    0)
    updateGWD
    start_menu
    ;;
    00)
    autoUpdateGWD
    start_menu
    ;;
    11)
    printNode
    start_menu
    ;;
    12)
    CFspeedTest
    start_menu
    ;;
    33)
    changeWGCF
    start_menu
    ;;
    44)
    changeTCPPF
    start_menu
    ;;
    *)
    clear
    echo -e "${RED}Wrong number${cRES}"
    sleep 1s
    start_menu
    ;;
    esac
fi
}

start_menu