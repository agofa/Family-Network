# Configurazione
1. FastTrack annulla il CAKE. Hai uno smart queue con CAKE su target=bridge, ma in forward hai anche:

add action=fasttrack-connection chain=forward connection-state=established,related

Il FastTrack bypassa l'intero sistema di code, quindi la stragrande maggioranza del traffico
(tutto ciò che è established) salta lo shaping.
In pratica il CAKE agisce solo sulle connessioni nuove/non-fasttracked → niente controllo del bufferbloat reale.
Se vuoi che lo SQM lavori davvero devi disabilitare il FastTrack (o escludere dal fasttrack il traffico che vuoi shapare). Tieni presente però che senza FastTrack la hAP ac² (IPQ-4018, 716 MHz) regge molto meno banda con CAKE:
realisticamente qualche centinaio di Mbit, non 750. Quindi è un compromesso latenza/throughput che vale la pena valutare in base alla tua linea Iliad effettiva.

2. WireGuard: allowed-address sovrapposti. Due peer hanno una /24:
FedorsNotebook  allowed-address=10.0.0.3/24
Hippo           allowed-address=10.0.0.4/24
VPS             allowed-address=10.0.0.2/32   ✅

Il cryptokey routing di WireGuard vuole allowed-ips non sovrapposti tra peer. Con due peer che coprono entrambi 10.0.0.0/24, l'intera subnet finisce associata a uno solo (di norma l'ultimo), e l'altro diventa irraggiungibile lato server per il traffico di ritorno.
Vanno messi a /32 come hai fatto giustamente per la VPS:
set FedorsNotebook allowed-address=10.0.0.3/32
set Hippo          allowed-address=10.0.0.4/32

3. Lo scheduler dell'adlist probabilmente non parte
Lo scheduler chiama on-event=update_adlist ma lo script si chiama Update_adlist (maiuscola). In RouterOS i nomi sono case-sensitive, quindi è probabile che l'aggiornamento settimanale non venga mai eseguito. Verifica nei log. Inoltre update_whitelist non è schedulato affatto — lo lanci solo a mano.
(La logica del tuo script Update_adlist invece è furba: cambiando ssl-verify forzi il re-download di ogni lista.)

4. L'adblock viene bypassato in IPv6
Via DHCP IPv4 distribuisci correttamente 192.168.10.1 come DNS, ma in RA annunci resolver pubblici:
/ipv6 nd add ... dns=2606:4700:4700::1111,2001:4860:4860::8888
I client che preferiscono il DNS IPv6 (cioè quasi tutti i dispositivi moderni) interrogano direttamente Cloudflare/Google e saltano completamente le tue adlist. Dovresti annunciare il router come DNS IPv6 (2a01:e11:401:a951::1) per chiudere la falla.

# Sicurezza
SSH e Winbox aperti su tutta la WAN. Questa regola accetta da qualsiasi IP di Internet:
add chain=input dst-port=2222,18291 in-interface=ether1 protocol=tcp connection-state=new

Hai già WireGuard funzionante: la gestione remota dovrebbe passare solo da lì. Esporre Winbox in particolare (storico di vulnerabilità) senza restrizione di sorgente è il punto più debole della config. O la rimuovi del tutto (gestisci via VPN), o almeno limiti con una address-list di IP fidati. Nota la coerenza che hai già messo su WebFig (www address=192.168.10.0/24, solo LAN) — manca lo stesso criterio qui.
Upstream DNS solo IPv6. Tutti e quattro i resolver sono IPv6-only. Se l'IPv6 verso l'upstream cade per qualsiasi motivo, perdi la risoluzione DNS in toto. Aggiungerei almeno un fallback IPv4.
ICMPv6 forward accettato per intero prima del drop finale verso la LAN: i tuoi host interni IPv6 sono pingabili/raggiungibili in ICMP da Internet. Un po' di ICMPv6 in forward serve (PMTUD, ND), ma valuta se limitare gli echo-request verso la LAN.

