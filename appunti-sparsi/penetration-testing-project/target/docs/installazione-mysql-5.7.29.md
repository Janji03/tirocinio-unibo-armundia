# **Installazione di MySQL 5.7.29**

## **Introduzione**
MySQL 5.7.29 è stato installato manualmente su un'istanza AWS EC2 con Ubuntu. Questa versione è stata scelta perché contiene vulnerabilità note, tra cui **CVE-2020-2555**, che permette **SQL Injection e Privilege Escalation**. Configurando MySQL in modo insicuro, è possibile simulare attacchi reali in un ambiente controllato.

## **1. Preparazione del sistema**
### **Aggiornamento del sistema e installazione delle dipendenze**
Prima di scaricare e configurare MySQL, abbiamo aggiornato il sistema e installato le dipendenze necessarie:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install libaio1 libncurses5 -y
```

Queste dipendenze includono:
- **libaio1** → richiesto da MySQL per operazioni asincrone
- **libncurses5** → richiesto per la gestione del terminale

## **2. Download e installazione di MySQL 5.7.29**
Poiché questa versione non è più disponibile nei repository ufficiali, è stata scaricata manualmente e installata da sorgente:

```bash
cd /usr/local/src
sudo wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.29-linux-glibc2.12-x86_64.tar.gz
sudo tar -xvzf mysql-5.7.29-linux-glibc2.12-x86_64.tar.gz
sudo mv mysql-5.7.29-linux-glibc2.12-x86_64 /usr/local/mysql
```

Abbiamo poi creato l'utente e il gruppo dedicati per MySQL:

```bash
sudo groupadd mysql
sudo useradd -r -g mysql -s /bin/false mysql
```

Abbiamo assegnato i permessi corretti alla directory MySQL:

```bash
sudo chown -R mysql:mysql /usr/local/mysql
sudo chmod -R 755 /usr/local/mysql
```

## **3. Inizializzazione del database**
Prima di avviare MySQL, il database deve essere inizializzato:

```bash
cd /usr/local/mysql
sudo bin/mysqld --initialize --user=mysql
```

Durante questa operazione, MySQL genera una password temporanea per l'utente **root**, che deve essere utilizzata al primo accesso.

Abbiamo poi avviato MySQL con:

```bash
sudo bin/mysqld_safe --user=mysql &
```

Verifica che MySQL sia in ascolto sulla porta 3306:

```bash
sudo ss -tulnp | grep 3306
```

Output atteso:
```
tcp   LISTEN 0      80                0.0.0.0:3306       0.0.0.0:*    users:("mysqld",pid=XXXX,fd=XX)
```

## **4. Configurazione e accesso a MySQL**
Abbiamo effettuato l'accesso a MySQL con la password temporanea:

```bash
sudo /usr/local/mysql/bin/mysql -u root -p
```

E modificato la password per l'utente root:

```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'toor';
FLUSH PRIVILEGES;
```

Per consentire connessioni remote, abbiamo modificato il file di configurazione **/etc/my.cnf**:

```bash
sudo nano /etc/my.cnf
```

Aggiungendo:
```
bind-address = 0.0.0.0
```

E riavviato MySQL:

```bash
sudo pkill -9 mysqld
sudo /usr/local/mysql/bin/mysqld_safe --user=mysql &
```

## **5. Creazione di un database vulnerabile**
Abbiamo creato un database e un utente con permessi insicuri:

```sql
CREATE DATABASE vulnerable_db;
CREATE USER 'admin'@'%' IDENTIFIED BY 'admin123';
GRANT ALL PRIVILEGES ON vulnerable_db.* TO 'admin'@'%';
FLUSH PRIVILEGES;
```

Con questa configurazione, l'utente **admin** può accedere da qualsiasi IP (`%`), rendendo il database vulnerabile a brute-force e SQL Injection.

## **6. Verifica del database**
Per verificare che l'utente **admin** possa connettersi:

```bash
sudo /usr/local/mysql/bin/mysql -u admin -p -h 127.0.0.1
```

Se la connessione avviene con successo, significa che MySQL è configurato correttamente.

## **Conclusione**
Abbiamo installato e configurato MySQL 5.7.29 con impostazioni volutamente insicure per facilitare la concatenazione degli attacchi. Questa configurazione sarà utilizzata per integrare MySQL con Tomcat e successivamente con SSH per il completamento della catena di exploit.

