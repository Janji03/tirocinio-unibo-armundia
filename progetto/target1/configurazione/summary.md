# Vulnerabilità e Percorso di Attacco sull'Istanza

## Panoramica Generale

L'istanza è configurata con tre componenti principali: **Apache HTTP Server**, **Tomcat** e **MySQL**, ognuno dei quali ha vulnerabilità specifiche. Questi componenti sono collegati in modo che le vulnerabilità siano sfruttabili in sequenza, permettendo a un attaccante di "vincere" il sistema. In questo contesto, l'attaccante dovrà sfruttare vulnerabilità nelle applicazioni web (SQL Injection), la configurazione insicura di MySQL e la configurazione di Apache come proxy per compromettere completamente la macchina.

## 1. **Vulnerabilità su Apache HTTP Server**
### **CVE-2021-41773**: Directory Traversal
- **Descrizione**: Apache 2.4.49 è vulnerabile alla **CVE-2021-41773**, una vulnerabilità di tipo *Directory Traversal*. Questa vulnerabilità consente a un attaccante di accedere a file sensibili fuori dalla directory web di Apache, manipolando i percorsi delle richieste.
- **Sfruttabilità**: Se l'attaccante riesce a inviare una richiesta malformata verso il server Apache, può ottenere accesso a file confidenziali che potrebbero rivelare informazioni sulla configurazione, come i file di configurazione di Tomcat, MySQL e altri file sensibili.

## 2. **Vulnerabilità su Tomcat**
### **Credenziali Deboli e Manager App**
- **Descrizione**: Tomcat 8.5.32 è configurato con credenziali di accesso deboli nel suo **Manager App**, con nome utente e password di default ("admin:admin").
- **Sfruttabilità**: Se l'attaccante accede all'interfaccia di **Tomcat Manager** tramite il URL `http://<ip>:8080/manager/html`, può manipolare la configurazione di Tomcat, caricare applicazioni vulnerabili, o persino eseguire comandi arbitrari tramite le applicazioni ospitate.

### **SQL Injection nell'Applicazione Web**
- **Descrizione**: L'applicazione web ospitata su Tomcat è vulnerabile a **SQL Injection**. L'applicazione riceve input non filtrato dall'utente (username e password) e lo inserisce direttamente in una query SQL, rendendo possibile per un attaccante manipolare la query per ottenere accesso non autorizzato.
- **Sfruttabilità**: Attraverso la SQL Injection, l'attaccante può ottenere l'accesso al database MySQL, estrarre dati sensibili (ad esempio, il flag), e potenzialmente eseguire comandi SQL arbitrari.

## 3. **Vulnerabilità su MySQL**
### **Credenziali Deboli e Accesso Remoto**
- **Descrizione**: MySQL 5.7.29 è configurato con credenziali deboli, dove l'utente **root** ha accesso completo al database, e la connessione è permessa da qualsiasi indirizzo IP (`root@'%'`). Inoltre, la configurazione di MySQL non utilizza pratiche di sicurezza come la crittografia.
- **Sfruttabilità**: Se l'attaccante riesce a ottenere l'accesso al database tramite Tomcat (tramite SQL Injection), può eseguire query SQL, manipolare i dati e recuperare il flag (memorizzato nella tabella `secrets`).

## **Concatenamento delle Vulnerabilità**

### **Fase 1: Sfruttamento della vulnerabilità di Apache (CVE-2021-41773)**
- L'attaccante invia una richiesta HTTP malformata a Apache per sfruttare la **vulnerabilità di Directory Traversal**. Questo potrebbe consentire all'attaccante di accedere ai file di configurazione di Tomcat e MySQL.
- Se l'attaccante riesce a ottenere accesso ai file di configurazione, come il file `context.xml` di Tomcat, può raccogliere informazioni su come Tomcat è connesso al database MySQL, incluse le credenziali di accesso (root:root) e il nome del database (mydb).

### **Fase 2: Sfruttamento di Tomcat e dell'Applicazione Web**
- Una volta ottenute le informazioni da Apache, l'attaccante si collega al **Manager App** di Tomcat (`http://<ip>:8080/manager/html`) utilizzando le credenziali predefinite ("admin:admin").
- Con l'accesso al **Manager App**, l'attaccante può caricare e avviare applicazioni vulnerabili su Tomcat o manipolare la configurazione dell'applicazione esistente.
- Successivamente, l'attaccante sfrutta la vulnerabilità di **SQL Injection** nell'applicazione web per accedere al database MySQL, eseguire query SQL arbitrari e ottenere dati sensibili, inclusi i flag.

### **Fase 3: Sfruttamento di MySQL per Estrazione dei Dati Sensibili**
- Con l'accesso al database MySQL tramite SQL Injection, l'attaccante esegue una query per estrarre il contenuto della tabella `secrets`:
  ```sql
  SELECT * FROM secrets;
