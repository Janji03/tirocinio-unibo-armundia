# **Integrazione di Apache 2.4.49 con Tomcat 8.5.32 tramite mod_jk**

## **Introduzione**
Nell’ambito del nostro progetto di penetration testing, abbiamo configurato **Apache 2.4.49** per fungere da proxy inverso per **Tomcat 8.5.32** utilizzando **mod_jk**. Questa configurazione sfrutta il protocollo **AJP (Apache JServ Protocol)** per la comunicazione tra i due server.

L’integrazione con mod_jk introduce una vulnerabilità critica: **CVE-2020-1938 (Ghostcat - AJP File Inclusion)**. Se il connettore AJP non è protetto adeguatamente, un attaccante può leggere file sensibili e, in alcuni casi, eseguire codice remoto.

---

## **1. Installazione di mod_jk**

Abbiamo scaricato e compilato **mod_jk** da sorgente per garantire la compatibilità con Apache:

```bash
cd /usr/local/src
sudo wget https://archive.apache.org/dist/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.48-src.tar.gz
sudo tar -xvzf tomcat-connectors-1.2.48-src.tar.gz
cd tomcat-connectors-1.2.48-src/native
```

Successivamente, abbiamo compilato e installato il modulo:

```bash
sudo ./configure --with-apxs=/usr/local/apache2/bin/apxs
sudo make
sudo make install
```

Questa operazione ha installato il file **mod_jk.so** nella directory dei moduli di Apache.

---

## **2. Configurazione di Apache con mod_jk**

Abbiamo creato un file di configurazione dedicato a mod_jk:

```bash
sudo nano /usr/local/apache2/conf/mod_jk.conf
```

Abbiamo aggiunto il seguente contenuto:

```
# Caricamento del modulo mod_jk
LoadModule jk_module modules/mod_jk.so

# Definizione del file di configurazione dei worker
JkWorkersFile /usr/local/apache2/conf/workers.properties

# Log di mod_jk
JkLogFile /usr/local/apache2/logs/mod_jk.log
JkLogLevel info

# Mappa delle richieste da Apache a Tomcat
JkMount /examples/* worker1
```

Abbiamo quindi incluso il file in **httpd.conf**:

```bash
echo "Include /usr/local/apache2/conf/mod_jk.conf" | sudo tee -a /usr/local/apache2/conf/httpd.conf
```

---

## **3. Configurazione dei worker di mod_jk**

Abbiamo creato il file di configurazione dei worker:

```bash
sudo nano /usr/local/apache2/conf/workers.properties
```

E aggiunto il seguente contenuto:

```
# Definizione del worker
worker.list=worker1

# Configurazione del worker AJP
worker.worker1.type=ajp13
worker.worker1.host=localhost
worker.worker1.port=8009
```

Questa configurazione permette ad Apache di comunicare con Tomcat attraverso **AJP sulla porta 8009**.

---

## **4. Configurazione di Tomcat per accettare connessioni AJP**

Abbiamo modificato il file **server.xml** di Tomcat:

```bash
sudo nano /opt/tomcat/tomcat/conf/server.xml
```

Abbiamo verificato che la configurazione del connettore AJP fosse attiva e vulnerabile:

```xml
<Connector port="8009" 
           protocol="AJP/1.3" 
           redirectPort="8443"
           address="0.0.0.0"
           secretRequired="false"
           allowedRequestAttributesPattern=".*" />
```

### **Perché questa configurazione è vulnerabile?**
- **`address="0.0.0.0"`** → Permette connessioni AJP da qualsiasi IP.
- **`secretRequired="false"`** → Disabilita l’autenticazione per il protocollo AJP.
- **`allowedRequestAttributesPattern=".*"`** → Rende Tomcat più esposto a manipolazioni tramite AJP.

Questa configurazione consente a un attaccante di sfruttare **Ghostcat (CVE-2020-1938)** per leggere file sensibili dal server.

---

## **5. Riavvio dei servizi e verifica**

Dopo aver completato la configurazione, abbiamo riavviato **Tomcat** e **Apache** per applicare le modifiche:

```bash
sudo systemctl restart tomcat
sudo /usr/local/apache2/bin/apachectl restart
```

Abbiamo verificato che entrambi i servizi fossero attivi e in ascolto sulle porte corrette:

```bash
sudo ss -tulnp | grep -E 'httpd|java'
```

**Output atteso:**
```
LISTEN  0  511  *:80    *:*  users:("httpd",pid=XXXXX,fd=4)
LISTEN  0  100  *:8009  *:*  users:("java",pid=YYYYY,fd=5)
```

Abbiamo testato l’integrazione accedendo a:

```
http://[IP_PUBBLICO]/examples/
```

Se la configurazione è corretta, la pagina degli **esempi di Tomcat** viene caricata **senza dover usare la porta 8080**, confermando che **Apache sta inoltrando le richieste a Tomcat tramite AJP**.

---



