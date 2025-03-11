# **Installazione di Tomcat 8.5.32**

## **Introduzione**
Apache Tomcat 8.5.32 è stato installato su un'istanza AWS EC2 con Ubuntu. Questa versione presenta diverse vulnerabilità, tra cui **CVE-2020-1938 (Ghostcat - AJP File Inclusion)**, che consente agli attaccanti di leggere file arbitrari e potenzialmente eseguire codice.

## **1. Preparazione del sistema**
Abbiamo aggiornato il sistema prima di procedere con l'installazione:

```bash
sudo apt update && sudo apt upgrade -y
```

Abbiamo installato **Java**, necessario per eseguire Tomcat:

```bash
sudo apt install default-jdk -y
```

Abbiamo verificato la versione di Java installata con:

```bash
java -version
```

Output atteso:
```
openjdk version "11.0.x" ...
```

## **2. Download e installazione di Tomcat**
Abbiamo scaricato Tomcat 8.5.32 direttamente da **archive.apache.org**:

```bash
cd /opt
sudo wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.32/bin/apache-tomcat-8.5.32.tar.gz
sudo tar -xvzf apache-tomcat-8.5.32.tar.gz
sudo mv apache-tomcat-8.5.32 tomcat
```

## **3. Configurazione dei permessi e avvio**
Abbiamo assegnato i permessi corretti:

```bash
sudo chown -R $USER:$USER /opt/tomcat
sudo chmod +x /opt/tomcat/bin/*.sh
```

Abbiamo avviato Tomcat manualmente:

```bash
cd /opt/tomcat/bin
sudo ./startup.sh
```

Abbiamo verificato che Tomcat fosse in esecuzione sulla porta 8080:

```bash
sudo ss -tulnp | grep :8080
```

Output atteso:
```
LISTEN  0  100  *:8080  *:*  users:("java",pid=XXXX,fd=XX)
```

Se tutto è corretto, la pagina iniziale di Tomcat è visibile a:
```
http://[IP_PUBBLICO]:8080/
```

## **4. Configurazione del servizio Tomcat (opzionale)**
Per avviare Tomcat automaticamente all’avvio del sistema, abbiamo creato un servizio systemd:

```bash
sudo nano /etc/systemd/system/tomcat.service
```

E aggiunto il seguente contenuto:

```
[Unit]
Description=Apache Tomcat 8.5.32
After=network.target

[Service]
User=ubuntu
Group=ubuntu
Type=forking
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
Restart=always

[Install]
WantedBy=multi-user.target
```

Abbiamo ricaricato systemd e abilitato il servizio:

```bash
sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat
```

Abbiamo verificato che Tomcat fosse attivo:
```bash
sudo systemctl status tomcat
```



