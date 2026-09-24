# Note importanti — Ripristino MikroTik hAP ac² (Mater)

> **Contesto:** MikroTik RBD52G-5HacD2HnD dietro IliadBox in modalità ONT.
> Documento redatto il 2026-07-25 dopo il reset del router (e della IliadBox,
> resettata per uscire da ONT durante i test sull'upload degradato).
>
> Riferimento conf: export `.rsc` del 2026-06-05, RouterOS 7.23.1.

---

## Indice

1. [Percorso A — Ripristino da backup binario (consigliato)](#percorso-a--ripristino-da-backup-binario-consigliato)
2. [Percorso B — Import da export .rsc](#percorso-b--import-da-export-rsc)
3. [Cosa il file .rsc NON contiene](#cosa-il-file-rsc-non-contiene)
4. [Problema IPv6 — leggere prima di riaccendere](#problema-ipv6--leggere-prima-di-riaccendere)
5. [Setup transitorio — IliadBox in modalità router](#setup-transitorio--iliadbox-in-modalità-router)
6. [Checklist post-ripristino](#checklist-post-ripristino)
7. [Miglioramenti da applicare](#miglioramenti-da-applicare)
8. [Gestione del logging](#gestione-del-logging)
9. [Dipendenze lato IliadBox](#dipendenze-lato-iliadbox)
10. [Pulizia — voci obsolete](#pulizia--voci-obsolete)
11. [Note per il futuro](#note-per-il-futuro)

---

## Percorso A — Ripristino da backup binario (consigliato)

Il backup binario (`.backup`) ripristina **tutto**: chiavi private WireGuard,
certificati OpenVPN, utenti e password, ppp secret. È il percorso da preferire.

### Prerequisiti

| Cosa | Perché |
|---|---|
| Password del backup | Se il backup era cifrato e non la ricordi, è inutilizzabile |
| Vecchia password di `admin` | Il restore la riporta indietro: dopo il reboot serve quella, non quella nuova |
| Versione RouterOS ≥ quella del backup | Il restore su una versione **più vecchia** può fallire o corrompere la config |
| Stesso modello di router | I backup binari non sono portabili tra modelli |

### Procedura

**1. Verifica la versione attuale**

```
/system resource print
```

Confronta `version` con quella del router al momento del backup (7.23.1).
Se ora sei su 7.23.2 o superiore va bene. Se sei più indietro, aggiorna prima:

```
/system package update check-for-updates
/system package update download
/system reboot
```

**2. Salva lo stato attuale (rete di sicurezza)**

```
/system backup save name=post-reset-pulito
```

Se il restore andasse male, hai comunque un punto di ritorno pulito.

**3. Carica il file sul router**

Il modo più semplice è **drag & drop nella finestra Files di Winbox**.
In alternativa via SFTP sulla porta SSH.

> Nota: dopo il reset l'FTP è abilitato di default (nella conf a regime è
> disabilitato). Se lo usi, ricordati che dopo il restore torna disabilitato.

Verifica che sia arrivato:

```
/file print
```

**4. Esegui il restore**

```
/system backup load name=nome-del-file
```

Con backup cifrato:

```
/system backup load name=nome-del-file password=LA-TUA-PASSWORD
```

**5. Il router riavvia da solo.**

Non è una domanda: `backup load` riavvia immediatamente. La sessione cade,
è normale.

**6. Riconnetti**

- IP: `192.168.10.1`
- Winbox: porta `18291`
- SSH: porta `2222`
- Utente e password: **quelli vecchi**, ripristinati dal backup

Metti il PC su `192.168.10.99/24` con gateway `192.168.10.1` prima di
riconnetterti, oppure usa MAC-Winbox.

**7. Passa alla [checklist post-ripristino](#checklist-post-ripristino).**

> ⚠️ **Non lanciare anche l'import del `.rsc` dopo il restore binario.**
> Otterresti regole firewall, lease DHCP e voci DNS statiche duplicate.

---

## Percorso B — Import da export .rsc

Da usare solo se il backup binario non è disponibile o non si carica.

### Il rischio principale: la sessione muore a metà import

Dopo il reset il PC sta su `192.168.88.x`. Alla riga

```
/ip address add address=192.168.10.1/24 ... interface=bridge
```

la sessione cade e **l'import si interrompe a metà**, lasciando il router
con una configurazione parziale — tipicamente con il firewall applicato solo
in parte. È lo scenario peggiore.

### Procedura sicura

**1. Modifica il file PRIMA di caricarlo**

- Rimuovi `owner=Pindus` dalle due righe `/system script add`
  (l'utente non esiste dopo il reset → errore di import)
- Commenta tutte le righe `/ipv6 address`, `/ipv6 route` e `/ipv6 nd add`
  (vedi [sezione IPv6](#problema-ipv6--leggere-prima-di-riaccendere))

**2. Reset pulito**

```
/system reset-configuration no-defaults=yes skip-backup=yes
```

**3. Riconnetti via MAC-Winbox** — non serve alcun IP, ed è immune ai filtri
di `/ip service`. È la rete di sicurezza che ti impedisce di chiuderti fuori.

**4. Metti il PC su IP statico** `192.168.10.99/24`, gateway `192.168.10.1`.

**5. Importa i certificati OpenVPN PRIMA dell'import della config**

```
/certificate import file-name=ca.crt
/certificate import file-name=server.crt
/certificate import file-name=server.key passphrase=...
```

Senza questi, la riga `/interface ovpn-server server add ...
certificate=server-certificate` fallisce e il server OpenVPN non viene creato.
**Il notebook di lavoro dipende da questo.**

**6. Importa la config, da MAC-Winbox**

```
/import file=conf.rsc verbose=yes
```

Leggi l'output riga per riga cercando errori.

**7. Passa alla [checklist post-ripristino](#checklist-post-ripristino)**,
e in più ai punti della sezione seguente.

---

## Cosa il file .rsc NON contiene

Vale **solo per il percorso B**. Con il backup binario questi punti sono
già risolti.

### 1. Chiave privata WireGuard

`/interface wireguard add` genera una **nuova coppia di chiavi**. Tutti e tre
i peer (FedorsNotebook, Hippo, VPS) smettono di funzionare, perché hanno
memorizzata la vecchia public key del router.

Se hai la vecchia private key salvata:

```
/interface wireguard set wg-vpn private-key="LA-VECCHIA-PRIVATE-KEY"
```

Altrimenti leggi la nuova public key e aggiorna tutti i client:

```
/interface wireguard print detail
```

### 2. Certificati OpenVPN

Il reset svuota lo store certificati. Vedi punto 5 del percorso B.

### 3. Password del ppp secret

```
/ppp secret add name=ilcapo profile=ovpn-profile
```

Viene creato **senza password**. Con `require-client-certificate=yes` il
rischio è contenuto, ma impostala comunque:

```
/ppp secret set [find name=ilcapo] password="..."
```

### 4. Utenti e password di sistema

L'export non contiene `/system user`. Dopo il reset resta `admin` con password
vuota. Ricrea l'utente `Pindus` e imposta le password.

### 5. Configurazione wireless

L'export non ha alcuna sezione `/interface wireless`. L'hAP ac² ha il WiFi ma
la rete è servita dal Tenda i27. A seconda di come è stato fatto il reset,
potresti ritrovarti la WiFi di default attiva e bridgiata. Verifica e
disabilita esplicitamente:

```
/interface wireless print
/interface wireless disable [find]
```

---

## Problema IPv6 — leggere prima di riaccendere

**Vale per entrambi i percorsi.**

La configurazione contiene indirizzi IPv6 **statici** che dipendono dalla
delega di prefisso della IliadBox:

```
/ipv6 address add address=2a01:e11:401:a950::2 interface=ether1
/ipv6 address add address=2a01:e11:401:a951::1 interface=bridge
/ipv6 route add gateway=fe80::3a07:16ff:fe20:3192%ether1
```

Dopo il reset della IliadBox e il rientro in modalità ONT, **il prefisso
delegato può essere cambiato**.

### Perché è più grave di quanto sembra

Non è solo "IPv6 non funziona". Questa riga:

```
/ipv6 nd add advertise-dns=yes dns=2a01:e11:401:a951::1 interface=bridge
```

annuncia ai client un server DNS IPv6 **morto**. I sistemi operativi lo
preferiscono a IPv4 e vanno in timeout su ogni query prima di ricadere su
IPv4. Il sintomo è una **risoluzione DNS lentissima o intermittente su tutta
la LAN**, che sembra un problema di linea. Facile perderci mezza giornata.

### Cosa fare

1. Verifica il prefisso attuale delegato dalla IliadBox
2. Verifica il link-local del gateway:
   ```
   /ipv6 neighbor print where interface=ether1
   ```
   Se la IliadBox è la stessa fisica il MAC non cambia, quindi
   `fe80::3a07:16ff:fe20:3192` dovrebbe essere ancora valido — ma **verificalo**
3. Correggi gli indirizzi statici e il DNS annunciato con i valori reali
4. Solo dopo, riabilita `/ipv6 nd`

Test rapido da un client:

```
ping6 2606:4700:4700::1111
```

---

## Setup transitorio — IliadBox in modalità router

> **Perché:** la IliadBox resta in modalità router (non ONT) per poter
> misurare la linea direttamente dalla box e documentare il reclamo con Iliad
> sull'upload degradato (armadio di palazzo).
>
> **Conseguenza:** si finisce in **doppio NAT**, e la configurazione del
> MikroTik non è scritta per questo scenario. Le modifiche qui sotto sono
> **temporanee** — vanno annullate al ritorno in ONT.

### Tabella di riepilogo

| Elemento | Router mode (transitorio) | ONT (definitivo) |
|---|---|---|
| IP su `ether1` | privato, `192.168.1.x` | pubblico |
| NAT | doppio | singolo |
| RAW `Drop Spoofing 192.168` | **disabilitata** | abilitata |
| IPv6 | **disabilitato** | abilitato e corretto |
| Port forward 51820/1194 sulla box | **necessari** | non necessari |
| Raggiungibilità VPN da internet | solo con forward | diretta |

---

### A — Passaggio a router mode

#### A.1 Verifica l'indirizzo ottenuto sulla WAN

```
/ip dhcp-client print detail
/ip address print where interface=ether1
```

Annota la **subnet della IliadBox** (tipicamente `192.168.1.0/24`) e il suo
gateway. Ti servono al passo successivo.

Nessuna sovrapposizione con la LAN interna (`192.168.10.0/24`), quindi da
questo punto di vista sei tranquillo.

#### A.2 Disabilita la regola RAW anti-spoofing — CRITICO

```
/ip firewall raw add action=drop chain=prerouting \
    comment="RAW: Drop Spoofing 192.168" \
    in-interface=ether1 src-address=192.168.0.0/16
```

Con IP pubblico sulla WAN questa regola è corretta. Con la box in router mode
**scarta tutto il traffico proveniente dalla box**, incluse le risposte DHCP:
il MikroTik può non ottenere nemmeno l'indirizzo WAN.

Sintomo tipico: `/ip dhcp-client print` resta su `searching...` e sembra un
problema di cavo o di porta.

**Opzione 1 — disabilita (semplice):**

```
/ip firewall raw disable [find comment="RAW: Drop Spoofing 192.168"]
```

**Opzione 2 — eccezione mirata (più pulita):**

```
/ip firewall raw add action=accept chain=prerouting \
    in-interface=ether1 src-address=192.168.1.0/24 \
    comment="RAW: Eccezione IliadBox in router mode" \
    place-before=[find comment="RAW: Drop Spoofing 192.168"]
```

Sostituisci `192.168.1.0/24` con la subnet reale rilevata al passo A.1.

Se qualcosa non torna, controlla i contatori:

```
/ip firewall raw print stats
```

> Le altre due regole RAW (`10.x` e `172.16`) restano attive senza problemi,
> a meno che la box non usi una di quelle subnet.

#### A.3 Disabilita IPv6

Gli indirizzi IPv6 statici in configurazione derivano dalla delega ricevuta in
modalità ONT e ora non sono più validi. Il problema non è che "IPv6 non
funziona": è che il router **continua ad annunciare ai client un DNS IPv6
morto**, causando timeout su ogni query e navigazione a scatti su tutta la
LAN. In un periodo in cui stai misurando la linea per un reclamo, è
esattamente il tipo di rumore da evitare.

**Opzione 1 — spegnimento netto (consigliata per il transitorio):**

```
/ipv6 settings set disable-ipv6=yes
/system reboot
```

**Opzione 2 — selettiva, senza riavvio:**

```
/ipv6 nd disable [find interface=bridge]
/ipv6 address disable [find]
/ipv6 route disable [find dst-address=::/0]
```

Nota: i client mantengono l'indirizzo IPv6 già assegnato finché non scade il
lifetime. Per accelerare, riavvia l'interfaccia di rete sui client o attendi
qualche minuto.

Verifica da un client che non ci sia più un default gateway IPv6 attivo.

#### A.4 Port forward sulla IliadBox

Con la box in router mode, **WireGuard e OpenVPN non sono raggiungibili da
internet** finché non inoltri le porte.

| Porta | Protocollo | Servizio | Destinazione |
|---|---|---|---|
| 51820 | UDP | WireGuard | IP WAN del MikroTik |
| 1194 | UDP | OpenVPN | IP WAN del MikroTik |

**Prima** di configurare i forward, fissa l'indirizzo del MikroTik sulla box
con una **prenotazione DHCP**: al primo rinnovo, altrimenti, i forward
puntano nel vuoto.

> ⚠️ La 1194 serve al **notebook di lavoro**, che non può installare
> WireGuard. Senza questo forward, da fuori casa non ti connetti.

**Alternativa rapida:** metti il MikroTik in **DMZ** sulla IliadBox. Meno
elegante, ma inoltra tutto e non devi ricordarti di nulla. Accettabile per un
periodo limitato, dato che il firewall del MikroTik resta comunque la vera
difesa.

`/ip cloud` continua a funzionare correttamente (rileva l'IP pubblico reale,
non quello privato della WAN), quindi il nome DDNS resta valido — ma senza
forward o DMZ non porta da nessuna parte.

#### A.5 Lascia un promemoria sul router

Il modo migliore per non dimenticare cosa hai toccato:

```
/system note set show-at-login=yes note="TRANSITORIO (2026-07): IliadBox in router mode. RAW spoofing 192.168 disabilitata, IPv6 spento, VPN dipendono dai port forward sulla box. Ripristinare tutto al ritorno in ONT - vedi note-importanti.md"
```

Compare a ogni login SSH/Winbox.

#### A.6 Verifiche del transitorio

- [ ] `/ip dhcp-client print` → `status=bound` con IP privato
- [ ] Navigazione IPv4 da un client
- [ ] DNS rapido (niente attese: se ci sono, IPv6 non è spento davvero)
- [ ] WireGuard da rete mobile → handshake presente
- [ ] OpenVPN dal notebook di lavoro fuori casa
- [ ] Speed test dalla LAN, per confronto con quelli fatti dalla box

#### A.7 Cosa aspettarsi dal doppio NAT

- Servizi in ingresso non inoltrati esplicitamente non funzionano
- UPnP dai client interni non arriva alla box
- Latenza aggiuntiva trascurabile (qualche decimo di ms)
- MTU: in router mode `ether1` è Ethernet normale a 1500, il PPPoE lo gestisce
  la box. L'MTU 1420 di WireGuard resta valido e conservativo, non toccarlo
- Lo **scheduler di pulizia del connection tracking** resta utile: il degrado
  progressivo dell'upload sul MikroTik è indipendente dalla modalità della box

---

### B — Ritorno alla modalità ONT

Da eseguire quando la questione con Iliad sarà chiusa.

#### B.1 Rimetti la box in modalità ONT/bridge

I port forward e la prenotazione DHCP decadono con il cambio di modalità.
Se avevi usato la DMZ, verifica che sia disattivata.

#### B.2 Rinnova l'indirizzo WAN e verifica che sia pubblico

```
/ip dhcp-client release [find interface=ether1]
/ip dhcp-client renew [find interface=ether1]
/ip address print where interface=ether1
```

Non proseguire finché non vedi un indirizzo pubblico.

#### B.3 Riabilita la protezione RAW

```
/ip firewall raw enable [find comment="RAW: Drop Spoofing 192.168"]
```

E rimuovi l'eccezione, se avevi scelto l'opzione 2:

```
/ip firewall raw remove [find comment="RAW: Eccezione IliadBox in router mode"]
```

Verifica lo stato finale:

```
/ip firewall raw print
```

Devono essere attive tutte e quattro le regole (TCP malformati + i tre
anti-spoofing).

#### B.4 IPv6 — riabilita **e correggi**, non solo riabilita

Questo è il punto in cui è facile sbagliare. Riaccendere IPv6 con i vecchi
indirizzi statici riporta esattamente il problema del DNS morto.

**1. Riattiva lo stack** (se avevi usato l'opzione 1):

```
/ipv6 settings set disable-ipv6=no
/system reboot
```

**2. Rileva il gateway reale della box:**

```
/ipv6 neighbor print where interface=ether1
```

Se la IliadBox è fisicamente la stessa, il MAC non è cambiato e il link-local
`fe80::3a07:16ff:fe20:3192` dovrebbe essere ancora valido — **ma verificalo**,
non darlo per scontato.

**3. Verifica il prefisso delegato attuale** e confrontalo con quello in
configurazione (`2a01:e11:401:a950::/64` e `a951::/64`). Dopo il reset della
box può essere cambiato.

**4. Aggiorna le tre voci:**

```
/ipv6 address set [find interface=ether1] address=PREFISSO-WAN::2
/ipv6 address set [find interface=bridge] address=PREFISSO-LAN::1
/ipv6 route set [find dst-address=::/0] gateway=fe80::XXXX%ether1
/ipv6 nd set [find interface=bridge] dns=PREFISSO-LAN::1
```

**5. Riabilita e testa:**

```
/ipv6 address enable [find]
/ipv6 route enable [find dst-address=::/0]
/ipv6 nd enable [find interface=bridge]
```

Da un client:

```
ping6 2606:4700:4700::1111
```

più una verifica su `https://test-ipv6.com`.

#### B.5 Verifica le VPN senza port forward

Ora le porte arrivano direttamente al MikroTik. Testa WireGuard da rete
mobile e OpenVPN dal notebook di lavoro.

#### B.6 Chiudi

```
/system note set show-at-login=no note=""
/system backup save name=mater-ont-AAAA-MM-GG
/export file=mater-ont-AAAA-MM-GG
```

Aggiorna il `.rsc` nel repo. Il `.backup` **no** — vedi
[Note per il futuro](#note-per-il-futuro).

---

## Checklist post-ripristino

Da eseguire in ordine, indipendentemente dal percorso scelto.

- [ ] **Accesso di gestione** — Winbox su `18291` e SSH su `2222` funzionano
      dalla LAN
- [ ] **WAN attiva** — `/ip dhcp-client print` mostra `status=bound` su `ether1`
- [ ] **Navigazione IPv4** — un client naviga correttamente
- [ ] **DNS** — `/ip dns cache print` si popola; le adlist sono cariche
      (`/ip dns adlist print`)
- [ ] **IPv6** — verificato o disabilitato (vedi sezione dedicata).
      **Non lasciarlo a metà.**
- [ ] **WireGuard** — i peer si connettano; `/interface wireguard peers print`
      mostra `last-handshake` recente
- [ ] **OpenVPN** — il notebook di lavoro si connette
- [ ] **Bridge** — `ether2..5` sono membri; `ether1` **NO** (è la WAN)
- [ ] **Servizi disabilitati** — `/ip service print`: `ftp`, `telnet`, `api`,
      `api-ssl` devono risultare disabilitati
- [ ] **Gestione remota WAN** — la regola `INPUT: Gestione remota WAN` deve
      restare `disabled=yes`. L'accesso da fuori passa solo da WireGuard.
- [ ] **Logging** — configurato secondo la scelta fatta (vedi
      [Gestione del logging](#gestione-del-logging)). Attenzione: il restore
      riporta il syslog remoto verso il Synology anche se lo avevi tolto.
- [ ] **Scheduler conntrack** — aggiunto (vedi sotto)
- [ ] **Nuovo backup** — `/system backup save name=post-ripristino-2026-07`
      **più** `/export file=conf-2026-07` (tienili entrambi)

---

## Miglioramenti da applicare

### 1. Scheduler pulizia connection tracking — IMPORTANTE

Questa conf è del 5 giugno, **precedente** alla diagnosi del degrado
progressivo dell'upload. Il MikroTik accumula stato che porta l'upload da
~160 a ~134 Mbps nel tempo. Riaggiungi:

```
/system scheduler add name=clean-conntrack interval=4h \
    on-event="/ip firewall connection remove [find]; :log info \"Connection state cleaned\"" \
    comment="Pulisci connection state ogni 4 ore"
```

### 2. Regola forward esplicita per WireGuard → LAN

Nella conf attuale il traffico da WireGuard verso la LAN passa **solo per la
default policy** (il drop finale filtra unicamente `ether1`). Funziona, ma è
fragile e darà fastidio quando attiverai restic dal VPS. Esplicitala:

```
/ip firewall filter add action=accept chain=forward \
    in-interface=wg-vpn out-interface=bridge \
    comment="VPN: WireGuard -> LAN" \
    place-before=[find comment="FORWARD: DROP FINALE (Sicurezza totale WAN->LAN)"]
```

### 3. Valori CAKE obsoleti

```
/queue simple add disabled=yes max-limit=500M/750M name=Smart-Queue-Global ...
```

In RouterOS la sintassi è `max-limit=upload/download`, quindi qui sono
500M in upload e 750M in download. L'upload reale della linea è **~160 Mbps**
(problema ISP, armadio di palazzo). È `disabled=yes` quindi non fa danni, ma
quando lo riattiverai usa valori realistici, tipo:

```
/queue simple set [find name=Smart-Queue-Global] max-limit=140M/1200M
```

Regola d'oro: 85–90% della banda reale misurata, per lasciare a CAKE il
margine di lavoro.

### 4. Scheduler mancante per la whitelist

C'è `run_adlist_update` (settimanale) ma **nessuno scheduler** invoca lo
script `update_whitelist`. O lo aggiungi, o lo lanci a mano quando modifichi
il file su GitHub.

```
/system scheduler add name=run_whitelist_update interval=1w \
    on-event=update_whitelist start-time=02:30:00 \
    policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    comment="Whitelist update settimanale"
```

### 5. Adlist con ssl-verify=no

Tutte le adlist hanno `ssl-verify=no`. Funziona, ma se vuoi irrobustire:
carica un CA bundle sul router e riabilita la verifica.

---

## Gestione del logging

### Com'è configurato di serie

La conf salvata invia i log a un syslog remoto sul Synology:

```
/system logging action add name=syslogsyno remote=192.168.10.250 \
    remote-log-format=syslog src-address=192.168.10.1 \
    syslog-facility=local0 syslog-severity=info target=remote

/system logging add action=syslogsyno topics=info
/system logging add action=syslogsyno topics=warning
/system logging add action=syslogsyno topics=error
/system logging add action=syslogsyno topics=critical
/system logging add action=syslogsyno topics=firewall
```

In più, due regole firewall hanno il logging attivo:

| Regola | Prefisso |
|---|---|
| `INPUT: DROP FINALE WAN` | `WAN-DROP-MGMT` |
| `FORWARD: DROP FINALE (Sicurezza totale WAN->LAN)` | `WAN-DROP-LAN` |

### Perché può diventare un problema

I topic `info` e soprattutto `firewall` sono ad alto volume. Con un IP
pubblico esposto direttamente — o con il MikroTik in **DMZ** sulla IliadBox —
le scansioni di massa da internet sono continue, e ogni pacchetto scartato
produce una riga.

Due effetti:

- **Sul Synology:** i log crescono rapidamente e rendono illeggibile tutto
  il resto
- **Sul router:** il ring buffer in memoria si riempie di rumore, e `/log print`
  diventa inutilizzabile proprio quando serve davvero

### Ridurre il rumore mantenendo l'utile — consigliato

Si disattivano i due topic verbosi e restano `warning`, `error`, `critical`:
volume bassissimo, ma se il router ha un problema serio te ne accorgi.

```
/system logging disable [find action=syslogsyno topics~"firewall"]
/system logging disable [find action=syslogsyno topics~"info"]
```

### Disattivare tutto il syslog remoto (reversibile)

```
/system logging disable [find action=syslogsyno]
/system logging print where action=syslogsyno
```

### Rimuovere definitivamente il syslog remoto

```
/system logging remove [find action=syslogsyno]
/system logging action remove [find name=syslogsyno]
```

### Silenziare le regole firewall

Indipendente dal syslog remoto: agisce anche sul log locale del router.

```
/ip firewall filter set [find log-prefix=WAN-DROP-MGMT] log=no
/ip firewall filter set [find log-prefix=WAN-DROP-LAN] log=no
```

Il firewall continua a scartare esattamente come prima, semplicemente senza
scrivere nulla.

### Riattivare

Se avevi solo **disabilitato**:

```
/system logging enable [find action=syslogsyno]
```

Se avevi **rimosso**, ricrea action e regole:

```
/system logging action add name=syslogsyno remote=192.168.10.250 \
    remote-log-format=syslog src-address=192.168.10.1 \
    syslog-facility=local0 syslog-severity=info target=remote

/system logging add action=syslogsyno topics=warning
/system logging add action=syslogsyno topics=error
/system logging add action=syslogsyno topics=critical
```

Aggiungi `info` e `firewall` solo se ti servono per una diagnosi specifica, e
ricordati di rimetterli giù dopo.

Per riattivare il log sulle regole firewall:

```
/ip firewall filter set [find log-prefix=WAN-DROP-MGMT] log=yes
/ip firewall filter set [find log-prefix=WAN-DROP-LAN] log=yes
```

### Diagnosticare senza inondare i log

Quando serve vedere cosa viene scartato, meglio una regola temporanea mirata
che riaccendere tutto:

```
/ip firewall filter add action=log chain=input \
    in-interface=ether1 protocol=tcp dst-port=LA-PORTA \
    log-prefix=DEBUG-TEMP \
    place-before=[find comment="INPUT: DROP FINALE WAN"]
```

E quando hai finito:

```
/ip firewall filter remove [find log-prefix=DEBUG-TEMP]
```

Oppure, per una fotografia immediata senza toccare le regole:

```
/tool sniffer quick interface=ether1 port=LA-PORTA
```

> ⚠️ **Il `.rsc` nel repo contiene ancora la configurazione syslog completa.**
> Se un giorno reimporti da lì, il logging verso il Synology torna attivo.
> Rigenera l'export dopo aver sistemato la configurazione.

---

## Dipendenze lato IliadBox

> **Il backup del MikroTik non ripristina nulla di quello che sta sulla box.**
> Se resetti la IliadBox, queste impostazioni spariscono senza lasciare
> traccia sul router — dove la configurazione continuerà a sembrare perfetta.
> È il tipo di guasto più difficile da diagnosticare, perché stai guardando
> nel posto sbagliato.

### Rotta IPv6 verso la LAN — la più importante

Lo schema usa due `/64` distinti:

| Prefisso | Dove |
|---|---|
| `2a01:e11:401:a950::/64` | collegamento MikroTik ↔ IliadBox |
| `2a01:e11:401:a951::/64` | LAN interna |

Perché il traffico di ritorno trovi la strada, **la IliadBox deve sapere che
`a951::/64` sta dietro il MikroTik**. Sul pannello della box, sottorete ID 1:

| Campo | Valore |
|---|---|
| Destinazione | `2a01:e11:401:a951::/64` |
| **Next Hop** | **`fe80::c6ad:34ff:fef2:f255`** |

⚠️ Il next hop è il **link-local di `ether1`** del MikroTik, **non**
`2a01:e11:401:a950::2`. È l'errore intuitivo da evitare.

L'indirizzo deriva dal MAC di `ether1` (`C4:AD:34:F2:F2:55`), quindi è
stabile: cambia solo se sostituisci l'apparato o forzi il MAC.

Per rileggerlo dal router:

```
/ipv6 address print detail where interface=ether1
```

**Sintomo se manca:** `test-ipv6.com` dà punteggio 0, i client hanno un
indirizzo IPv6 valido, e sul MikroTik non c'è assolutamente nulla fuori
posto.

### Altre impostazioni che vivono sulla box

| Cosa | Quando serve | Note |
|---|---|---|
| Modalità ONT/bridge vs router | sempre | determina se la WAN del MikroTik è pubblica o privata |
| Prefisso IPv6 delegato | sempre | verificato stabile attraverso un reset della box |
| Port forward 51820 / 1194 UDP | solo in router mode | vedi [Setup transitorio](#setup-transitorio--iliadbox-in-modalità-router) |
| DMZ verso il MikroTik | solo in router mode | alternativa ai forward |
| Prenotazione DHCP per il MikroTik | solo in router mode | senza, i forward puntano nel vuoto |

### Da rifare ogni volta che resetti la IliadBox

- [ ] Rimetti la modalità ONT/bridge
- [ ] **Rotta IPv6 sottorete ID 1** con il next hop link-local qui sopra
- [ ] Verifica che il prefisso delegato sia sempre lo stesso
- [ ] `/ping 2606:4700:4700::1111` dal router
- [ ] `test-ipv6.com` da un client — deve tornare 10

---

## Pulizia — voci obsolete

Occasione buona per fare ordine mentre ci sei.

**Lease DHCP di macchine non più esistenti:**

| Lease | Stato |
|---|---|
| `192.168.10.200` — ESXI | Migrato a Proxmox |
| `192.168.10.210` — UBUNTU HUB-1 | VM Ubuntu dismessa |

⚠️ Attenzione: `seal.home` e `cloud.home` in `/ip dns static` puntano
entrambi a `192.168.10.210`. Se quell'indirizzo cambia host, aggiornali.
Stesso discorso per il nome breve `esxi` → `192.168.10.200`.

**Interface list `LAN` inutilizzata:** viene creata con due membri
(`wg-vpn`, `bridge`) ma **nessuna regola firewall la usa**. O la usi nelle
regole, o è residuo da rimuovere.

**Voci whitelist strane:** `about-scheme`, `chrome-extension-scheme`,
`moz-extension-scheme`, `wyciwyg-scheme` ecc. non sono domini reali —
sono schemi di URL finiti nella whitelist per errore. Innocui ma inutili,
puliscili nel file `whitelist.txt` su GitHub.

---

## Note per il futuro

### Salva sempre entrambi i formati

```
/system backup save name=mater-AAAA-MM-GG
/export file=mater-AAAA-MM-GG
```

- Il **binario** serve per ripristinare davvero (chiavi, certificati, password)
- L'**export** serve per leggere, versionare su git e capire cosa è cambiato

Il `.rsc` va bene nel repo. **Il `.backup` no** — contiene chiavi private e
password. Tienilo fuori dal repo, o in un archivio cifrato.

### Cosa NON va mai nel repo pubblico

Il file `.rsc` che stai versionando contiene già:
- Public key WireGuard dei peer (accettabile, sono pubbliche per definizione)
- Indirizzi MAC dei dispositivi di casa
- Il numero di serie del router
- L'IP del VPS

Valuta se il repo deve restare pubblico. Le public key non sono un problema,
ma serial + MAC + topologia di rete insieme sono più informazioni di quante
serva regalare.

### Backup di rete fuori banda

Con la gestione remota WAN disabilitata, l'unico accesso da fuori è
WireGuard. Se il router si rompe mentre sei via, non entri. Se ti serve un
piano B, valuta un accesso via il VPS AlmaLinux con un tunnel sempre attivo.

---

*Ultimo aggiornamento: 2026-07-25*
