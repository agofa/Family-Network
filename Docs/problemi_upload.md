
Linea teorica: 2.5G/900M (è quello che hai sottoscritto?)

ethernet to iliadbox (1Gb) 950 / 226

WIFI IliadBox diretta: 1300-1500 Mbps / 150-160 Mbps


Wifi altro connesso a iliadbox: 770 / 130

/system scheduler add name=clean-nat interval=4h \
  on-event="/ip firewall connection remove [find]; :log info \"State cleaned\"" \
  comment="Pulisci connection tracking ogni 4 ore"