# ==========================================================
# PREMESSA
# ==========================================================
# Configurazione IPv4 e IPv6 su MikroTik con Iliadbox in modalità ONT
# Per IPv4 si usa il DHCP 
# Per IPv6 non si usa il DHCPv6-PD (non si riesce ad avere il lease dalla Iliadbox) ma una configurazione Statica.

# Nota per IPv6
Immaginate la rete a950 come una strada privata che collega solo la Iliadbox alla porta WAN della MikroTik. La rete a951, invece, è la vostra vera rete locale. Il 'trucco' sta nel dire alla Iliadbox che per raggiungere qualsiasi dispositivo nella rete a951, deve passare attraverso la MikroTik (usando il suo indirizzo Link-Local fe80 come Next Hop)."

# Punti chiave
# Gateway della Iliadbox: Quel fe80 che vedi nel pannello Iliad (serve alla MikroTik per uscire).
# Link-Local della MikroTik: Quel fe80 che vedi su ether1 (serve alla Iliadbox per entrare).
# DNS IPv6: Cloudflare o Google, da inserire sia nel sistema che nel Neighbor Discovery (ND).
	
	Guida Rapida IPv6: MikroTik + Iliadbox (ONT Mode)
1. Preparazione Iliadbox

    Delegazione Prefissi: Identifica le tue sottoreti.

        ID 0 (...:a950::/64) -> Destinata al link tra Iliadbox e MikroTik (WAN).

        ID 1 (...:a951::/64) -> Destinata alla tua rete locale (LAN).

    Next Hop: Fondamentale! Inserisci l'indirizzo Link-Local (fe80::...) della porta WAN della MikroTik come Next Hop per la sottorete ID 1.

2. Configurazione MikroTik (Core)

    Abilitazione: IPv6 > Settings > Disable IPv6: no.

    Indirizzamento:

        WAN (ether1): 2a01:e11:401:a950::2/64 (Advertise: no).

        LAN (bridge): 2a01:e11:401:a951::1/64 (Advertise: yes).

    Rotta di Default:

        Dst. Address: ::/0

        Gateway: fe80::...%ether1 (Link-local della Iliadbox + interfaccia).

3. Servizi per i Client (DNS & ND)

    DNS: In IP > DNS, aggiungi i server IPv6 (Cloudflare/Google) e spunta Allow Remote Requests.

    Neighbor Discovery (ND):

        Crea una voce per l'interfaccia bridge.

        Imposta other-configuration=yes.

        Importante: Popola la lista dns-servers con gli indirizzi IPv6 per forzare i client a usarli.

4. Firewall & Ottimizzazioni

    Regole Filter: Ordine critico (Established -> ICMPv6 -> Trust LAN -> Drop Bogon -> Drop WAN).

    Mangle: Applicare il clamp-to-pmtu sulla catena di forward per l'interfaccia WAN per evitare siti che caricano a metà.
	
	
	
	
a Logica del Routing: Perché due prefissi?

Molti utenti fanno l'errore di provare a usare lo stesso prefisso ovunque. Con Iliad e MikroTik, dobbiamo invece dividere i compiti:
Prefisso (Sottorete)	Ruolo	Destinazione	Perché?
...:a950::/64	Transito	Tra Iliadbox e MikroTik	È il "ponte". Serve solo ai due router per parlarsi.
...:a951::/64	LAN	All'interno della tua rete	È la rete dove vivono i tuoi PC, smartphone e server.
	


Per rendere la guida davvero "pro", potresti aggiungere una sezione "Troubleshooting" basata sui problemi che abbiamo risolto oggi:

    Cosa fare se non vedi il Link-Local (controllare IPv6 settings).

    Cosa fare se il test DNS fallisce (comando resolvectl flush-caches su Linux).

    L'errore comune del nd add (usare set o edit per i DNS).