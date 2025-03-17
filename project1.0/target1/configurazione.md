# **Dettaglio Completo della Configurazione dell'Istanza**

## **Introduzione**

Questa istanza è configurata per eseguire un'applicazione web vulnerabile, utilizzando tre principali componenti software: **Apache HTTP Server 2.4.49**, **Apache Tomcat 8.5.32**, e **MySQL 5.7.29**. 

## **Componente 1: Apache HTTP Server 2.4.49**

Apache HTTP Server, versione 2.4.49, è configurato come server web di front-end per l'applicazione. Apache è configurato per fare da **reverse proxy** per il traffico HTTP diretto verso **Tomcat**, il quale esegue effettivamente l'applicazione web. 

### **Configurazione di Apache**
1. **Reverse Proxy Configuration**:
   - Apache è configurato per agire come **reverse proxy** verso il server **Tomcat**, utilizzando il modulo `mod_proxy` per inoltrare le richieste HTTP in arrivo sulla porta 80 verso il server Tomcat che ascolta sulla porta 8080. Ciò consente agli utenti di accedere al servizio tramite Apache, mentre il traffico effettivo dell'applicazione è gestito da Tomcat.

   - Apache inoltra le richieste per `/app` alla macchina Tomcat sulla porta 8080, dove l'applicazione web è ospitata.

2. **Vulnerabilità di Apache (CVE-2021-41773)**:
   - La versione 2.4.49 di Apache contiene una vulnerabilità conosciuta come **Directory Traversal (CVE-2021-41773)**, che consente agli attaccanti di accedere a file al di fuori della root web server.
---


## **Componente 2: Apache Tomcat 8.5.32**

Apache Tomcat è configurato per ospitare l'applicazione web vulnerabile e ricevere il traffico da Apache HTTP Server. La configurazione di Tomcat include l'impostazione di un'applicazione web vulnerabile alla **SQL Injection**.

### **Configurazione di Tomcat**
1. **Manager e Host Manager Accessibili**:
   - L'accesso all'interfaccia di gestione di Tomcat è abilitato, e le credenziali predefinite (`admin:admin`) sono state lasciate intatte. Questo consente di accedere e gestire le applicazioni web attraverso il **Tomcat Manager**.
   - È stato abilitato anche l'accesso al **Host Manager**, che consente di monitorare e gestire le applicazioni ospitate su Tomcat.

2. **Applicazione Web Vulnerabile alla SQL Injection**:
   - L'applicazione web ospitata su Tomcat è vulnerabile alla **SQL Injection**, un errore di programmazione comune in cui l'input dell'utente non viene correttamente validato prima di essere utilizzato in una query SQL.
   - La pagina di login è configurata per ricevere il nome utente e la password dell'utente senza un'adeguata validazione, il che consente a un attaccante di manipolare le query SQL per ottenere accesso non autorizzato.

   La query SQL vulnerabile è simile alla seguente:
   ```sql
   SELECT * FROM users WHERE username = '" + username + "' AND password = '" + password + "'
L'attaccante può inserire comandi SQL malformati per bypassare l'autenticazione, permettendo l'accesso ai dati protetti o, in alcuni casi, l'esecuzione di codice non autorizzato.
Connessione al Database:
Tomcat è configurato per connettersi al database MySQL utilizzando una DataSource configurata nel file context.xml di Tomcat. Le credenziali di accesso sono scritte direttamente nel file di configurazione.
La connessione al database è stabilita come segue:
xml
Copy
<Resource name="jdbc/MySQLDB"
          auth="Container"
          type="javax.sql.DataSource"
          username="root"
          password="root"
          driverClassName="com.mysql.cj.jdbc.Driver"
          url="jdbc:mysql://localhost:3306/mydb"
          maxActive="100" maxIdle="30" minIdle="10"/>
--


## **Componente 3: MySQL 5.7.29**

MySQL è configurato come database backend per l'applicazione web ospitata su Tomcat. MySQL contiene una tabella `secrets` dove vengono memorizzati i dati sensibili, come il flag dell'attaccante.

### **Configurazione di MySQL**

#### **Creazione e Popolamento della Tabella `secrets`**:
Il database `mydb` contiene due tabelle principali: `users` e `secrets`. La tabella `secrets` è utilizzata per memorizzare i dati sensibili, inclusi i flag.

La tabella `secrets` è configurata come segue:

```sql
CREATE TABLE secrets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    flag VARCHAR(255) NOT NULL
);

I dati sensibili sono stati inseriti con il comando:  
INSERT INTO secrets (flag) VALUES ('dati_sensibili_1234');

Vulnerabilità di MySQL (Accesso Remoto e Credenziali Deboli):
MySQL è configurato per consentire connessioni remote con l'utente root e ha una configurazione insicura di accesso. L'utente root ha il permesso di connettersi da qualsiasi indirizzo IP (root@'%'), una configurazione che non dovrebbe mai essere utilizzata in ambienti di produzione, ma che è stata lasciata intatta per scopi di test.

La configurazione di MySQL non è ottimale, e l'uso di credenziali predefinite o deboli (root:root) espone il sistema a potenziali vulnerabilità, specialmente quando combinato con applicazioni web vulnerabili.

Permessi di Accesso:
Il database consente un accesso completo tramite l'utente root, che ha il privilegio di eseguire qualsiasi operazione sul database, inclusi SELECT, INSERT, UPDATE, DELETE. Questo permette all'attaccante, dopo aver ottenuto l'accesso a Tomcat tramite SQL Injection, di manipolare facilmente i dati all'interno del database, incluso il recupero del flag.

Concatenamento dei Componenti
La configurazione di questa istanza è progettata per sfruttare le vulnerabilità nei vari componenti in sequenza, permettendo a un attaccante di aggirare le protezioni e accedere ai dati sensibili memorizzati nel database.

Apache come Proxy:
Apache HTTP Server agisce come un proxy che indirizza il traffico verso Tomcat. In caso di malformazione o errata configurazione del proxy, Apache potrebbe introdurre problemi di comunicazione, ma in questo scenario il proxy è correttamente configurato e lavora come gateway verso Tomcat.

Tomcat come Servizio di Hosting:
Tomcat ospita l'applicazione web vulnerabile, che include una pagina di login vulnerabile alla SQL Injection. Tomcat è anche configurato per connettersi al database MySQL, utilizzando credenziali scritte nel file di configurazione.

MySQL come Storage dei Dati:
MySQL memorizza i dati sensibili, come il flag, in una tabella secrets. Dopo che l'attaccante ha ottenuto l'accesso a Tomcat tramite SQL Injection, può eseguire query dirette al database per estrarre il flag. L'accesso al database è facilitato da credenziali deboli e dalla configurazione permissiva.

