# Rimedi per la Sicurezza dell'Istanze Target
Nel corso del penetration testing abbiamo identificato diverse vulnerabilità nell'istanza target, che potrebbero essere sfruttate da un attaccante per compromettere il sistema. In base ai risultati ottenuti, sono stati individuati alcuni rimedi per mitigare queste vulnerabilità e rafforzare la sicurezza dell'istanza. Di seguito vengono descritti i principali rimedi che dovrebbero essere implementati per rendere l'istanza più sicura.

### 1. ***Rendere i Servizi Web più Sicuri***
Apache HTTP Server
Vulnerabilità: Apache è stato configurato con versioni vulnerabili (ad esempio la versione 2.4.49) e configurazioni poco sicure, che consentivano di sfruttare attacchi come la CVE-2021-41773 (Directory Traversal).

Rimedi:

Aggiornamento della versione di Apache: Aggiornare Apache alla versione più recente e stabile disponibile. Le versioni più vecchie spesso contengono vulnerabilità note, che possono essere facilmente sfruttate.

Disabilitare moduli inutilizzati: Alcuni moduli non necessari, come mod_status, mod_info, ecc., dovrebbero essere disabilitati per ridurre la superficie di attacco.

Implementare una corretta configurazione del file .htaccess: Utilizzare il file .htaccess per limitare l'accesso a directory sensibili e abilitare correttamente la protezione contro l'accesso non autorizzato.

Utilizzare HTTPS: Configurare correttamente SSL/TLS per garantire che tutto il traffico web sia cifrato, prevenendo così attacchi man-in-the-middle (MITM).

Tomcat
Vulnerabilità: Tomcat era esposto a attacchi tramite l'interfaccia Manager App, che non era adeguatamente protetta, consentendo l'esecuzione di applicazioni malevole (come WAR files contenenti backdoor).

Rimedi:

Limitare l'accesso all'interfaccia Manager: Configurare l'accesso a Tomcat Manager solo per determinati IP (ad esempio l'indirizzo IP dell'amministratore) tramite la configurazione dei security group.

Aggiornare Tomcat: Aggiornare Tomcat alla versione più recente per correggere vulnerabilità note.

Disabilitare l'accesso non necessario: Disabilitare l'accesso a funzionalità come il caricamento di file WAR se non strettamente necessario. Configurare correttamente i permessi di accesso a Tomcat.

Sicurezza delle credenziali: Cambiare le credenziali di default come "admin:admin", utilizzando password forti e complesse per gli utenti di Tomcat Manager.

### ***2. Sicurezza del Database MySQL***
MySQL
Vulnerabilità: Il database MySQL era configurato per accettare connessioni da indirizzi IP esterni (ad esempio 0.0.0.0), con credenziali deboli (ad esempio "root:root"), permettendo attacchi come l'accesso non autorizzato al database.

Rimedi:

Limitare l'accesso al database: Configurare il database MySQL per consentire solo connessioni locali o da IP autorizzati. Modificare il parametro bind-address per ascoltare solo su 127.0.0.1 o indirizzi IP specifici.

Modificare le credenziali deboli: Cambiare le credenziali di default e utilizzare password forti per gli utenti MySQL. In particolare, evitare di utilizzare l'utente root per le operazioni quotidiane e creare utenti con privilegi limitati.

Abilitare SSL/TLS: Configurare MySQL per utilizzare una connessione sicura tramite SSL/TLS, impedendo attacchi man-in-the-middle.

Aggiornare MySQL: Assicurarsi che MySQL sia aggiornato all'ultima versione stabile, che contenga correzioni di sicurezza.

### ***3. Controlli sui File di Configurazione***
File di Configurazione Esposti
Vulnerabilità: Alcuni file di configurazione come server.xml, context.xml e tomcat-users.xml erano esposti e contenevano informazioni sensibili, come credenziali per accedere a Tomcat e al database.

Rimedi:

Protezione dei file sensibili: Proteggere l'accesso a file di configurazione sensibili tramite i permessi di file e le configurazioni di accesso. Assicurarsi che questi file non siano leggibili da utenti non autorizzati.

Non memorizzare credenziali in chiaro: Utilizzare soluzioni come variabili d'ambiente o file di configurazione separati per memorizzare le credenziali, evitando di inserirle direttamente nei file di configurazione.

### ***4. Controllo degli Accessi e Auditing***
Vulnerabilità: L'accesso all'istanza EC2 non era correttamente limitato ai soli utenti autorizzati, permettendo potenzialmente attacchi di forza bruta o attacchi di tipo brute-force.

Rimedi:

Implementare politiche di accesso rigorose: Configurare i security group per permettere solo gli accessi provenienti da IP e reti sicure, utilizzando VPN o indirizzi IP fissi per limitare l'accesso.

Attivare l'auditing delle connessioni: Abilitare il logging e il monitoraggio delle connessioni al sistema e al database, in modo da poter rilevare attività sospette e intrusioni in tempo reale.

Rafforzare le politiche di password: Implementare una politica di password sicure per gli utenti, che obblighi l'utilizzo di password lunghe e complesse. Evitare l'uso di credenziali di default.

### ***5. Monitoraggio e Aggiornamenti Continuativi***
Vulnerabilità: La macchina target non veniva monitorata continuamente per vulnerabilità note o aggiornamenti di sicurezza.

Rimedi:

Abilitare il monitoraggio continuo: Utilizzare strumenti di monitoraggio per analizzare il traffico di rete, il comportamento del sistema e il comportamento delle applicazioni in tempo reale. Ciò aiuterà a rilevare eventuali attività anomale.

Pianificare aggiornamenti regolari: Implementare un piano di aggiornamenti periodici per il sistema operativo, le applicazioni e i servizi, in modo da correggere le vulnerabilità man mano che vengono scoperte.

