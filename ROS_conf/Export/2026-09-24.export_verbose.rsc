# 2026-09-24 16:41:42 by RouterOS 7.24.4
# software id = W2XH-IHBV
#
# model = RBD52G-5HacD2HnD
# serial number = CE000BF2E2EE
/interface ethernet
set [ find default-name=ether1 ] advertise="10M-baseT-half,10M-baseT-full,100M\
    -baseT-half,100M-baseT-full,1G-baseT-half,1G-baseT-full" arp=enabled \
    arp-timeout=auto auto-negotiation=yes bandwidth=unlimited/unlimited \
    disabled=no l2mtu=1598 loop-protect=default loop-protect-disable-time=5m \
    loop-protect-send-interval=5s mac-address=C4:AD:34:F2:F2:55 mtu=1500 \
    name=ether1 orig-mac-address=C4:AD:34:F2:F2:55 rx-flow-control=off \
    tx-flow-control=off
set [ find default-name=ether2 ] advertise="10M-baseT-half,10M-baseT-full,100M\
    -baseT-half,100M-baseT-full,1G-baseT-half,1G-baseT-full" arp=enabled \
    arp-timeout=auto auto-negotiation=yes bandwidth=unlimited/unlimited \
    disabled=no l2mtu=1598 loop-protect=default loop-protect-disable-time=5m \
    loop-protect-send-interval=5s mac-address=C4:AD:34:F2:F2:56 mtu=1500 \
    name=ether2 orig-mac-address=C4:AD:34:F2:F2:56 rx-flow-control=off \
    tx-flow-control=off
set [ find default-name=ether3 ] advertise="10M-baseT-half,10M-baseT-full,100M\
    -baseT-half,100M-baseT-full,1G-baseT-half,1G-baseT-full" arp=enabled \
    arp-timeout=auto auto-negotiation=yes bandwidth=unlimited/unlimited \
    disabled=no l2mtu=1598 loop-protect=default loop-protect-disable-time=5m \
    loop-protect-send-interval=5s mac-address=C4:AD:34:F2:F2:57 mtu=1500 \
    name=ether3 orig-mac-address=C4:AD:34:F2:F2:57 rx-flow-control=off \
    tx-flow-control=off
set [ find default-name=ether4 ] advertise="10M-baseT-half,10M-baseT-full,100M\
    -baseT-half,100M-baseT-full,1G-baseT-half,1G-baseT-full" arp=enabled \
    arp-timeout=auto auto-negotiation=yes bandwidth=unlimited/unlimited \
    disabled=no l2mtu=1598 loop-protect=default loop-protect-disable-time=5m \
    loop-protect-send-interval=5s mac-address=C4:AD:34:F2:F2:58 mtu=1500 \
    name=ether4 orig-mac-address=C4:AD:34:F2:F2:58 rx-flow-control=off \
    tx-flow-control=off
set [ find default-name=ether5 ] advertise="10M-baseT-half,10M-baseT-full,100M\
    -baseT-half,100M-baseT-full,1G-baseT-half,1G-baseT-full" arp=enabled \
    arp-timeout=auto auto-negotiation=yes bandwidth=unlimited/unlimited \
    disabled=no l2mtu=1598 loop-protect=default loop-protect-disable-time=5m \
    loop-protect-send-interval=5s mac-address=C4:AD:34:F2:F2:59 mtu=1500 \
    name=ether5 orig-mac-address=C4:AD:34:F2:F2:59 rx-flow-control=off \
    tx-flow-control=off
/interface wireguard
add disabled=no listen-port=51820 mtu=1420 name=wg-vpn
/queue interface
set wg-vpn queue=no-queue
/interface ethernet switch
set switch1 cpu-flow-control=yes mirror-source=none mirror-target=none name=\
    switch1
/interface ethernet switch port
set ether1 default-vlan-id=auto vlan-header=leave-as-is vlan-mode=disabled
set ether2 default-vlan-id=auto vlan-header=leave-as-is vlan-mode=disabled
set ether3 default-vlan-id=auto vlan-header=leave-as-is vlan-mode=disabled
set ether4 default-vlan-id=auto vlan-header=leave-as-is vlan-mode=disabled
set ether5 default-vlan-id=auto vlan-header=leave-as-is vlan-mode=disabled
set switch1-cpu default-vlan-id=auto vlan-header=leave-as-is vlan-mode=\
    disabled
/interface ethernet switch port-isolation
set ether1 !forwarding-override
set ether2 !forwarding-override
set ether3 !forwarding-override
set ether4 !forwarding-override
set ether5 !forwarding-override
set switch1-cpu !forwarding-override
/interface list
set [ find name=all ] comment="contains all interfaces" exclude="" include="" \
    name=all
set [ find name=none ] comment="contains no interfaces" exclude="" include="" \
    name=none
set [ find name=dynamic ] comment="contains dynamic interfaces" exclude="" \
    include="" name=dynamic
set [ find name=static ] comment="contains static interfaces" exclude="" \
    include="" name=static
add exclude="" include="" name=LAN
/interface lte apn
set [ find default=yes ] add-default-route=yes apn=internet authentication=\
    none default-route-distance=2 ip-type=auto name=default use-network-apn=\
    yes use-peer-dns=yes
/interface macsec profile
set [ find default-name=default ] ciphers=aes-gcm-128 name=default \
    server-priority=10
/ip dhcp-client option
set clientid_duid code=61 name=clientid_duid value="0xff\$(CLIENT_DUID)"
set clientid code=61 name=clientid value="0x01\$(CLIENT_MAC)"
set hostname code=12 name=hostname value="\$(HOSTNAME)"
/ip hotspot profile
set [ find default=yes ] dns-name="" hotspot-address=0.0.0.0 html-directory=\
    hotspot html-directory-override="" http-cookie-lifetime=3d http-proxy=\
    0.0.0.0:0 install-hotspot-queue=no login-by=cookie,http-chap name=default \
    smtp-server=0.0.0.0 split-user-domain=no use-radius=no
/ip hotspot user profile
set [ find default=yes ] add-mac-cookie=yes address-list="" idle-timeout=none \
    !insert-queue-before keepalive-timeout=2m mac-cookie-timeout=3d name=\
    default !parent-queue !queue-type shared-users=1 status-autorefresh=1m \
    transparent-proxy=no
/ip ipsec mode-config
set [ find default=yes ] name=request-only responder=no use-responder-dns=\
    exclusively
/ip ipsec policy group
set [ find default=yes ] name=default
/ip ipsec profile
set [ find default=yes ] dh-group=modp2048,modp1024 dpd-interval=8s \
    dpd-maximum-failures=4 enc-algorithm=aes-128,3des hash-algorithm=sha1 \
    lifetime=1d name=default nat-traversal=yes ppk=no proposal-check=obey
/ip ipsec proposal
set [ find default=yes ] auth-algorithms=sha1 disabled=no enc-algorithms=\
    aes-256-cbc,aes-192-cbc,aes-128-cbc lifetime=30m name=default pfs-group=\
    modp1024
/ip pool
add name=dhcp_pool ranges=192.168.10.50-192.168.10.100
add name=ovpn-pool ranges=192.168.8.10-192.168.8.30
/ip smb users
set [ find default=yes ] disabled=no name=guest read-only=yes
/ipv6 dhcp-relay option
set client_mac code=79 name=client_mac only-if-mac-available=yes value=\
    "0x0001\$(CLIENT_MAC)"
/ppp profile
set *0 address-list="" !bridge !bridge-horizon bridge-learning=default \
    !bridge-path-cost !bridge-port-priority !bridge-port-trusted \
    !bridge-port-vid change-tcp-mss=yes !dhcpv6-lease-time !dhcpv6-use-radius \
    !dns-server !idle-timeout !incoming-filter !insert-queue-before \
    !interface-list !local-address name=default on-down="" on-up="" only-one=\
    default !outgoing-filter !parent-queue !queue-type !rate-limit \
    !remote-address !remote-ipv6-prefix-reuse !session-timeout \
    use-compression=default use-encryption=default use-ipv6=yes use-mpls=\
    default use-upnp=default !wins-server
add address-list="" !bridge !bridge-horizon bridge-learning=default \
    !bridge-path-cost !bridge-port-priority !bridge-port-trusted \
    !bridge-port-vid change-tcp-mss=default !dhcpv6-lease-time \
    !dhcpv6-use-radius dns-server=192.168.10.1 !idle-timeout !incoming-filter \
    !insert-queue-before !interface-list local-address=192.168.8.250 name=\
    ovpn-profile on-down="" on-up="" only-one=default !outgoing-filter \
    !parent-queue !queue-type !rate-limit remote-address=ovpn-pool \
    !remote-ipv6-prefix-reuse !session-timeout use-compression=default \
    use-encryption=yes use-ipv6=yes use-mpls=default use-upnp=default \
    !wins-server
set *FFFFFFFE address-list="" !bridge !bridge-horizon bridge-learning=default \
    !bridge-path-cost !bridge-port-priority !bridge-port-trusted \
    !bridge-port-vid change-tcp-mss=yes !dhcpv6-lease-time !dhcpv6-use-radius \
    !dns-server !idle-timeout !incoming-filter !insert-queue-before \
    !interface-list !local-address name=default-encryption on-down="" on-up=\
    "" only-one=default !outgoing-filter !parent-queue !queue-type \
    !rate-limit !remote-address !remote-ipv6-prefix-reuse !session-timeout \
    use-compression=default use-encryption=yes use-ipv6=yes use-mpls=default \
    use-upnp=default !wins-server
/queue type
set 0 kind=pfifo name=default pfifo-limit=50
set 1 kind=pfifo name=ethernet-default pfifo-limit=50
set 2 kind=sfq name=wireless-default sfq-allot=1514 sfq-perturb=5
set 3 kind=red name=synchronous-default red-avg-packet=1000 red-burst=20 \
    red-limit=60 red-max-threshold=50 red-min-threshold=10
set 4 kind=sfq name=hotspot-default sfq-allot=1514 sfq-perturb=5
add cake-ack-filter=none cake-bandwidth=0bps cake-diffserv=diffserv3 \
    cake-flowmode=triple-isolate cake-nat=no cake-overhead=0 \
    cake-overhead-scheme="" cake-rtt=100ms cake-wash=no kind=cake name=\
    cake-download
add cake-ack-filter=none cake-bandwidth=0bps cake-diffserv=diffserv3 \
    cake-flowmode=triple-isolate cake-nat=no cake-overhead=0 \
    cake-overhead-scheme="" cake-rtt=100ms cake-wash=no kind=cake name=\
    cake-upload
set 7 kind=pcq name=pcq-upload-default pcq-burst-rate=0 pcq-burst-threshold=0 \
    pcq-burst-time=10s pcq-classifier=src-address pcq-dst-address-mask=32 \
    pcq-dst-address6-mask=128 pcq-limit=50KiB pcq-rate=0 \
    pcq-src-address-mask=32 pcq-src-address6-mask=128 pcq-total-limit=2000KiB
set 8 kind=pcq name=pcq-download-default pcq-burst-rate=0 \
    pcq-burst-threshold=0 pcq-burst-time=10s pcq-classifier=dst-address \
    pcq-dst-address-mask=32 pcq-dst-address6-mask=128 pcq-limit=50KiB \
    pcq-rate=0 pcq-src-address-mask=32 pcq-src-address6-mask=128 \
    pcq-total-limit=2000KiB
set 9 kind=none name=only-hardware-queue
set 10 kind=mq-pfifo mq-pfifo-limit=50 name=multi-queue-ethernet-default
set 11 kind=pfifo name=default-small pfifo-limit=10
/queue interface
set ether1 queue=only-hardware-queue
set ether2 queue=only-hardware-queue
set ether3 queue=only-hardware-queue
set ether4 queue=only-hardware-queue
set ether5 queue=only-hardware-queue
/routing bgp template
set default name=default
/snmp community
set [ find default=yes ] addresses=::/0 authentication-protocol=MD5 disabled=\
    no encryption-protocol=DES name=public read-access=yes security=none \
    write-access=no
/system logging action
set 0 memory-lines=1000 memory-stop-on-full=no name=memory target=memory
set 1 disk-file-count=2 disk-file-name=flash/log disk-lines-per-file=1000 \
    disk-stop-on-full=no name=disk target=disk
set 2 name=echo remember=yes target=echo
set 3 add-topics-string=no name=remote remote=0.0.0.0 remote-log-format=\
    syslog remote-port=514 remote-protocol=udp src-address=0.0.0.0 \
    syslog-facility=daemon syslog-severity=auto syslog-time-format=bsd-syslog \
    target=remote vrf=main
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
/user group
set read name=read policy="local,telnet,ssh,reboot,read,test,winbox,password,w\
    eb,sniff,sensitive,api,romon,rest-api,!ftp,!write,!policy" skin=default
set write name=write policy="local,telnet,ssh,reboot,read,write,test,winbox,pa\
    ssword,web,sniff,sensitive,api,romon,rest-api,!ftp,!policy" skin=default
set full name=full policy="local,telnet,ssh,ftp,reboot,read,write,policy,test,\
    winbox,password,web,sniff,sensitive,api,romon,rest-api" skin=default
/certificate settings
set builtin-trust-store=default crl-download=no crl-store=ram crl-use=no
/console settings
set log-script-errors=yes sanitize-names=no tab-width=4
/disk settings
set auto-media-interface=none auto-media-sharing=no auto-smb-sharing=no \
    auto-smb-user=guest default-mount-point-template="[slot]"
/ip smb
set comment=MikrotikSMB domain=MSHOME enabled=auto interfaces=all
/interface bridge
add ageing-time=5m arp=enabled arp-timeout=auto auto-mac=yes comment=\
    "LAN bridge" !dhcp-agent-circuit-id !dhcp-agent-remote-id dhcp-snooping=\
    no !dhcpv6-agent-circuit-id !dhcpv6-agent-remote-id dhcpv6-snooping=no \
    disabled=no fast-forward=yes forward-delay=15s igmp-snooping=no \
    max-learned-entries=auto max-message-age=20s mlag-heartbeat=5s \
    mlag-peer-port=none mlag-priority=128 mtu=auto name=bridge \
    port-cost-mode=long priority=0x8000 protocol-mode=rstp ra-guard=no \
    transmit-hold-count=6 vlan-filtering=no
/queue interface
set bridge queue=no-queue
/interface bridge port
add auto-isolate=no bpdu-guard=no bridge=bridge broadcast-flood=yes disabled=\
    no edge=auto fast-leave=no frame-types=admit-all horizon=none hw=yes \
    ingress-filtering=yes interface=ether2 !internal-path-cost learn=auto \
    multicast-router=temporary-query mvrp-applicant-state=normal-participant \
    mvrp-registrar-state=normal !path-cost point-to-point=auto priority=0x80 \
    pvid=1 restricted-role=no restricted-tcn=no tag-stacking=no trusted=no \
    trusted-dhcpv6=no trusted-ra=no unknown-multicast-flood=yes \
    unknown-unicast-flood=yes
add auto-isolate=no bpdu-guard=no bridge=bridge broadcast-flood=yes disabled=\
    no edge=auto fast-leave=no frame-types=admit-all horizon=none hw=yes \
    ingress-filtering=yes interface=ether3 !internal-path-cost learn=auto \
    multicast-router=temporary-query mvrp-applicant-state=normal-participant \
    mvrp-registrar-state=normal !path-cost point-to-point=auto priority=0x80 \
    pvid=1 restricted-role=no restricted-tcn=no tag-stacking=no trusted=no \
    trusted-dhcpv6=no trusted-ra=no unknown-multicast-flood=yes \
    unknown-unicast-flood=yes
add auto-isolate=no bpdu-guard=no bridge=bridge broadcast-flood=yes disabled=\
    no edge=auto fast-leave=no frame-types=admit-all horizon=none hw=yes \
    ingress-filtering=yes interface=ether4 !internal-path-cost learn=auto \
    multicast-router=temporary-query mvrp-applicant-state=normal-participant \
    mvrp-registrar-state=normal !path-cost point-to-point=auto priority=0x80 \
    pvid=1 restricted-role=no restricted-tcn=no tag-stacking=no trusted=no \
    trusted-dhcpv6=no trusted-ra=no unknown-multicast-flood=yes \
    unknown-unicast-flood=yes
add auto-isolate=no bpdu-guard=no bridge=bridge broadcast-flood=yes disabled=\
    no edge=auto fast-leave=no frame-types=admit-all horizon=none hw=yes \
    ingress-filtering=yes interface=ether5 !internal-path-cost learn=auto \
    multicast-router=temporary-query mvrp-applicant-state=normal-participant \
    mvrp-registrar-state=normal !path-cost point-to-point=auto priority=0x80 \
    pvid=1 restricted-role=no restricted-tcn=no tag-stacking=no trusted=no \
    trusted-dhcpv6=no trusted-ra=no unknown-multicast-flood=yes \
    unknown-unicast-flood=yes
/interface bridge settings
set allow-fast-path=yes use-ip-firewall=no use-ip-firewall-for-pppoe=no \
    use-ip-firewall-for-vlan=no
/ip firewall connection tracking
set enabled=auto generic-timeout=10m icmp-timeout=10s liberal-tcp-tracking=no \
    loose-tcp-tracking=yes tcp-close-timeout=10s tcp-close-wait-timeout=10s \
    tcp-established-timeout=1d tcp-fin-wait-timeout=10s tcp-last-ack-timeout=\
    10s tcp-max-retrans-timeout=5m tcp-syn-received-timeout=5s \
    tcp-syn-sent-timeout=5s tcp-time-wait-timeout=10s tcp-unacked-timeout=5m \
    udp-stream-timeout=3m udp-timeout=30s
/ip neighbor discovery-settings
set add-dns-entries=no add-dns-entries-suffix=lan discover-interface-list=\
    static discover-interval=30s dying-gasp=no lldp-mac-phy-config=no \
    lldp-max-frame-size=no lldp-med=yes lldp-med-net-policy-vlan=disabled \
    lldp-vlan-info=no mode=tx-and-rx protocol=cdp,lldp,mndp
/ip settings
set accept-redirects=no accept-source-route=no allow-fast-path=yes \
    arp-timeout=30s icmp-errors-use-inbound-interface-address=no \
    icmp-rate-limit=10 icmp-rate-mask=0x1818 ip-forward=yes \
    ipv4-fragment-time=3 ipv4-high-fragment-thresh=1024.0KiB \
    ipv4-multipath-hash-policy=l3 max-neighbor-entries=4096 rp-filter=loose \
    secure-redirects=yes send-redirects=yes tcp-syncookies=no tcp-timestamps=\
    random-offset
/ipv6 settings
set accept-redirects=yes-if-forwarding-disabled accept-router-advertisements=\
    yes-if-forwarding-disabled accept-router-advertisements-on=all \
    allow-fast-path=yes disable-ipv6=no disable-link-local-address=no \
    forward=yes max-neighbor-entries=2048 min-neighbor-entries=512 \
    multipath-hash-policy=l3 soft-max-neighbor-entries=1024 \
    stale-neighbor-detect-interval=30 stale-neighbor-timeout=60
/interface detect-internet
set detect-interface-list=none internet-interface-list=none \
    lan-interface-list=none request-interval=2m wan-interface-list=none
/interface l2tp-server server
set accept-proto-version=all accept-pseudowire-type=all allow-fast-path=no \
    authentication=pap,chap,mschap1,mschap2 caller-id-type=ip-address \
    default-profile=default-encryption enabled=no keepalive-timeout=30 \
    l2tpv3-circuit-id="" l2tpv3-cookie-length=0 l2tpv3-digest-hash=md5 \
    !l2tpv3-ether-interface-list max-mru=1450 max-mtu=1450 max-sessions=\
    unlimited mrru=disabled one-session-per-host=no use-ipsec=no
/interface list member
add disabled=no interface=wg-vpn list=LAN
add disabled=no interface=bridge list=LAN
/interface lte settings
set esim-channel=auto firmware-path=firmware link-recovery-timer=120 mode=\
    auto
/interface ovpn-server server
add auth=sha256 certificate=server-certificate cipher=\
    aes128-cbc,aes128-gcm,aes256-gcm default-profile=ovpn-profile disabled=no \
    enable-tun-ipv6=no ipv6-prefix-len=64 keepalive-timeout=60 mac-address=\
    FE:92:07:49:FF:30 max-mtu=1500 mode=ip name=ovpn-server netmask=24 port=\
    1194 protocol=udp push-routes="" push-routes-ipv6="" redirect-gateway=\
    disabled reneg-sec=3600 require-client-certificate=yes tls-version=any \
    tun-server-ipv6=:: user-auth-method=pap vrf=main
/interface pptp-server server
# PPTP connections are considered unsafe, it is suggested to use a more modern VPN protocol instead
set authentication=mschap1,mschap2 default-profile=default-encryption \
    enabled=no keepalive-timeout=30 max-mru=1450 max-mtu=1450 mrru=disabled
/interface sstp-server server
set authentication=pap,chap,mschap1,mschap2 certificate=none ciphers=\
    aes256-sha,aes256-gcm-sha384 default-profile=default enabled=no \
    keepalive-timeout=60 max-mru=1500 max-mtu=1500 mrru=disabled pfs=no port=\
    443 tls-version=any verify-client-certificate=no
/interface wifi cap
set enabled=no
/interface wifi capsman
set enabled=no
/interface wireguard peers
add allowed-address=10.0.0.4/32 client-allowed-address=::/0 client-endpoint=\
    "" comment=Hippo disabled=no endpoint-address="" endpoint-port=0 \
    interface=wg-vpn name=Hippo public-key=\
    "Pz811nCCC66nhXax/y67cGg+/l0xSiDrjyl1VM6BShU="
add allowed-address=10.0.0.2/32 client-allowed-address=::/0 client-endpoint=\
    "" comment="Tunnel Host C Server.it" disabled=no endpoint-address="" \
    endpoint-port=0 interface=wg-vpn name=FamilyCloud public-key=\
    "4csaRdMAabMK+qFjDusL8wzBkk1QemPBwtcGfkZX7Vs="
add allowed-address=10.0.0.3/32 client-allowed-address="" client-endpoint="" \
    comment="Client Fedora" disabled=no endpoint-address="" endpoint-port=0 \
    interface=wg-vpn name=FedoraDELL public-key=\
    "bFdxYJmB6rIfmqaXJStwDS9/dvAmiMigkUiOJDBvWho="
add allowed-address=10.0.0.5/32 client-allowed-address="" client-endpoint="" \
    comment="Home Desk" disabled=no endpoint-address="" endpoint-port=0 \
    interface=wg-vpn name=Home-desk public-key=\
    "lr0Uct5TcaU9yLM3dp9LsOipshV6YsT5VHVODSKlIAs="
add allowed-address=10.0.0.10/32 client-allowed-address="" client-endpoint="" \
    comment="Client WSL Lenovo" disabled=no endpoint-address="" \
    endpoint-port=0 interface=wg-vpn name=WSL public-key=\
    "S3A8HCpR1RPrC+dBydTD1AMbT5WhcdnqbOm/lcnm0SA="
/ip address
add address=192.168.10.1/24 comment="LAN 10.x gateway" disabled=no interface=\
    bridge network=192.168.10.0
add address=10.0.0.1/24 disabled=no interface=wg-vpn network=10.0.0.0
/ip cloud
set back-to-home-vpn=revoked-and-disabled ddns-enabled=yes \
    ddns-update-interval=none update-time=yes
/ip cloud advanced
set use-local-address=no
/ip dhcp-client
add add-default-route=yes allow-reconfigure=no check-gateway=none comment=\
    "WAN DHCP da IliadBox" default-route-distance=1 default-route-tables=\
    default dhcp-options=hostname,clientid disabled=no interface=ether1 name=\
    ether1 use-broadcast=both use-peer-dns=no use-peer-ntp=no
/ip dhcp-server
add add-dns-entries-suffix=lan address-lists="" address-pool=dhcp_pool \
    disabled=no dynamic-lease-identifiers=client-mac,client-id interface=\
    bridge lease-script="" lease-time=1d name=dhcp1 support-broadband-tr101=\
    no use-radius=no use-reconfigure=no
/ip dhcp-server config
set accounting=yes interim-update=0s radius-password=empty store-leases-disk=\
    5m
/ip dhcp-server lease
add address=192.168.10.245 address-lists="" agent-circuit-id="" \
    agent-remote-id="" !allow-dual-stack-queue client-id=1:0:d8:61:a3:80:bf \
    comment=DESKTOP dhcp-option="" disabled=no !insert-queue-before \
    mac-address=00:D8:61:A3:80:BF !parent-queue !queue-type server=dhcp1
add address=192.168.10.250 address-lists="" agent-circuit-id="" \
    agent-remote-id="" !allow-dual-stack-queue client-id=1:0:11:32:64:1a:ad \
    comment="SYNOLOGY NAS" dhcp-option="" disabled=no !insert-queue-before \
    mac-address=00:11:32:64:1A:AD !parent-queue !queue-type server=dhcp1
add address=192.168.10.246 address-lists="" agent-circuit-id="" \
    agent-remote-id="" !allow-dual-stack-queue client-id=1:10:e7:c6:d3:31:b9 \
    comment="Stampante HP" dhcp-option="" disabled=no !insert-queue-before \
    mac-address=10:E7:C6:D3:31:B9 !parent-queue !queue-type server=dhcp1
add address=192.168.10.230 address-lists="" agent-circuit-id="" \
    agent-remote-id="" !allow-dual-stack-queue client-id=1:b8:3a:8:cb:23:78 \
    comment="ACCESS POINT TENDA" dhcp-option="" disabled=no \
    !insert-queue-before mac-address=B8:3A:08:CB:23:78 !parent-queue \
    !queue-type server=dhcp1
add address=192.168.10.200 address-lists="" agent-circuit-id="" \
    agent-remote-id="" !allow-dual-stack-queue client-id=1:7c:d3:a:18:3a:9b \
    comment=ESXI dhcp-option="" disabled=no !insert-queue-before mac-address=\
    7C:D3:0A:18:3A:9B !parent-queue !queue-type server=dhcp1
add address=192.168.10.240 address-lists="" agent-circuit-id="" \
    agent-remote-id="" !allow-dual-stack-queue client-id=1:6c:4c:bc:ff:40:9a \
    dhcp-option="" disabled=no !insert-queue-before mac-address=\
    6C:4C:BC:FF:40:9A !parent-queue !queue-type server=dhcp1
add address=192.168.10.210 address-lists="" agent-circuit-id="" \
    agent-remote-id="" !allow-dual-stack-queue client-id=1:bc:24:11:71:5f:9f \
    comment="VM HUB-1" dhcp-option="" disabled=no !insert-queue-before \
    mac-address=BC:24:11:71:5F:9F !parent-queue !queue-type server=dhcp1
/ip dhcp-server network
add address=192.168.10.0/24 caps-manager="" dhcp-option="" dns-server=\
    192.168.10.1 domain=home gateway=192.168.10.1 !next-server ntp-server=\
    193.204.114.232,193.204.114.233 wins-server=""
/ip dns
set address-list-extra-time=0s allow-remote-requests=yes cache-max-ttl=1w \
    cache-size=40000KiB doh-max-concurrent-queries=50 \
    doh-max-server-connections=5 doh-timeout=5s max-concurrent-queries=100 \
    max-concurrent-tcp-sessions=20 max-udp-packet-size=4096 \
    mdns-repeat-ifaces="" query-server-timeout=2s query-total-timeout=10s \
    servers="2606:4700:4700::1111,2606:4700:4700::1001,2620:fe::fe,2620:fe::9,\
    1.1.1.1,9.9.9.9" use-doh-server="" verify-doh-cert=no vrf=main
/ip dns adlist
add disabled=no ssl-verify=no url=\
    https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
add disabled=no ssl-verify=no url=https://v.firebog.net/hosts/AdguardDNS.txt
add disabled=no ssl-verify=no url="https://raw.githubusercontent.com/andyts93/\
    pihole-italian-list/master/adlist.txt"
add disabled=no ssl-verify=no url=https://adaway.org/hosts.txt
add disabled=no ssl-verify=no url=https://small.oisd.nl/
add disabled=no ssl-verify=no url="https://raw.githubusercontent.com/anudeepND\
    /blacklist/master/adservers.txt"
/ip dns static
add comment="Whitelist Google Content" disabled=no forward-to=1.1.1.1 name=\
    googleusercontent.com ttl=1d type=FWD
add comment="Whitelist Spotify" disabled=no forward-to=1.1.1.1 name=\
    spotify.com ttl=1d type=FWD
add address=192.168.10.200 comment="Nome breve ProxMox" disabled=no name=\
    prox.home ttl=1h type=A
add address=192.168.10.250 comment="Nome breve NAS" disabled=no name=\
    syno.home ttl=1h type=A
add address=192.168.10.210 comment="Playnite Sync" disabled=no name=\
    playnite.home ttl=1d type=A
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=\
    about-scheme ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=\
    chrome-extension-scheme ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=\
    chrome-scheme ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=\
    edge-scheme ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=\
    moz-extension-scheme ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=\
    opera-scheme ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=\
    vivaldi-scheme ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=\
    wyciwyg-scheme ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=agofa.org \
    ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=amazon.com \
    ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=amazon.it \
    ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=\
    brilliant.org ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=\
    digitalocean.com ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=\
    discordapp.com ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=docker.com \
    ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=\
    getpocket.com ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=\
    giallozafferano.com ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=github.com \
    ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=gitlab.com \
    ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=google.com \
    ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=\
    howlongtobeat.com ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=ilpost.it \
    ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=imdb.com \
    ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=imgur.com \
    ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=\
    isthereanydeal.com ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=n26.com \
    ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=ocaml.org \
    ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=osmand.net \
    ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=\
    primevideo.com ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=\
    projecteuler.net ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=\
    protondb.com ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=reddit.com \
    ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=\
    serverfault.com ttl=1d type=FWD
add comment=added-by-whitelist disabled=no forward-to=1.1.1.1 name=slack.com \
    ttl=1d type=FWD
add address=192.168.10.210 comment=\
    "DR test - dominio locale .home verso la VM" disabled=no regexp=\
    ".*\\.home\$" ttl=1d type=A
/ip firewall filter
add action=accept chain=input comment="INPUT: Accetta stabiliti/untracked" \
    !connection-bytes !connection-limit !connection-mark \
    !connection-nat-state !connection-rate connection-state=\
    established,related,untracked !connection-type !content disabled=no !dscp \
    !dst-address !dst-address-list !dst-address-type !dst-limit !dst-port \
    !fragment !icmp-options !in-bridge-port !in-bridge-port-list \
    !in-interface !in-interface-list !ingress-priority !ipsec-policy \
    !ipv4-options !layer7-protocol !limit log=no log-prefix="" !nth \
    !out-bridge-port !out-bridge-port-list !out-interface !out-interface-list \
    !packet-mark !packet-size !per-connection-classifier !port !priority \
    !protocol !psd !random !routing-mark !src-address !src-address-list \
    !src-address-type !src-mac-address !src-port !tcp-flags !tcp-mss !time \
    !tls-host !tos !ttl
add action=drop chain=input comment="INPUT: Drop invalidi" !connection-bytes \
    !connection-limit !connection-mark !connection-nat-state !connection-rate \
    connection-state=invalid !connection-type !content disabled=no !dscp \
    !dst-address !dst-address-list !dst-address-type !dst-limit !dst-port \
    !fragment !icmp-options !in-bridge-port !in-bridge-port-list \
    !in-interface !in-interface-list !ingress-priority !ipsec-policy \
    !ipv4-options !layer7-protocol !limit log=no log-prefix="" !nth \
    !out-bridge-port !out-bridge-port-list !out-interface !out-interface-list \
    !packet-mark !packet-size !per-connection-classifier !port !priority \
    !protocol !psd !random !routing-mark !src-address !src-address-list \
    !src-address-type !src-mac-address !src-port !tcp-flags !tcp-mss !time \
    !tls-host !tos !ttl
add action=accept chain=input comment="INPUT: ICMP (Ping) limitato" \
    !connection-bytes !connection-limit !connection-mark \
    !connection-nat-state !connection-rate !connection-state !connection-type \
    !content disabled=no !dscp !dst-address !dst-address-list \
    !dst-address-type !dst-limit !dst-port !fragment !icmp-options \
    !in-bridge-port !in-bridge-port-list !in-interface !in-interface-list \
    !ingress-priority !ipsec-policy !ipv4-options !layer7-protocol limit=\
    5,10:packet log=no log-prefix="" !nth !out-bridge-port \
    !out-bridge-port-list !out-interface !out-interface-list !packet-mark \
    !packet-size !per-connection-classifier !port !priority protocol=icmp \
    !psd !random !routing-mark !src-address !src-address-list \
    !src-address-type !src-mac-address !src-port !tcp-flags !tcp-mss !time \
    !tls-host !tos !ttl
add action=accept chain=input comment="INPUT: LAN -> Router" \
    !connection-bytes !connection-limit !connection-mark \
    !connection-nat-state !connection-rate !connection-state !connection-type \
    !content disabled=no !dscp !dst-address !dst-address-list \
    !dst-address-type !dst-limit !dst-port !fragment !icmp-options \
    !in-bridge-port !in-bridge-port-list in-interface=bridge \
    !in-interface-list !ingress-priority !ipsec-policy !ipv4-options \
    !layer7-protocol !limit log=no log-prefix="" !nth !out-bridge-port \
    !out-bridge-port-list !out-interface !out-interface-list !packet-mark \
    !packet-size !per-connection-classifier !port !priority !protocol !psd \
    !random !routing-mark !src-address !src-address-list !src-address-type \
    !src-mac-address !src-port !tcp-flags !tcp-mss !time !tls-host !tos !ttl
add action=accept chain=input comment="INPUT: Gestione remota WAN" \
    !connection-bytes !connection-limit !connection-mark \
    !connection-nat-state !connection-rate connection-state=new \
    !connection-type !content disabled=yes !dscp !dst-address \
    !dst-address-list !dst-address-type !dst-limit dst-port=2222,18291 \
    !fragment !icmp-options !in-bridge-port !in-bridge-port-list \
    in-interface=ether1 !in-interface-list !ingress-priority !ipsec-policy \
    !ipv4-options !layer7-protocol !limit log=no log-prefix="" !nth \
    !out-bridge-port !out-bridge-port-list !out-interface !out-interface-list \
    !packet-mark !packet-size !per-connection-classifier !port !priority \
    protocol=tcp !psd !random !routing-mark !src-address !src-address-list \
    !src-address-type !src-mac-address !src-port !tcp-flags !tcp-mss !time \
    !tls-host !tos !ttl
add action=accept chain=input comment="INPUT: Gestione LAN" !connection-bytes \
    !connection-limit !connection-mark !connection-nat-state !connection-rate \
    !connection-state !connection-type !content disabled=no !dscp \
    !dst-address !dst-address-list !dst-address-type !dst-limit dst-port=\
    2222,18291 !fragment !icmp-options !in-bridge-port !in-bridge-port-list \
    !in-interface !in-interface-list !ingress-priority !ipsec-policy \
    !ipv4-options !layer7-protocol !limit log=no log-prefix="" !nth \
    !out-bridge-port !out-bridge-port-list !out-interface !out-interface-list \
    !packet-mark !packet-size !per-connection-classifier !port !priority \
    protocol=tcp !psd !random !routing-mark src-address=192.168.10.0/24 \
    !src-address-list !src-address-type !src-mac-address !src-port !tcp-flags \
    !tcp-mss !time !tls-host !tos !ttl
add action=accept chain=input comment="INPUT: WireGuard UDP" \
    !connection-bytes !connection-limit !connection-mark \
    !connection-nat-state !connection-rate !connection-state !connection-type \
    !content disabled=no !dscp !dst-address !dst-address-list \
    !dst-address-type !dst-limit dst-port=51820 !fragment !icmp-options \
    !in-bridge-port !in-bridge-port-list in-interface=ether1 \
    !in-interface-list !ingress-priority !ipsec-policy !ipv4-options \
    !layer7-protocol !limit log=no log-prefix="" !nth !out-bridge-port \
    !out-bridge-port-list !out-interface !out-interface-list !packet-mark \
    !packet-size !per-connection-classifier !port !priority protocol=udp !psd \
    !random !routing-mark !src-address !src-address-list !src-address-type \
    !src-mac-address !src-port !tcp-flags !tcp-mss !time !tls-host !tos !ttl
add action=accept chain=input comment="VPN: Porta OpenVPN UDP" \
    !connection-bytes !connection-limit !connection-mark \
    !connection-nat-state !connection-rate !connection-state !connection-type \
    !content disabled=no !dscp !dst-address !dst-address-list \
    !dst-address-type !dst-limit dst-port=1194 !fragment !icmp-options \
    !in-bridge-port !in-bridge-port-list in-interface=ether1 \
    !in-interface-list !ingress-priority !ipsec-policy !ipv4-options \
    !layer7-protocol !limit log=no log-prefix="" !nth !out-bridge-port \
    !out-bridge-port-list !out-interface !out-interface-list !packet-mark \
    !packet-size !per-connection-classifier !port !priority protocol=udp !psd \
    !random !routing-mark !src-address !src-address-list !src-address-type \
    !src-mac-address !src-port !tcp-flags !tcp-mss !time !tls-host !tos !ttl
add action=accept chain=input comment="VPN: Gestione router da IP VPN" \
    !connection-bytes !connection-limit !connection-mark \
    !connection-nat-state !connection-rate !connection-state !connection-type \
    !content disabled=no !dscp !dst-address !dst-address-list \
    !dst-address-type !dst-limit !dst-port !fragment !icmp-options \
    !in-bridge-port !in-bridge-port-list !in-interface !in-interface-list \
    !ingress-priority !ipsec-policy !ipv4-options !layer7-protocol !limit \
    log=no log-prefix="" !nth !out-bridge-port !out-bridge-port-list \
    !out-interface !out-interface-list !packet-mark !packet-size \
    !per-connection-classifier !port !priority !protocol !psd !random \
    !routing-mark src-address=192.168.8.0/24 !src-address-list \
    !src-address-type !src-mac-address !src-port !tcp-flags !tcp-mss !time \
    !tls-host !tos !ttl
add action=drop chain=input comment="INPUT: DROP FINALE WAN" \
    !connection-bytes !connection-limit !connection-mark \
    !connection-nat-state !connection-rate !connection-state !connection-type \
    !content disabled=no !dscp !dst-address !dst-address-list \
    !dst-address-type !dst-limit !dst-port !fragment !icmp-options \
    !in-bridge-port !in-bridge-port-list in-interface=ether1 \
    !in-interface-list !ingress-priority !ipsec-policy !ipv4-options \
    !layer7-protocol !limit log=yes log-prefix=WAN-DROP-MGMT !nth \
    !out-bridge-port !out-bridge-port-list !out-interface !out-interface-list \
    !packet-mark !packet-size !per-connection-classifier !port !priority \
    !protocol !psd !random !routing-mark !src-address !src-address-list \
    !src-address-type !src-mac-address !src-port !tcp-flags !tcp-mss !time \
    !tls-host !tos !ttl
add action=fasttrack-connection chain=forward comment=\
    "FORWARD: Fasttrack (Ottimizzazione CPU)" !connection-bytes \
    !connection-limit !connection-mark !connection-nat-state !connection-rate \
    connection-state=established,related !connection-type !content disabled=\
    no !dscp !dst-address !dst-address-list !dst-address-type !dst-limit \
    !dst-port !fragment !icmp-options !in-bridge-port !in-bridge-port-list \
    !in-interface !in-interface-list !ingress-priority !ipsec-policy \
    !ipv4-options !layer7-protocol !limit log=no log-prefix="" !nth \
    !out-bridge-port !out-bridge-port-list !out-interface !out-interface-list \
    !packet-mark !packet-size !per-connection-classifier !port !priority \
    !protocol !psd !random !routing-mark !src-address !src-address-list \
    !src-address-type !src-mac-address !src-port !tcp-flags !tcp-mss !time \
    !tls-host !tos !ttl
add action=accept chain=forward comment="FORWARD: Accetta WebDAV da VPS" \
    !connection-bytes !connection-limit !connection-mark \
    connection-nat-state=dstnat !connection-rate connection-state=new \
    !connection-type !content disabled=yes !dscp !dst-address \
    !dst-address-list !dst-address-type !dst-limit !dst-port !fragment \
    !icmp-options !in-bridge-port !in-bridge-port-list in-interface=ether1 \
    !in-interface-list !ingress-priority !ipsec-policy !ipv4-options \
    !layer7-protocol !limit log=no log-prefix="" !nth !out-bridge-port \
    !out-bridge-port-list !out-interface !out-interface-list !packet-mark \
    !packet-size !per-connection-classifier !port !priority !protocol !psd \
    !random !routing-mark src-address=185.198.244.21 !src-address-list \
    !src-address-type !src-mac-address !src-port !tcp-flags !tcp-mss !time \
    !tls-host !tos !ttl
add action=accept chain=forward comment="FORWARD: Accetta SMB da VPS" \
    !connection-bytes !connection-limit !connection-mark \
    connection-nat-state=dstnat !connection-rate connection-state=new \
    !connection-type !content disabled=yes !dscp !dst-address \
    !dst-address-list !dst-address-type !dst-limit !dst-port !fragment \
    !icmp-options !in-bridge-port !in-bridge-port-list in-interface=ether1 \
    !in-interface-list !ingress-priority !ipsec-policy !ipv4-options \
    !layer7-protocol !limit log=no log-prefix="" !nth !out-bridge-port \
    !out-bridge-port-list !out-interface !out-interface-list !packet-mark \
    !packet-size !per-connection-classifier !port !priority !protocol !psd \
    !random !routing-mark src-address=185.198.244.21 !src-address-list \
    !src-address-type !src-mac-address !src-port !tcp-flags !tcp-mss !time \
    !tls-host !tos !ttl
add action=accept chain=forward comment="SSHFS WAN VPS -> Synology" \
    !connection-bytes !connection-limit !connection-mark \
    !connection-nat-state !connection-rate !connection-state !connection-type \
    !content disabled=yes !dscp dst-address=192.168.10.250 !dst-address-list \
    !dst-address-type !dst-limit dst-port=24 !fragment !icmp-options \
    !in-bridge-port !in-bridge-port-list !in-interface !in-interface-list \
    !ingress-priority !ipsec-policy !ipv4-options !layer7-protocol !limit \
    log=no log-prefix="" !nth !out-bridge-port !out-bridge-port-list \
    !out-interface !out-interface-list !packet-mark !packet-size \
    !per-connection-classifier !port !priority protocol=tcp !psd !random \
    !routing-mark src-address=185.198.244.21 !src-address-list \
    !src-address-type !src-mac-address !src-port !tcp-flags !tcp-mss !time \
    !tls-host !tos !ttl
add action=accept chain=forward comment="FORWARD: Accetta stabiliti" \
    !connection-bytes !connection-limit !connection-mark \
    !connection-nat-state !connection-rate connection-state=\
    established,related,untracked !connection-type !content disabled=no !dscp \
    !dst-address !dst-address-list !dst-address-type !dst-limit !dst-port \
    !fragment !icmp-options !in-bridge-port !in-bridge-port-list \
    !in-interface !in-interface-list !ingress-priority !ipsec-policy \
    !ipv4-options !layer7-protocol !limit log=no log-prefix="" !nth \
    !out-bridge-port !out-bridge-port-list !out-interface !out-interface-list \
    !packet-mark !packet-size !per-connection-classifier !port !priority \
    !protocol !psd !random !routing-mark !src-address !src-address-list \
    !src-address-type !src-mac-address !src-port !tcp-flags !tcp-mss !time \
    !tls-host !tos !ttl
add action=drop chain=forward comment="FORWARD: Drop invalidi" \
    !connection-bytes !connection-limit !connection-mark \
    !connection-nat-state !connection-rate connection-state=invalid \
    !connection-type !content disabled=no !dscp !dst-address \
    !dst-address-list !dst-address-type !dst-limit !dst-port !fragment \
    !icmp-options !in-bridge-port !in-bridge-port-list !in-interface \
    !in-interface-list !ingress-priority !ipsec-policy !ipv4-options \
    !layer7-protocol !limit log=no log-prefix="" !nth !out-bridge-port \
    !out-bridge-port-list !out-interface !out-interface-list !packet-mark \
    !packet-size !per-connection-classifier !port !priority !protocol !psd \
    !random !routing-mark !src-address !src-address-list !src-address-type \
    !src-mac-address !src-port !tcp-flags !tcp-mss !time !tls-host !tos !ttl
add action=accept chain=forward comment="VPN: Accesso a LAN da VPN" \
    !connection-bytes !connection-limit !connection-mark \
    !connection-nat-state !connection-rate !connection-state !connection-type \
    !content disabled=no !dscp !dst-address !dst-address-list \
    !dst-address-type !dst-limit !dst-port !fragment !icmp-options \
    !in-bridge-port !in-bridge-port-list !in-interface !in-interface-list \
    !ingress-priority !ipsec-policy !ipv4-options !layer7-protocol !limit \
    log=no log-prefix="" !nth !out-bridge-port !out-bridge-port-list \
    out-interface=bridge !out-interface-list !packet-mark !packet-size \
    !per-connection-classifier !port !priority !protocol !psd !random \
    !routing-mark src-address=192.168.8.0/24 !src-address-list \
    !src-address-type !src-mac-address !src-port !tcp-flags !tcp-mss !time \
    !tls-host !tos !ttl
add action=drop chain=forward comment="FORWARD: Drop WAN non nattata" \
    !connection-bytes !connection-limit !connection-mark \
    connection-nat-state=!dstnat !connection-rate connection-state=new \
    !connection-type !content disabled=no !dscp !dst-address \
    !dst-address-list !dst-address-type !dst-limit !dst-port !fragment \
    !icmp-options !in-bridge-port !in-bridge-port-list in-interface=ether1 \
    !in-interface-list !ingress-priority !ipsec-policy !ipv4-options \
    !layer7-protocol !limit log=no log-prefix="" !nth !out-bridge-port \
    !out-bridge-port-list !out-interface !out-interface-list !packet-mark \
    !packet-size !per-connection-classifier !port !priority !protocol !psd \
    !random !routing-mark !src-address !src-address-list !src-address-type \
    !src-mac-address !src-port !tcp-flags !tcp-mss !time !tls-host !tos !ttl
add action=drop chain=forward comment=\
    "DR test: nessuna email in uscita dalla VM" dst-port=25,465,587 protocol=\
    tcp src-address=192.168.10.210
add action=accept chain=forward comment="FORWARD: LAN -> WAN (Navigazione)" \
    !connection-bytes !connection-limit !connection-mark \
    !connection-nat-state !connection-rate !connection-state !connection-type \
    !content disabled=no !dscp !dst-address !dst-address-list \
    !dst-address-type !dst-limit !dst-port !fragment !icmp-options \
    !in-bridge-port !in-bridge-port-list in-interface=bridge \
    !in-interface-list !ingress-priority !ipsec-policy !ipv4-options \
    !layer7-protocol !limit log=no log-prefix="" !nth !out-bridge-port \
    !out-bridge-port-list out-interface=ether1 !out-interface-list \
    !packet-mark !packet-size !per-connection-classifier !port !priority \
    !protocol !psd !random !routing-mark !src-address !src-address-list \
    !src-address-type !src-mac-address !src-port !tcp-flags !tcp-mss !time \
    !tls-host !tos !ttl
add action=accept chain=forward comment=\
    "FORWARD: Traffico interno tra dispositivi LAN" !connection-bytes \
    !connection-limit !connection-mark !connection-nat-state !connection-rate \
    !connection-state !connection-type !content disabled=no !dscp \
    !dst-address !dst-address-list !dst-address-type !dst-limit !dst-port \
    !fragment !icmp-options !in-bridge-port !in-bridge-port-list \
    in-interface=bridge !in-interface-list !ingress-priority !ipsec-policy \
    !ipv4-options !layer7-protocol !limit log=no log-prefix="" !nth \
    !out-bridge-port !out-bridge-port-list out-interface=bridge \
    !out-interface-list !packet-mark !packet-size !per-connection-classifier \
    !port !priority !protocol !psd !random !routing-mark !src-address \
    !src-address-list !src-address-type !src-mac-address !src-port !tcp-flags \
    !tcp-mss !time !tls-host !tos !ttl
add action=drop chain=forward comment=\
    "FORWARD: DROP FINALE (Sicurezza totale WAN->LAN)" !connection-bytes \
    !connection-limit !connection-mark !connection-nat-state !connection-rate \
    !connection-state !connection-type !content disabled=no !dscp \
    !dst-address !dst-address-list !dst-address-type !dst-limit !dst-port \
    !fragment !icmp-options !in-bridge-port !in-bridge-port-list \
    in-interface=ether1 !in-interface-list !ingress-priority !ipsec-policy \
    !ipv4-options !layer7-protocol !limit log=yes log-prefix=WAN-DROP-LAN \
    !nth !out-bridge-port !out-bridge-port-list !out-interface \
    !out-interface-list !packet-mark !packet-size !per-connection-classifier \
    !port !priority !protocol !psd !random !routing-mark !src-address \
    !src-address-list !src-address-type !src-mac-address !src-port !tcp-flags \
    !tcp-mss !time !tls-host !tos !ttl
/ip firewall nat
add action=masquerade chain=srcnat comment="NAT verso IliadBox" \
    out-interface=ether1 !to-addresses !to-ports
add action=masquerade chain=srcnat comment=\
    "NAT: Permetti ai client VPN di parlare con la LAN" out-interface=bridge \
    src-address=192.168.8.0/24 !to-addresses !to-ports
add action=dst-nat chain=dstnat comment="WebDAV: VPS -> Synology" \
    !connection-bytes !connection-limit !connection-mark !connection-rate \
    !connection-type !content disabled=yes !dscp !dst-address \
    !dst-address-list !dst-address-type !dst-limit dst-port=5555 !fragment \
    !icmp-options !in-bridge-port !in-bridge-port-list in-interface=ether1 \
    !in-interface-list !ingress-priority !ipsec-policy !ipv4-options \
    !layer7-protocol !limit log=no log-prefix="" !nth !out-bridge-port \
    !out-bridge-port-list !out-interface !out-interface-list !packet-mark \
    !packet-size !per-connection-classifier !port !priority protocol=tcp !psd \
    !random !routing-mark src-address=185.198.244.21 !src-address-list \
    !src-address-type !src-mac-address !src-port !tcp-mss !time to-addresses=\
    192.168.10.250 to-ports=5555 !tos !ttl
add action=dst-nat chain=dstnat comment="SMB: VPS -> Synology" \
    !connection-bytes !connection-limit !connection-mark !connection-rate \
    !connection-type !content disabled=yes !dscp !dst-address \
    !dst-address-list !dst-address-type !dst-limit dst-port=445 !fragment \
    !icmp-options !in-bridge-port !in-bridge-port-list in-interface=ether1 \
    !in-interface-list !ingress-priority !ipsec-policy !ipv4-options \
    !layer7-protocol !limit log=no log-prefix="" !nth !out-bridge-port \
    !out-bridge-port-list !out-interface !out-interface-list !packet-mark \
    !packet-size !per-connection-classifier !port !priority protocol=tcp !psd \
    !random !routing-mark src-address=185.198.244.21 !src-address-list \
    !src-address-type !src-mac-address !src-port !tcp-mss !time to-addresses=\
    192.168.10.250 to-ports=445 !tos !ttl
add action=dst-nat chain=dstnat comment="SSHFS: WAN VPS -> Synology" \
    !connection-bytes !connection-limit !connection-mark !connection-rate \
    !connection-type !content disabled=yes !dscp !dst-address \
    !dst-address-list !dst-address-type !dst-limit dst-port=24 !fragment \
    !icmp-options !in-bridge-port !in-bridge-port-list in-interface=ether1 \
    !in-interface-list !ingress-priority !ipsec-policy !ipv4-options \
    !layer7-protocol !limit log=no log-prefix="" !nth !out-bridge-port \
    !out-bridge-port-list !out-interface !out-interface-list !packet-mark \
    !packet-size !per-connection-classifier !port !priority protocol=tcp !psd \
    !random !routing-mark src-address=185.198.244.21 !src-address-list \
    !src-address-type !src-mac-address !src-port !tcp-mss !time to-addresses=\
    192.168.10.250 to-ports=24 !tos !ttl
/ip firewall raw
add action=drop chain=prerouting comment="RAW: Drop TCP malformati" \
    in-interface=ether1 protocol=tcp tcp-flags=!fin,!syn,!rst,!psh,!ack,!urg
add action=drop chain=prerouting comment="RAW: Drop Spoofing 192.168" \
    in-interface=ether1 src-address=192.168.0.0/16
add action=drop chain=prerouting comment="RAW: Drop Spoofing 10.x" \
    in-interface=ether1 src-address=10.0.0.0/8
add action=drop chain=prerouting comment="RAW: Drop Spoofing 172.16" \
    in-interface=ether1 src-address=172.16.0.0/12
/ip firewall service-port
set ftp disabled=no ports=21
set tftp disabled=no ports=69
set irc disabled=yes ports=6667
set h323 disabled=no
set sip disabled=no ports=5060,5061 sip-direct-media=yes sip-timeout=1h
set pptp disabled=no
set rtsp disabled=yes ports=554
set udplite disabled=no
set dccp disabled=no
set sctp disabled=no
/ip hotspot service-port
set ftp disabled=no ports=21
/ip hotspot user
set [ find default=yes ] comment="counters and limits for trial users" \
    disabled=no name=default-trial server=all
/ip ipsec policy
set 0 disabled=no dst-address=::/0 group=default proposal=default protocol=\
    all src-address=::/0 template=yes
/ip ipsec settings
set accounting=yes ddos-cookie-threshold=20 interim-update=0s \
    xauth-use-radius=no
/ip media settings
set thumbnails=""
/ip nat-pmp
set enabled=no
/ip proxy
set always-from-cache=no anonymous=no cache-administrator=webmaster \
    cache-hit-dscp=4 cache-on-disk=no enabled=no max-cache-object-size=\
    2048KiB max-cache-size=unlimited max-client-connections=600 \
    max-fresh-time=3d max-server-connections=600 parent-proxy=:: \
    parent-proxy-port=0 port=8080 serialize-connections=no src-address=::
/ipv6 route
add disabled=no dst-address=::/0 gateway=fe80::3a07:16ff:fe20:3192%ether1 \
    pref-src="" routing-table=main
/ip service
set ftp available-from="" disabled=yes max-sessions=20 port=21 vrf=main
set telnet available-from="" disabled=yes max-sessions=20 port=23 vrf=main
set www available-from=192.168.10.0/24 disabled=no max-sessions=20 port=80 \
    vrf=main
set www-ssl available-from="" certificate=none disabled=yes max-sessions=20 \
    port=443 tls-version=any vrf=main
set reverse-proxy available-from="" certificate=none disabled=no \
    max-sessions=20 port=443 tls-version=any vrf=main
set ssh available-from=192.168.10.0/24,10.0.0.0/24,192.168.8.0/24 disabled=no \
    max-sessions=20 port=2222 vrf=main
set api available-from="" disabled=yes max-sessions=20 port=8728 vrf=main
set api-ssl available-from="" certificate=none disabled=yes max-sessions=20 \
    port=8729 tls-version=any vrf=main
set winbox available-from=192.168.10.0/24,10.0.0.0/24,192.168.8.0/24 \
    disabled=no max-sessions=20 port=18291 vrf=main
/ip smb shares
set [ find default=yes ] directory=/flash/pub disabled=yes invalid-users="" \
    name=pub read-only=no require-encryption=no valid-users=""
/ip socks
set auth-method=none connection-idle-timeout=2m enabled=no max-connections=\
    200 port=1080 version=4 vrf=main
/ip ssh
set ciphers=auto forwarding-enabled=no host-key-size=2048 host-key-type=rsa \
    password-authentication=yes-if-no-key publickey-authentication-options=\
    none strong-crypto=no
/ip tftp settings
set max-block-size=4096
/ip traffic-flow
set active-flow-timeout=30m cache-entries=32k enabled=no \
    inactive-flow-timeout=15s interfaces=all packet-sampling=no \
    sampling-interval=0 sampling-space=0
/ip traffic-flow ipfix
set bytes=yes dst-address=yes dst-address-mask=yes dst-mac-address=yes \
    dst-port=yes first-forwarded=yes gateway=yes icmp-code=yes icmp-type=yes \
    igmp-type=yes in-interface=yes ip-header-length=yes ip-total-length=yes \
    ipv6-flow-label=yes is-multicast=yes last-forwarded=yes nat-dst-address=\
    yes nat-dst-port=yes nat-events=no nat-src-address=yes nat-src-port=yes \
    out-interface=yes packets=yes protocol=yes src-address=yes \
    src-address-mask=yes src-mac-address=yes src-port=yes sys-init-time=yes \
    tcp-ack-num=yes tcp-flags=yes tcp-seq-num=yes tcp-window-size=yes tos=yes \
    ttl=yes udp-length=yes
/ip upnp
set allow-disable-external-interface=no enabled=no show-dummy-rule=yes
/ipv6 address
add address=2a01:e11:401:a950::2/64 advertise=no auto-link-local=yes comment=\
    "Collegamento alla iliadbox" disabled=no eui-64=no from-pool="" \
    interface=ether1 no-dad=no
add address=2a01:e11:401:a951::1/64 advertise=yes auto-link-local=yes \
    comment="IP LAN" disabled=no eui-64=no from-pool="" interface=bridge \
    no-dad=no
/ipv6 firewall address-list
add address=::/128 comment="Unspecified address" disabled=no dynamic=no list=\
    bad_ipv6
add address=::1/128 comment=Loopback disabled=no dynamic=no list=bad_ipv6
add address=::ffff:0.0.0.0/96 comment="IPv4-mapped IPv6" disabled=no dynamic=\
    no list=bad_ipv6
add address=100::/64 comment="Discard-only prefix" disabled=no dynamic=no \
    list=bad_ipv6
add address=2001:db8::/32 comment=Documentation disabled=no dynamic=no list=\
    bad_ipv6
add address=2001:10::/28 comment=ORCHID disabled=no dynamic=no list=bad_ipv6
add address=fec0::/10 comment="Site-local (deprecated)" disabled=no dynamic=\
    no list=bad_ipv6
add address=fc00::/7 comment="Unique Local Address (ULA)" disabled=no \
    dynamic=no list=bad_ipv6
add address=ff00::/8 comment=Multicast disabled=no dynamic=no list=bad_ipv6
/ipv6 firewall filter
add action=accept chain=input comment="v6: allow RS" !connection-bytes \
    !connection-limit !connection-mark !connection-nat-state !connection-rate \
    !connection-state !connection-type !content disabled=no !dscp \
    !dst-address !dst-address-list !dst-address-type !dst-limit !dst-port \
    !headers !hop-limit icmp-options=133:0 !in-bridge-port \
    !in-bridge-port-list in-interface=ether1 !in-interface-list \
    !ingress-priority !ipsec-policy !limit log=no log-prefix="" !nth \
    !out-bridge-port !out-bridge-port-list !out-interface !out-interface-list \
    !packet-mark !packet-size !per-connection-classifier !port !priority \
    protocol=icmpv6 !random !routing-mark !src-address !src-address-list \
    !src-address-type !src-mac-address !src-port !tcp-flags !tcp-mss !time \
    !tls-host !tos
add action=accept chain=input comment=\
    "ICMPv6 di tipo 134 (Router Advertisement)" !connection-bytes \
    !connection-limit !connection-mark !connection-nat-state !connection-rate \
    !connection-state !connection-type !content disabled=no !dscp \
    !dst-address !dst-address-list !dst-address-type !dst-limit !dst-port \
    !headers !hop-limit icmp-options=134:0 !in-bridge-port \
    !in-bridge-port-list in-interface=ether1 !in-interface-list \
    !ingress-priority !ipsec-policy !limit log=no log-prefix="" !nth \
    !out-bridge-port !out-bridge-port-list !out-interface !out-interface-list \
    !packet-mark !packet-size !per-connection-classifier !port !priority \
    protocol=icmpv6 !random !routing-mark !src-address !src-address-list \
    !src-address-type !src-mac-address !src-port !tcp-flags !tcp-mss !time \
    !tls-host !tos
add action=accept chain=input comment="v6: allow NS" !connection-bytes \
    !connection-limit !connection-mark !connection-nat-state !connection-rate \
    !connection-state !connection-type !content disabled=no !dscp \
    !dst-address !dst-address-list !dst-address-type !dst-limit !dst-port \
    !headers !hop-limit icmp-options=135:0 !in-bridge-port \
    !in-bridge-port-list in-interface=ether1 !in-interface-list \
    !ingress-priority !ipsec-policy !limit log=no log-prefix="" !nth \
    !out-bridge-port !out-bridge-port-list !out-interface !out-interface-list \
    !packet-mark !packet-size !per-connection-classifier !port !priority \
    protocol=icmpv6 !random !routing-mark !src-address !src-address-list \
    !src-address-type !src-mac-address !src-port !tcp-flags !tcp-mss !time \
    !tls-host !tos
add action=accept chain=input comment="v6: accept established, related" \
    !connection-bytes !connection-limit !connection-mark \
    !connection-nat-state !connection-rate connection-state=\
    established,related !connection-type !content disabled=no !dscp \
    !dst-address !dst-address-list !dst-address-type !dst-limit !dst-port \
    !headers !hop-limit !icmp-options !in-bridge-port !in-bridge-port-list \
    !in-interface !in-interface-list !ingress-priority !ipsec-policy !limit \
    log=no log-prefix="" !nth !out-bridge-port !out-bridge-port-list \
    !out-interface !out-interface-list !packet-mark !packet-size \
    !per-connection-classifier !port !priority !protocol !random \
    !routing-mark !src-address !src-address-list !src-address-type \
    !src-mac-address !src-port !tcp-flags !tcp-mss !time !tls-host !tos
add action=accept chain=input comment="v6: allow NA" !connection-bytes \
    !connection-limit !connection-mark !connection-nat-state !connection-rate \
    !connection-state !connection-type !content disabled=no !dscp \
    !dst-address !dst-address-list !dst-address-type !dst-limit !dst-port \
    !headers !hop-limit icmp-options=136:0 !in-bridge-port \
    !in-bridge-port-list in-interface=ether1 !in-interface-list \
    !ingress-priority !ipsec-policy !limit log=no log-prefix="" !nth \
    !out-bridge-port !out-bridge-port-list !out-interface !out-interface-list \
    !packet-mark !packet-size !per-connection-classifier !port !priority \
    protocol=icmpv6 !random !routing-mark !src-address !src-address-list \
    !src-address-type !src-mac-address !src-port !tcp-flags !tcp-mss !time \
    !tls-host !tos
add action=accept chain=forward comment="v6: accept established, related" \
    !connection-bytes !connection-limit !connection-mark \
    !connection-nat-state !connection-rate connection-state=\
    established,related !connection-type !content disabled=no !dscp \
    !dst-address !dst-address-list !dst-address-type !dst-limit !dst-port \
    !headers !hop-limit !icmp-options !in-bridge-port !in-bridge-port-list \
    !in-interface !in-interface-list !ingress-priority !ipsec-policy !limit \
    log=no log-prefix="" !nth !out-bridge-port !out-bridge-port-list \
    !out-interface !out-interface-list !packet-mark !packet-size \
    !per-connection-classifier !port !priority !protocol !random \
    !routing-mark !src-address !src-address-list !src-address-type \
    !src-mac-address !src-port !tcp-flags !tcp-mss !time !tls-host !tos
add action=drop chain=input comment="v6: drop invalid" !connection-bytes \
    !connection-limit !connection-mark !connection-nat-state !connection-rate \
    connection-state=invalid !connection-type !content disabled=no !dscp \
    !dst-address !dst-address-list !dst-address-type !dst-limit !dst-port \
    !headers !hop-limit !icmp-options !in-bridge-port !in-bridge-port-list \
    !in-interface !in-interface-list !ingress-priority !ipsec-policy !limit \
    log=no log-prefix="" !nth !out-bridge-port !out-bridge-port-list \
    !out-interface !out-interface-list !packet-mark !packet-size \
    !per-connection-classifier !port !priority !protocol !random \
    !routing-mark !src-address !src-address-list !src-address-type \
    !src-mac-address !src-port !tcp-flags !tcp-mss !time !tls-host !tos
add action=drop chain=forward comment="v6: drop invalid" !connection-bytes \
    !connection-limit !connection-mark !connection-nat-state !connection-rate \
    connection-state=invalid !connection-type !content disabled=no !dscp \
    !dst-address !dst-address-list !dst-address-type !dst-limit !dst-port \
    !headers !hop-limit !icmp-options !in-bridge-port !in-bridge-port-list \
    !in-interface !in-interface-list !ingress-priority !ipsec-policy !limit \
    log=no log-prefix="" !nth !out-bridge-port !out-bridge-port-list \
    !out-interface !out-interface-list !packet-mark !packet-size \
    !per-connection-classifier !port !priority !protocol !random \
    !routing-mark !src-address !src-address-list !src-address-type \
    !src-mac-address !src-port !tcp-flags !tcp-mss !time !tls-host !tos
add action=accept chain=input comment="v6: allow ICMPv6 input" \
    !connection-bytes !connection-limit !connection-mark \
    !connection-nat-state !connection-rate !connection-state !connection-type \
    !content disabled=no !dscp !dst-address !dst-address-list \
    !dst-address-type !dst-limit !dst-port !headers !hop-limit !icmp-options \
    !in-bridge-port !in-bridge-port-list !in-interface !in-interface-list \
    !ingress-priority !ipsec-policy !limit log=no log-prefix="" !nth \
    !out-bridge-port !out-bridge-port-list !out-interface !out-interface-list \
    !packet-mark !packet-size !per-connection-classifier !port !priority \
    protocol=icmpv6 !random !routing-mark !src-address !src-address-list \
    !src-address-type !src-mac-address !src-port !tcp-flags !tcp-mss !time \
    !tls-host !tos
add action=accept chain=forward comment="v6: allow ICMPv6 forward" \
    !connection-bytes !connection-limit !connection-mark \
    !connection-nat-state !connection-rate !connection-state !connection-type \
    !content disabled=no !dscp !dst-address !dst-address-list \
    !dst-address-type !dst-limit !dst-port !headers !hop-limit !icmp-options \
    !in-bridge-port !in-bridge-port-list !in-interface !in-interface-list \
    !ingress-priority !ipsec-policy !limit log=no log-prefix="" !nth \
    !out-bridge-port !out-bridge-port-list !out-interface !out-interface-list \
    !packet-mark !packet-size !per-connection-classifier !port !priority \
    protocol=icmpv6 !random !routing-mark !src-address !src-address-list \
    !src-address-type !src-mac-address !src-port !tcp-flags !tcp-mss !time \
    !tls-host !tos
add action=accept chain=input comment="v6: allow LAN to router" \
    !connection-bytes !connection-limit !connection-mark \
    !connection-nat-state !connection-rate !connection-state !connection-type \
    !content disabled=no !dscp !dst-address !dst-address-list \
    !dst-address-type !dst-limit !dst-port !headers !hop-limit !icmp-options \
    !in-bridge-port !in-bridge-port-list in-interface=bridge \
    !in-interface-list !ingress-priority !ipsec-policy !limit log=no \
    log-prefix="" !nth !out-bridge-port !out-bridge-port-list !out-interface \
    !out-interface-list !packet-mark !packet-size !per-connection-classifier \
    !port !priority !protocol !random !routing-mark !src-address \
    !src-address-list !src-address-type !src-mac-address !src-port !tcp-flags \
    !tcp-mss !time !tls-host !tos
add action=drop chain=input comment="v6: drop bad sources from WAN" \
    !connection-bytes !connection-limit !connection-mark \
    !connection-nat-state !connection-rate !connection-state !connection-type \
    !content disabled=no !dscp !dst-address !dst-address-list \
    !dst-address-type !dst-limit !dst-port !headers !hop-limit !icmp-options \
    !in-bridge-port !in-bridge-port-list in-interface=ether1 \
    !in-interface-list !ingress-priority !ipsec-policy !limit log=no \
    log-prefix="" !nth !out-bridge-port !out-bridge-port-list !out-interface \
    !out-interface-list !packet-mark !packet-size !per-connection-classifier \
    !port !priority !protocol !random !routing-mark !src-address \
    src-address-list=bad_ipv6 !src-address-type !src-mac-address !src-port \
    !tcp-flags !tcp-mss !time !tls-host !tos
add action=drop chain=forward comment="v6: drop bad fwd from WAN" \
    !connection-bytes !connection-limit !connection-mark \
    !connection-nat-state !connection-rate !connection-state !connection-type \
    !content disabled=no !dscp !dst-address !dst-address-list \
    !dst-address-type !dst-limit !dst-port !headers !hop-limit !icmp-options \
    !in-bridge-port !in-bridge-port-list in-interface=ether1 \
    !in-interface-list !ingress-priority !ipsec-policy !limit log=no \
    log-prefix="" !nth !out-bridge-port !out-bridge-port-list !out-interface \
    !out-interface-list !packet-mark !packet-size !per-connection-classifier \
    !port !priority !protocol !random !routing-mark !src-address \
    src-address-list=bad_ipv6 !src-address-type !src-mac-address !src-port \
    !tcp-flags !tcp-mss !time !tls-host !tos
add action=drop chain=forward comment="v6: drop hop-limit=1 from WAN" \
    !connection-bytes !connection-limit !connection-mark \
    !connection-nat-state !connection-rate !connection-state !connection-type \
    !content disabled=no !dscp !dst-address !dst-address-list \
    !dst-address-type !dst-limit !dst-port !headers hop-limit=equal:1 \
    !icmp-options !in-bridge-port !in-bridge-port-list in-interface=ether1 \
    !in-interface-list !ingress-priority !ipsec-policy !limit log=no \
    log-prefix="" !nth !out-bridge-port !out-bridge-port-list !out-interface \
    !out-interface-list !packet-mark !packet-size !per-connection-classifier \
    !port !priority !protocol !random !routing-mark !src-address \
    !src-address-list !src-address-type !src-mac-address !src-port !tcp-flags \
    !tcp-mss !time !tls-host !tos
add action=drop chain=input comment=\
    "v6: drop everything else from WAN to router" !connection-bytes \
    !connection-limit !connection-mark !connection-nat-state !connection-rate \
    !connection-state !connection-type !content disabled=no !dscp \
    !dst-address !dst-address-list !dst-address-type !dst-limit !dst-port \
    !headers !hop-limit !icmp-options !in-bridge-port !in-bridge-port-list \
    in-interface=ether1 !in-interface-list !ingress-priority !ipsec-policy \
    !limit log=yes log-prefix=V6-WAN-DROP !nth !out-bridge-port \
    !out-bridge-port-list !out-interface !out-interface-list !packet-mark \
    !packet-size !per-connection-classifier !port !priority !protocol !random \
    !routing-mark !src-address !src-address-list !src-address-type \
    !src-mac-address !src-port !tcp-flags !tcp-mss !time !tls-host !tos
add action=drop chain=forward comment=\
    "v6: block all unauthorized access to LAN" !connection-bytes \
    !connection-limit !connection-mark !connection-nat-state !connection-rate \
    !connection-state !connection-type !content disabled=no !dscp \
    !dst-address !dst-address-list !dst-address-type !dst-limit !dst-port \
    !headers !hop-limit !icmp-options !in-bridge-port !in-bridge-port-list \
    in-interface=ether1 !in-interface-list !ingress-priority !ipsec-policy \
    !limit log=no log-prefix="" !nth !out-bridge-port !out-bridge-port-list \
    !out-interface !out-interface-list !packet-mark !packet-size \
    !per-connection-classifier !port !priority !protocol !random \
    !routing-mark !src-address !src-address-list !src-address-type \
    !src-mac-address !src-port !tcp-flags !tcp-mss !time !tls-host !tos
/ipv6 firewall mangle
add action=change-mss chain=forward comment="v6: Fix MTU per Iliad" new-mss=\
    clamp-to-pmtu out-interface=ether1 passthrough=yes protocol=tcp \
    tcp-flags=syn
/ipv6 nd
set [ find default=yes ] advertise-dns=no advertise-mac-address=yes disabled=\
    no !dns hop-limit=unspecified interface=ether1 \
    managed-address-configuration=no mtu=unspecified other-configuration=no \
    !pref64 ra-delay=3s ra-interval=20s-1m ra-lifetime=30m ra-preference=\
    medium reachable-time=unspecified retransmit-interval=unspecified
# automatic dns option advertising is not started, re-apply dns config
add advertise-dns=yes advertise-mac-address=yes disabled=no dns=\
    2a01:e11:401:a951::1 hop-limit=unspecified interface=bridge \
    managed-address-configuration=no mtu=unspecified other-configuration=yes \
    !pref64 ra-delay=3s ra-interval=20s-1m ra-lifetime=30m ra-preference=\
    medium reachable-time=unspecified retransmit-interval=unspecified
/ipv6 nd prefix default
set autonomous=yes dhcp6-pd-preferred=no preferred-lifetime=1w \
    valid-lifetime=4w2d
/ipv6 nd settings
set router-advertisement-ignored-options="" \
    router-advertisement-route-distance=1
/mpls settings
set allow-fast-path=yes dynamic-label-range=16-1048575 propagate-ttl=yes
/ppp aaa
set accounting=yes enable-ipv6-accounting=no interim-update=0s \
    use-circuit-id-in-nas-port-id=no use-radius=no
/ppp secret
add caller-id="" disabled=no ipv6-routes="" limit-bytes-in=0 limit-bytes-out=\
    0 !local-address name=ilcapo profile=ovpn-profile !remote-address \
    !remote-ipv6-prefix routes="" service=any
/queue simple
add bucket-size=0.1/0.1 burst-limit=0/0 burst-threshold=0/0 burst-time=0s/0s \
    disabled=yes limit-at=0/0 max-limit=500M/750M name=Smart-Queue-Global \
    packet-marks="" parent=none priority=8/8 queue=cake-upload/cake-download \
    target=bridge !time
/radius incoming
set accept=no port=3799 vrf=main
/routing igmp-proxy
set query-interval=2m5s query-response-interval=10s quick-leave=no
/routing settings
set check-gateway-ping-count=2 check-gateway-ping-interval=10s \
    check-gateway-ping-timeout=1s policy-rules=\
    mangle,vrf-lookup,vrf-unreach,local,user,main single-process=no
/snmp
set contact="" enabled=no engine-id-suffix="" location="" src-address=:: \
    trap-community=public trap-generators=temp-exception trap-target="" \
    trap-version=1 vrf=main
/system clock
set time-zone-autodetect=yes time-zone-name=Europe/Rome
/system clock manual
set dst-delta=+00:00 dst-end="1970-01-01 00:00:00" dst-start=\
    "1970-01-01 00:00:00" time-zone=+00:00
/system identity
set name=Mater
/system leds settings
set all-leds-off=never
/system logging
set 0 action=memory disabled=no prefix="" regex="" topics=info
set 1 action=memory disabled=no prefix="" regex="" topics=error
set 2 action=memory disabled=no prefix="" regex="" topics=warning
set 3 action=memory disabled=no prefix="" regex="" topics=critical
/system note
set note="" show-at-cli-login=no show-at-login=yes
/system ntp client
set enabled=no mode=unicast servers="" vrf=main
/system ntp server
set auth-key=none broadcast=no broadcast-addresses="" enabled=no \
    local-clock-stratum=5 manycast=no multicast=no use-local-clock=no vrf=\
    main
/system package local-update mirror
set check-interval=1d enabled=no primary-server=:: secondary-server=:: user=\
    ""
/system package update
set channel=stable check-certificate=yes ip-version=auto mode=https
/system resource hardware usb-settings
set authorization=no
/system resource irq
set 0 cpu=auto
set 1 cpu=auto
set 2 cpu=auto
set 3 cpu=auto
set 4 cpu=auto
/system routerboard mode-button
set enabled=no hold-time=0s..1m on-event=""
/system routerboard reset-button
set enabled=no hold-time=0s..1m on-event=""
/system routerboard settings
set auto-upgrade=no boot-device=nand-if-fail-then-ethernet boot-protocol=\
    bootp force-backup-booter=no preboot-etherboot=disabled \
    preboot-etherboot-server=any protected-routerboot=disabled \
    reformat-hold-button=20s reformat-hold-button-max=10m silent-boot=no
/system scheduler
add comment="ADBLOCK update ogni 7 giorni" !days disabled=no interval=1w \
    name=run_adlist_update on-event=update_adlist policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2025-12-16 start-time=02:00:00
/system watchdog
set auto-send-supout=no automatic-supout=yes ping-start-after-boot=5m \
    ping-timeout=1m watch-address=none watchdog-timer=yes
/tool bandwidth-server
set allocate-udp-ports-from=2000 allowed-addresses4="" allowed-addresses6="" \
    authenticate=yes enabled=yes max-sessions=100
/tool e-mail
set certificate-verification=no from=<> port=25 server=0.0.0.0 tls=no user="" \
    vrf=main
/tool graphing
set page-refresh=300 store-every=5min
/tool mac-server
set allowed-interface-list=all
/tool mac-server mac-winbox
set allowed-interface-list=all
/tool mac-server ping
set enabled=yes
/tool romon
set enabled=no id=00:00:00:00:00:00
/tool romon port
set [ find default=yes ] cost=100 disabled=no forbid=no interface=all
/tool sms
set allowed-number="" channel=0 polling=no port=none receive-enabled=no \
    remove-sent-sms-after-send=no sms-storage=sim
/tool sniffer
set file-limit=1000KiB file-name="" filter-cpu="" filter-direction=any \
    filter-dst-ip-address="" filter-dst-ipv6-address="" \
    filter-dst-mac-address="" filter-dst-port="" filter-interface="" \
    filter-ip-address="" filter-ip-protocol="" filter-ipv6-address="" \
    filter-mac-address="" filter-mac-protocol="" \
    filter-operator-between-entries=or filter-port="" filter-size="" \
    filter-src-ip-address="" filter-src-ipv6-address="" \
    filter-src-mac-address="" filter-src-port="" filter-stream=no \
    filter-vlan="" max-packet-size=2048 memory-limit=100KiB memory-scroll=yes \
    only-headers=no quick-rows=20 quick-show-frame=no streaming-enabled=no \
    streaming-server=0.0.0.0:37008
/tool traffic-generator
set latency-distribution-max=100us measure-out-of-order=no \
    stats-samples-to-keep=100 test-id=0
/user aaa
set accounting=yes default-group=read exclude-groups="" interim-update=0s \
    use-radius=no
/user settings
set minimum-categories=0 minimum-password-length=0
