“In modalità ONT su VLAN 103 avete IPv6 Prefix Delegation attiva? Perché non risponde nessun server DHCPv6.”




Backup MikroTik: (System > Backup) Indispensabile.

Backup Iliadbox: (Dalla sua interfaccia web) Buona norma, anche se la modalità ONT è un tasto "on/off".

Configurazione Iliadbox (Passaggio a ONT):

    Entra nella Iliadbox, attiva la modalità ONT/Bridge.

    Nota importante: Una volta salvato, la Iliadbox si riavvierà e non sarà più raggiungibile all'indirizzo 192.168.1.1 (o quello che avevi) dal router. Potrai raggiungerla solo collegando un PC direttamente a una delle sue porte residue o tramite l'IP specifico che prenderà (spesso 192.168.100.1).

Applicare lo script al MikroTik:

    Ora che la Iliadbox è "trasparente", incolla lo script.

    In questo modo, il DHCP Client IPv6 (punto 2 dello script) invierà la richiesta e troverà la rete Iliad "aperta", passando subito in bound.
	
	Un piccolo check finale sulla VLAN 103

Ricordati che nel momento in cui la Iliadbox passa in ONT, la tua vecchia configurazione IPv4 sul MikroTik (quella che avevi su ether1) smetterà di navigare se Iliad richiede la VLAN 103 (molto probabile).

Se vedi che dopo il punto 4 non navighi né in IPv4 né in IPv6:

    Attiva la parte dello script relativa alla VLAN 103.

    Sposta il DHCP Client (IPv4) e il DHCP Client (IPv6) dall'interfaccia ether1 alla nuova interfaccia vlan103:iliad.
	
	
	Se vuoi raggiungerla senza staccare cavi, devi aggiungere un IP "fittizio" sulla tua interfaccia WAN (ether1 o vlan103) che appartenga a quella sottorete. Ad esempio: /ip address add address=192.168.100.2/24 interface=ether1 (o vlan103). In questo modo, se scrivi 192.168.100.1 nel browser, il MikroTik saprà dove mandare il pacchetto.
	
	
	
	http://myiliadbox.iliad.it/	
	
	
/ipv6 address  add address=2a01:e11:401:a950::1/64 interface=bridge advertise=yes

/ipv6 route add dst:address=::/0 gateway=fe80::3a07:16ff:fe20:3192%ether1


	
iliadbox (r1)
38:07:16:20:31:92
mikro ether 1 C4:AD:34:F2:F2:55
373100J241911678

Indirizzo IP fe80::3a07:16ff:fe20:3192
Sottoreti
	



2a01:e11:401:a950::/64
2a01:e11:401:a951::/64
2a01:e11:401:a952::/64
2a01:e11:401:a953::/64
2a01:e11:401:a954::/64
2a01:e11:401:a955::/64
2a01:e11:401:a956::/64
2a01:e11:401:a957::/64

Esatto, il fatto che tu veda 8 sottoreti conferma che Iliad ti sta assegnando un prefisso /60 (che contiene appunto 16 sottoreti /64, dalla :a950: alla :a95f:, di cui le prime 8 sono visibili nell'interfaccia).

Ecco cosa cambia tecnicamente per la tua configurazione:

    La scelta del /56 nello script è perfetta: Anche se Iliad ti dà una /60, richiedere una /56 al DHCP client è la mossa più sicura. Il protocollo DHCPv6 è flessibile: tu chiedi una /56, e se la rete ti risponde con una /60, il MikroTik la accetterà comunque adattandosi automaticamente alla dimensione reale ricevuta.

    Gestione delle sottoreti: Una volta che Mater sarà in "Bound", potrai assegnare prefissi diversi a diverse interfacce del router (se mai vorrai creare una rete Guest o una VLAN per la domotica), attingendo da quelle 8:16 sottoreti che hai visto nella foto.

    Indirizzamento: Il MikroTik userà la prima sottorete disponibile (probabilmente la :a950:) per il bridge della tua LAN principale.

In sintesi: La tua osservazione conferma che la rete è pronta per il prefisso delegato. Quando passerai in ONT, Mater diventerà il "proprietario" di tutto quel blocco di indirizzi.



Suffisso DNS specifico della connessione: home
Descrizione: Realtek PCIe GbE Family Controller
Indirizzo fisico: ‎00:D8:61:A3:80:BF
DHCP abilitato: Sì
Indirizzo IPv4: 192.168.10.245
Subnet mask IPv4: 255.255.255.0
Lease ottenuto: martedì 23 dicembre 2025 00:06:26
Scadenza lease: mercoledì 24 dicembre 2025 00:06:38
Gateway predefinito IPv4: 192.168.10.1
Server DHCP IPv4: 192.168.10.1
Server DNS IPv4: 192.168.10.1
Server WINS IPv4: 
NetBIOS su TCP/IP attivato: Sì
Indirizzo IPv6: 2a01:e11:401:a950:8490:5da1:2afe:6891
Indirizzo IPv6 temporaneo: 2a01:e11:401:a950:34a9:e180:440e:1994
Indirizzo IPv6 locale rispetto al collegamento: fe80::23fa:154:1a77:5700%18
Gateway predefinito IPv6: 
Server DNS IPv6: fd0f:ee:b0::1

	