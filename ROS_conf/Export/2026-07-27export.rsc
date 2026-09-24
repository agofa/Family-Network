# 2026-07-27 00:28:35 by RouterOS 7.23.2
# software id = W2XH-IHBV
#
# model = RBD52G-5HacD2HnD
# serial number = CE000BF2E2EE
/interface bridge
add comment="LAN bridge" name=bridge
/interface ethernet
set [ find default-name=ether1 ] l2mtu=1598
set [ find default-name=ether2 ] l2mtu=1598
set [ find default-name=ether3 ] l2mtu=1598
set [ find default-name=ether4 ] l2mtu=1598
set [ find default-name=ether5 ] l2mtu=1598
/interface wireguard
add listen-port=51820 mtu=1420 name=wg-vpn
/interface list
add name=LAN
/ip pool
add name=dhcp_pool ranges=192.168.10.50-192.168.10.100
add name=ovpn-pool ranges=192.168.8.10-192.168.8.30
/ip dhcp-server
add address-pool=dhcp_pool interface=bridge lease-time=1d name=dhcp1
/ppp profile
add dns-server=192.168.10.1 local-address=192.168.8.250 name=ovpn-profile \
    remote-address=ovpn-pool use-encryption=yes
/queue type
add kind=cake name=cake-download
add kind=cake name=cake-upload
/queue simple
add disabled=yes max-limit=500M/750M name=Smart-Queue-Global queue=\
    cake-upload/cake-download target=bridge
/system logging action
set 3 remote-log-format=syslog
/system script
add dont-require-permissions=no name=update_adlist owner=Pindus policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="/\
    ip dns adlist\
    \n:foreach i in=[find] do={\
    \n    set \$i ssl-verify=no\
    \n}\
    \n:log info \"DNS Adlist: aggiornamento completato con successo.\""
add dont-require-permissions=no name=update_whitelist owner=Pindus policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="#\
    \_==========================================\
    \n# Whitelist DNS - versione semplice ROS7\
    \n# ==========================================\
    \n\
    \n:local githubUrl \"https://raw.githubusercontent.com/agofa/Family-Networ\
    k/refs/heads/main/whitelist/whitelist.txt\"\
    \n:local fileName \"whitelist_temp.txt\"\
    \n\
    \n# Scarica il file\
    \n/tool fetch url=\$githubUrl mode=https dst-path=\$fileName\
    \n\
    \n# Attende fino a 20 secondi che il file esista\
    \n:local counter 0\
    \n:put \"pronti\"\
    \n:while ([:len [/file find name=\$fileName]] = 0 and \$counter < 20) do={\
    \n    :delay 1s\
    \n    :set counter (\$counter + 1)\
    \n    :put \"attesa\"\
    \n}\
    \n\
    \n# Se il file esiste\
    \n:if ([:len [/file find name=\$fileName]] > 0) do={\
    \n\
    \n    :put \"il file\"\
    \n    :local data [/file get \$fileName contents]\
    \n    :local lastEnd 0\
    \n    :local lineEnd 0\
    \n\
    \n    # Cancella tutte le entry aggiunte dallo script (comment=\"added-by-\
    whitelist\")\
    \n    :local ids [/ip dns static find where comment=\"added-by-whitelist\"\
    ]\
    \n    :if ([:len \$ids] > 0) do={\
    \n        /ip dns static remove \$ids\
    \n    }\
    \n\
    \n    # Scorre il file riga per riga\
    \n    :while (\$lastEnd < [:len \$data]) do={\
    \n\
    \n        :set lineEnd [:find \$data \"\\n\" \$lastEnd]\
    \n        :if (\$lineEnd = -1) do={ :set lineEnd [:len \$data] }\
    \n\
    \n        :local line [:pick \$data \$lastEnd \$lineEnd]\
    \n\
    \n        # Rimuove CR finale se presente\
    \n        :if ([:len \$line] > 0) do={\
    \n            :local lastChar [:pick \$line ([:len \$line] - 1)]\
    \n            :if (\$lastChar = \"\\r\") do={\
    \n                :set line [:pick \$line 0 ([:len \$line] - 1)]\
    \n            }\
    \n        }\
    \n\
    \n        # Se la riga non  vuota, aggiunge la voce DNS con commento\
    \n        :if ([:len \$line] > 0) do={\
    \n            /ip dns static add name=\$line type=FWD forward-to=1.1.1.1 c\
    omment=\"added-by-whitelist\"\
    \n            }\
    \n\
    \n        :set lastEnd (\$lineEnd + 1)\
    \n    }\
    \n\
    \n    /file remove \$fileName\
    \n    :log info \"[consenti] Aggiornata (versione semplice ROS7)\"\
    \n\
    \n} else={\
    \n    :log error \"[consenti] Impossibile scaricare file!\"\
    \n}\
    \n"
/interface bridge port
add bridge=bridge interface=ether2
add bridge=bridge interface=ether3
add bridge=bridge interface=ether4
add bridge=bridge interface=ether5
/ip settings
set rp-filter=loose
/interface list member
add interface=wg-vpn list=LAN
add interface=bridge list=LAN
/interface ovpn-server server
add auth=sha256 certificate=server-certificate cipher=\
    aes128-cbc,aes128-gcm,aes256-gcm default-profile=ovpn-profile disabled=no \
    mac-address=FE:92:07:49:FF:30 name=ovpn-server protocol=udp \
    require-client-certificate=yes
/interface wireguard peers
add allowed-address=10.0.0.3/32 client-allowed-address=::/0 comment=Fedora \
    interface=wg-vpn name=FedorsNotebook persistent-keepalive=25s public-key=\
    "Guj38Yjyirj/qFt8ldwMDiZA8BPRrfTloVKsU/W/EGQ="
add allowed-address=10.0.0.4/32 client-allowed-address=::/0 comment=Hippo \
    interface=wg-vpn name=Hippo public-key=\
    "Pz811nCCC66nhXax/y67cGg+/l0xSiDrjyl1VM6BShU="
add allowed-address=10.0.0.2/32 client-allowed-address=::/0 comment=\
    "Tunnel fisso verso Server AlmaLinux" interface=wg-vpn name=VPS \
    public-key="A7dLUBvSpFkwBtrD1zP7IgX1cntigVtQdvJSCCoC1FE="
/ip address
add address=192.168.10.1/24 comment="LAN 10.x gateway" interface=bridge \
    network=192.168.10.0
add address=10.0.0.1/24 interface=wg-vpn network=10.0.0.0
/ip cloud
set ddns-enabled=yes
/ip dhcp-client
add comment="WAN DHCP da IliadBox" interface=ether1 name=ether1 use-peer-dns=\
    no use-peer-ntp=no
/ip dhcp-server lease
add address=192.168.10.245 client-id=1:0:d8:61:a3:80:bf comment=DESKTOP \
    mac-address=00:D8:61:A3:80:BF server=dhcp1
add address=192.168.10.250 client-id=1:0:11:32:64:1a:ad comment=\
    "SYNOLOGY NAS" mac-address=00:11:32:64:1A:AD server=dhcp1
add address=192.168.10.246 client-id=1:10:e7:c6:d3:31:b9 comment=\
    "Stampante HP" mac-address=10:E7:C6:D3:31:B9 server=dhcp1
add address=192.168.10.230 client-id=1:b8:3a:8:cb:23:78 comment=\
    "ACCESS POINT TENDA" mac-address=B8:3A:08:CB:23:78 server=dhcp1
add address=192.168.10.200 client-id=1:7c:d3:a:18:3a:9b comment=ESXI \
    mac-address=7C:D3:0A:18:3A:9B server=dhcp1
add address=192.168.10.221 client-id=1:b8:27:eb:c1:52:a4 comment=\
    "RASPBERRY Ethernet port" mac-address=B8:27:EB:C1:52:A4 server=dhcp1
add address=192.168.10.220 client-id=1:b8:27:eb:94:7:f1 comment=\
    "RASPBERRY WIFI HUB-2" mac-address=B8:27:EB:94:07:F1 server=dhcp1
add address=192.168.10.240 client-id=1:6c:4c:bc:ff:40:9a mac-address=\
    6C:4C:BC:FF:40:9A server=dhcp1
add address=192.168.10.210 client-id=\
    ff:bc:9a:4a:2d:0:2:0:0:ab:11:a8:ea:4e:b3:e0:9e:e:d4 comment=\
    "UBUNTU HUB-1" mac-address=00:0C:29:EB:C9:69 server=dhcp1
/ip dhcp-server network
add address=192.168.10.0/24 dns-server=192.168.10.1 domain=home gateway=\
    192.168.10.1 ntp-server=193.204.114.232,193.204.114.233
/ip dns
set allow-remote-requests=yes cache-size=40000KiB servers="2606:4700:4700::111\
    1,2606:4700:4700::1001,2620:fe::fe,2620:fe::9,1.1.1.1,9.9.9.9"
/ip dns adlist
add ssl-verify=no url=\
    https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
add ssl-verify=no url=https://v.firebog.net/hosts/AdguardDNS.txt
add ssl-verify=no url="https://raw.githubusercontent.com/andyts93/pihole-itali\
    an-list/master/adlist.txt"
add ssl-verify=no url=https://adaway.org/hosts.txt
add ssl-verify=no url=https://small.oisd.nl/
add ssl-verify=no url="https://raw.githubusercontent.com/anudeepND/blacklist/m\
    aster/adservers.txt"
/ip dns static
add comment="Whitelist Google Content" forward-to=1.1.1.1 name=\
    googleusercontent.com type=FWD
add comment="Whitelist Spotify" forward-to=1.1.1.1 name=spotify.com type=FWD
add address=192.168.10.200 comment="Nome breve ESXi" name=esxi ttl=1h type=A
add address=192.168.10.250 comment="Nome breve NAS" name=syno ttl=1h type=A
add address=192.168.10.210 name=seal.home type=A
add address=192.168.10.210 name=cloud.home type=A
add comment=added-by-whitelist forward-to=1.1.1.1 name=about-scheme type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=\
    chrome-extension-scheme type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=chrome-scheme type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=edge-scheme type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=moz-extension-scheme \
    type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=opera-scheme type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=vivaldi-scheme type=\
    FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=wyciwyg-scheme type=\
    FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=agofa.org type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=amazon.com type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=amazon.it type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=brilliant.org type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=digitalocean.com type=\
    FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=discordapp.com type=\
    FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=docker.com type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=getpocket.com type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=giallozafferano.com \
    type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=github.com type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=gitlab.com type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=google.com type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=howlongtobeat.com \
    type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=ilpost.it type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=imdb.com type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=imgur.com type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=isthereanydeal.com \
    type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=n26.com type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=ocaml.org type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=osmand.net type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=primevideo.com type=\
    FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=projecteuler.net type=\
    FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=protondb.com type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=reddit.com type=FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=serverfault.com type=\
    FWD
add comment=added-by-whitelist forward-to=1.1.1.1 name=slack.com type=FWD
/ip firewall filter
add action=accept chain=input comment="INPUT: Accetta stabiliti/untracked" \
    connection-state=established,related,untracked
add action=drop chain=input comment="INPUT: Drop invalidi" connection-state=\
    invalid
add action=accept chain=input comment="INPUT: ICMP (Ping) limitato" limit=\
    5,10:packet protocol=icmp
add action=accept chain=input comment="INPUT: LAN -> Router" in-interface=\
    bridge
add action=accept chain=input comment="INPUT: Gestione remota WAN" \
    connection-state=new disabled=yes dst-port=2222,18291 in-interface=ether1 \
    protocol=tcp
add action=accept chain=input comment="INPUT: Gestione LAN" dst-port=\
    2222,18291 protocol=tcp src-address=192.168.10.0/24
add action=accept chain=input comment="INPUT: WireGuard UDP" dst-port=51820 \
    in-interface=ether1 protocol=udp
add action=accept chain=input comment="VPN: Porta OpenVPN UDP" dst-port=1194 \
    in-interface=ether1 protocol=udp
add action=accept chain=input comment="VPN: Gestione router da IP VPN" \
    src-address=192.168.8.0/24
add action=drop chain=input comment="INPUT: DROP FINALE WAN" in-interface=\
    ether1 log=yes log-prefix=WAN-DROP-MGMT
add action=fasttrack-connection chain=forward comment=\
    "FORWARD: Fasttrack (Ottimizzazione CPU)" connection-state=\
    established,related
add action=accept chain=forward comment="FORWARD: Accetta WebDAV da VPS" \
    connection-nat-state=dstnat connection-state=new disabled=yes \
    in-interface=ether1 src-address=185.198.244.21
add action=accept chain=forward comment="FORWARD: Accetta SMB da VPS" \
    connection-nat-state=dstnat connection-state=new disabled=yes \
    in-interface=ether1 src-address=185.198.244.21
add action=accept chain=forward comment="SSHFS WAN VPS -> Synology" disabled=\
    yes dst-address=192.168.10.250 dst-port=24 protocol=tcp src-address=\
    185.198.244.21
add action=accept chain=forward comment="FORWARD: Accetta stabiliti" \
    connection-state=established,related,untracked
add action=drop chain=forward comment="FORWARD: Drop invalidi" \
    connection-state=invalid
add action=accept chain=forward comment="VPN: Accesso a LAN da VPN" \
    out-interface=bridge src-address=192.168.8.0/24
add action=drop chain=forward comment="FORWARD: Drop WAN non nattata" \
    connection-nat-state=!dstnat connection-state=new in-interface=ether1
add action=accept chain=forward comment="FORWARD: LAN -> WAN (Navigazione)" \
    in-interface=bridge out-interface=ether1
add action=accept chain=forward comment=\
    "FORWARD: Traffico interno tra dispositivi LAN" in-interface=bridge \
    out-interface=bridge
add action=drop chain=forward comment=\
    "FORWARD: DROP FINALE (Sicurezza totale WAN->LAN)" in-interface=ether1 \
    log=yes log-prefix=WAN-DROP-LAN
/ip firewall nat
add action=masquerade chain=srcnat comment="NAT verso IliadBox" \
    out-interface=ether1
add action=masquerade chain=srcnat comment=\
    "NAT: Permetti ai client VPN di parlare con la LAN" out-interface=bridge \
    src-address=192.168.8.0/24
add action=dst-nat chain=dstnat comment="WebDAV: VPS -> Synology" disabled=\
    yes dst-port=5555 in-interface=ether1 protocol=tcp src-address=\
    185.198.244.21 to-addresses=192.168.10.250 to-ports=5555
add action=dst-nat chain=dstnat comment="SMB: VPS -> Synology" disabled=yes \
    dst-port=445 in-interface=ether1 protocol=tcp src-address=185.198.244.21 \
    to-addresses=192.168.10.250 to-ports=445
add action=dst-nat chain=dstnat comment="SSHFS: WAN VPS -> Synology" \
    disabled=yes dst-port=24 in-interface=ether1 protocol=tcp src-address=\
    185.198.244.21 to-addresses=192.168.10.250 to-ports=24
/ip firewall raw
add action=drop chain=prerouting comment="RAW: Drop TCP malformati" \
    in-interface=ether1 protocol=tcp tcp-flags=!fin,!syn,!rst,!psh,!ack,!urg
add action=drop chain=prerouting comment="RAW: Drop Spoofing 192.168" \
    in-interface=ether1 src-address=192.168.0.0/16
add action=drop chain=prerouting comment="RAW: Drop Spoofing 10.x" \
    in-interface=ether1 src-address=10.0.0.0/8
add action=drop chain=prerouting comment="RAW: Drop Spoofing 172.16" \
    in-interface=ether1 src-address=172.16.0.0/12
/ipv6 route
add disabled=no dst-address=::/0 gateway=fe80::3a07:16ff:fe20:3192%ether1 \
    pref-src="" routing-table=main
/ip service
set ftp disabled=yes
set telnet disabled=yes
set www address=192.168.10.0/24
set ssh address=192.168.10.0/24,10.0.0.0/24,192.168.8.0/24 port=2222
set api disabled=yes
set api-ssl disabled=yes
set winbox address=192.168.10.0/24,10.0.0.0/24,192.168.8.0/24 port=18291
/ipv6 address
add address=2a01:e11:401:a950::2 advertise=no comment=\
    "Collegamento alla iliadbox" interface=ether1
add address=2a01:e11:401:a951::1 comment="IP LAN" interface=bridge
/ipv6 firewall address-list
add address=::/128 comment="Unspecified address" list=bad_ipv6
add address=::1/128 comment=Loopback list=bad_ipv6
add address=::ffff:0.0.0.0/96 comment="IPv4-mapped IPv6" list=bad_ipv6
add address=100::/64 comment="Discard-only prefix" list=bad_ipv6
add address=2001:db8::/32 comment=Documentation list=bad_ipv6
add address=2001:10::/28 comment=ORCHID list=bad_ipv6
add address=fec0::/10 comment="Site-local (deprecated)" list=bad_ipv6
add address=fc00::/7 comment="Unique Local Address (ULA)" list=bad_ipv6
add address=ff00::/8 comment=Multicast list=bad_ipv6
/ipv6 firewall filter
add action=accept chain=input comment="v6: allow RS" icmp-options=133:0 \
    in-interface=ether1 protocol=icmpv6
add action=accept chain=input comment=\
    "ICMPv6 di tipo 134 (Router Advertisement)" icmp-options=134:0 \
    in-interface=ether1 protocol=icmpv6
add action=accept chain=input comment="v6: allow NS" icmp-options=135:0 \
    in-interface=ether1 protocol=icmpv6
add action=accept chain=input comment="v6: accept established, related" \
    connection-state=established,related
add action=accept chain=input comment="v6: allow NA" icmp-options=136:0 \
    in-interface=ether1 protocol=icmpv6
add action=accept chain=forward comment="v6: accept established, related" \
    connection-state=established,related
add action=drop chain=input comment="v6: drop invalid" connection-state=\
    invalid
add action=drop chain=forward comment="v6: drop invalid" connection-state=\
    invalid
add action=accept chain=input comment="v6: allow ICMPv6 input" protocol=\
    icmpv6
add action=accept chain=forward comment="v6: allow ICMPv6 forward" protocol=\
    icmpv6
add action=accept chain=input comment="v6: allow LAN to router" in-interface=\
    bridge
add action=drop chain=input comment="v6: drop bad sources from WAN" \
    in-interface=ether1 src-address-list=bad_ipv6
add action=drop chain=forward comment="v6: drop bad fwd from WAN" \
    in-interface=ether1 src-address-list=bad_ipv6
add action=drop chain=forward comment="v6: drop hop-limit=1 from WAN" \
    hop-limit=equal:1 in-interface=ether1
add action=drop chain=input comment=\
    "v6: drop everything else from WAN to router" in-interface=ether1 log=yes \
    log-prefix=V6-WAN-DROP
add action=drop chain=forward comment=\
    "v6: block all unauthorized access to LAN" in-interface=ether1
/ipv6 firewall mangle
add action=change-mss chain=forward comment="v6: Fix MTU per Iliad" new-mss=\
    clamp-to-pmtu out-interface=ether1 protocol=tcp tcp-flags=syn
/ipv6 nd
set [ find default=yes ] interface=ether1 ra-interval=20s-1m
add advertise-dns=yes dns=2a01:e11:401:a951::1 interface=bridge \
    other-configuration=yes ra-interval=20s-1m
/ppp secret
add name=ilcapo profile=ovpn-profile
/system clock
set time-zone-name=Europe/Rome
/system identity
set name=Mater
/system logging
set 3 action=memory
/system scheduler
add comment="ADBLOCK update ogni 7 giorni" interval=1w name=run_adlist_update \
    on-event=update_adlist policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2025-12-16 start-time=02:00:00
