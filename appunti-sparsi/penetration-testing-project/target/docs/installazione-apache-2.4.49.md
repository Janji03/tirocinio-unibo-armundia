# **Installazione di Apache 2.4.49**

## **Introduzione**
Apache 2.4.49 è stato installato manualmente da sorgente su un'istanza AWS EC2 con Ubuntu. Questa versione è vulnerabile a **CVE-2021-41773**, che consente **Path Traversal e Remote Code Execution (RCE)**. La scelta di questa versione permette di testare attacchi reali su un ambiente controllato.

## **1. Preparazione del sistema**
### **Aggiornamento del sistema e installazione delle dipendenze**
Prima di scaricare e compilare Apache, abbiamo aggiornato il sistema e installato le dipendenze necessarie:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install build-essential libpcre3 libpcre3-dev libssl-dev perl make libxml2 libxml2-dev -y
```

Queste dipendenze includono:
- **build-essential** → strumenti di compilazione (gcc, make)
- **libpcre3 e libpcre3-dev** → supporto alle espressioni regolari
- **libssl-dev** → supporto per SSL/TLS
- **libxml2 e libxml2-dev** → parsing XML

## **2. Download e compilazione di Apache 2.4.49**
Abbiamo scaricato i sorgenti da **archive.apache.org** (poiché la versione è stata rimossa dai repository ufficiali):

```bash
cd /usr/local/src
sudo wget https://archive.apache.org/dist/httpd/httpd-2.4.49.tar.gz
sudo tar -xvzf httpd-2.4.49.tar.gz
cd httpd-2.4.49
```

Dopo l'estrazione, abbiamo configurato la build:

```bash
sudo ./configure --enable-so --enable-ssl --with-mpm=event --prefix=/usr/local/apache2
```

Successivamente, abbiamo compilato e installato Apache:

```bash
sudo make
sudo make install
```

## **3. Verifica dell'installazione**
Abbiamo verificato che Apache fosse installato correttamente eseguendo:

```bash
/usr/local/apache2/bin/httpd -v
```

Output atteso:
```
Server version: Apache/2.4.49 (Unix)
Server built:   Mar 11 2025
```

## **4. Avvio di Apache**
Per avviare Apache:
```bash
sudo /usr/local/apache2/bin/apachectl start
```

Per verificare che Apache sia in ascolto sulla porta 80:
```bash
sudo ss -tulnp | grep :80
```

Output atteso:
```
LISTEN  0  511  *:80  *:*  users:("httpd",pid=XXXXX,fd=4)
```

Se Apache è in esecuzione, la pagina di default dovrebbe essere visibile visitando:
```
http://[IP_PUBBLICO]/
```
Risultato atteso: **pagina "It Works!" di Apache**.



