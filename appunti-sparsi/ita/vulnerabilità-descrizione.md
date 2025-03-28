# Documentazione sulle Vulnerabilità degli Script

## 1. Apache Struts 2.3.32

### **Descrizione**
Apache Struts è un framework open-source per lo sviluppo di applicazioni web in Java. Utilizza OGNL (Object-Graph Navigation Language) per l'elaborazione delle richieste e l'interazione con gli oggetti del server.

### **Funzionamento**
- Un utente invia una richiesta HTTP a una pagina web gestita da Struts.
- La richiesta viene interpretata dal framework e instradata a una classe di gestione denominata **Action Class**.
- La risposta viene formattata e restituita all'utente tramite JSP o un altro metodo di visualizzazione.

### **Vulnerabilità**
- **CVE-2017-5638**: Esecuzione di codice remoto (RCE) attraverso l'iniezione di comandi nell'header `Content-Type`.
- **Attacco**: Un attaccante può sfruttare una richiesta HTTP appositamente creata per eseguire codice arbitrario sul server con i permessi del processo Tomcat.
- **Impatto**: Accesso non autorizzato e potenziale compromissione dell'intero sistema.

---

## 2. Apache HTTPD

### **Descrizione**
Apache HTTPD è un server web utilizzato per servire pagine HTML e contenuti dinamici tramite moduli come PHP e CGI.

### **Funzionamento**
- Riceve richieste HTTP e restituisce pagine web.
- Può essere configurato per gestire autenticazione, logging e caching.

### **Vulnerabilità**
- **CVE-2017-9798**: Opzione `OPTIONS` mal configurata che può divulgare informazioni sensibili.
- **Directory Traversal**: Un attaccante può accedere a file sensibili sfruttando path manipolati (`../../../etc/passwd`).
- **Misconfigurazioni**: Permette l'esecuzione di script CGI non sicuri.

---

## 3. Jenkins

### **Descrizione**
Jenkins è un software per l'automazione CI/CD che consente di eseguire script per testing e deployment.

### **Funzionamento**
- Esegue build automatizzate per il test e il rilascio del codice.
- Include una console di scripting Groovy per personalizzare le esecuzioni.

### **Vulnerabilità**
- **CVE-2018-1000861**: Esecuzione di codice remoto (RCE) tramite interfaccia di scripting.
- **Accesso non autenticato alla console Groovy**: Può permettere a un attaccante di eseguire comandi con permessi elevati.

---

## 4. MySQL

### **Descrizione**
MySQL è un sistema di gestione di database relazionali (RDBMS) ampiamente utilizzato per memorizzare e gestire dati.

### **Funzionamento**
- Le applicazioni web si connettono al database tramite credenziali di accesso.
- Le query SQL vengono utilizzate per interrogare, modificare e gestire i dati.

### **Vulnerabilità**
- **Credenziali deboli (root:root, admin:admin)**: Attacco brute-force facilitato.
- **Accesso remoto attivato**: Qualsiasi utente può connettersi da internet.
- **SQL Injection**: Query manipolate possono permettere accesso non autorizzato o modifica dei dati.

---

## 5. PHP CGI

### **Descrizione**
PHP è un linguaggio di scripting per il web. La modalità CGI consente l'esecuzione di script PHP come processi separati.

### **Funzionamento**
- Apache riceve richieste HTTP e le passa a PHP tramite il modulo CGI.
- PHP interpreta il codice e restituisce una risposta HTML.

### **Vulnerabilità**
- **CVE-2012-1823**: Un attaccante può passare parametri per eseguire codice arbitrario (`? -d auto_prepend_file=evil.php`).
- **Impatto**: Controllo completo del server web tramite l'esecuzione remota di comandi.

---

## 6. Samba 3.0.20

### **Descrizione**
Samba è un software che permette la condivisione di file tra sistemi Linux e Windows tramite il protocollo SMB.

### **Funzionamento**
- Permette agli utenti di accedere a directory condivise sulla rete.
- Può essere configurato per richiedere autenticazione o consentire accesso anonimo.

### **Vulnerabilità**
- **CVE-2007-2447**: Un attaccante può eseguire comandi come root sfruttando una vulnerabilità nell'autenticazione SMB.
- **Guest access attivato**: Accesso libero ai file condivisi senza autenticazione.

---

## 7. vsftpd 2.3.4

### **Descrizione**
vsftpd è un server FTP utilizzato per la gestione di trasferimenti di file.

### **Funzionamento**
- Gli utenti si connettono tramite client FTP e possono caricare o scaricare file.

### **Vulnerabilità**
- **CVE-2011-2523**: Questa versione contiene una **backdoor** che permette accesso remoto con username `:)`.
- **Impatto**: Un attaccante può ottenere una shell remota sulla porta 6200.

---

## 8. WordPress + WP File Manager

### **Descrizione**
WordPress è un CMS per la gestione di siti web. I plugin espandono le sue funzionalità, ma possono introdurre vulnerabilità.

### **Funzionamento**
- Gli amministratori possono caricare contenuti e installare plugin.
- Il plugin WP File Manager consente la gestione dei file direttamente dal pannello di WordPress.

### **Vulnerabilità**
- **CVE-2020-25213**: Questo plugin permette l'upload di file PHP malevoli.
- **Impatto**: Un attaccante può ottenere una web shell e prendere il controllo del sito.

---



