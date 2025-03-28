# Strumenti utilizzati nel Penetration Testing

Durante il nostro penetration testing, abbiamo utilizzato vari strumenti per mappare la rete, identificare vulnerabilità e sfruttarle. Qui di seguito viene fornita una panoramica degli strumenti usati e dei comandi principali.

---

## 1. **Nmap**
   **Descrizione:**
   Nmap è uno degli strumenti più utilizzati per la scansione delle porte e la mappatura della rete. Può identificare host attivi, porte aperte e i servizi in esecuzione sui target, ed è utile per raccogliere informazioni iniziali sui sistemi da testare.

   **Per cosa l'abbiamo usato:**
   - Scansione delle porte per identificare i servizi attivi.
   - Utilizzo di script per raccogliere informazioni aggiuntive (ad esempio, versioni di MySQL).
   - Identificazione di vulnerabilità e configurazioni del sistema.

   **Comandi utilizzati:**
   - **Scansione delle porte:**
     ```bash
     nmap -p 8080,3306 15.161.94.124
     ```
   - **Scansione MySQL:**
     ```bash
     nmap -p 3306 --script mysql-info 15.161.94.124
     ```
   - **Scansione di directory HTTP:**
     ```bash
     nmap -p 8080 --script http-enum 15.161.94.124
     ```

---

## 2. **Nikto**
   **Descrizione:**
   Nikto è uno scanner web server che consente di identificare vulnerabilità comuni nei server web, inclusi problemi di configurazione e vulnerabilità conosciute. Può anche rilevare le configurazioni di SSL/TLS non sicure e errori di configurazione nel server web.

   **Per cosa l'abbiamo usato:**
   - Identificazione di vulnerabilità nei server web (come Apache/Tomcat).
   - Rilevamento di configurazioni errate che potrebbero essere sfruttate durante l'attacco.

   **Comandi utilizzati:**
   - **Scansione di Tomcat Manager:**
     ```bash
     nikto -h http://15.161.94.124:8080/manager/html
     ```

---

## 3. **Hydra**
   **Descrizione:**
   Hydra è uno strumento di attacco a forza bruta che supporta diversi protocolli, inclusi SSH, FTP, HTTP, MySQL, e altri. È utilizzato per cercare di forzare le credenziali di accesso attraverso tentativi multipli con un dizionario di parole.

   **Per cosa l'abbiamo usato:**
   - Attacco a forza bruta contro il Tomcat Manager per recuperare le credenziali di amministrazione.
   - Esplorazione di possibili credenziali attraverso un file di dizionario.

   **Comandi utilizzati:**
   - **Attacco su Tomcat Manager:**
     ```bash
     hydra -l admin -P credentials.txt http-get-form "http://15.161.94.124:8080/manager/html:username=^USER^&password=^PASS^:F=incorrect"
     ```

---

## 4. **Medusa**
   **Descrizione:**
   Medusa è un altro strumento di attacco a forza bruta, simile a Hydra, ma con supporto per un numero maggiore di protocolli. È utilizzato per cercare di scoprire le credenziali di login su vari servizi remoti, come HTTP, FTP, SSH, ecc.

   **Per cosa l'abbiamo usato:**
   - Attacco a forza bruta per ottenere l'accesso a Tomcat Manager con il file di credenziali.

   **Comandi utilizzati:**
   - **Attacco a Tomcat Manager con Medusa:**
     ```bash
     medusa -h 15.161.94.124 -u admin -P credentials.txt -M http -m "GET /manager/html" -f "incorrect" -t 4
     ```

---

## 5. **Wireshark**
   **Descrizione:**
   Wireshark è uno strumento di analisi del traffico di rete. Permette di catturare pacchetti di rete in tempo reale, ispezionare i dettagli dei pacchetti e analizzare eventuali vulnerabilità nel traffico, come la trasmissione di credenziali in chiaro o la configurazione di SSL/TLS non sicura.

   **Per cosa l'abbiamo usato:**
   - Analisi del traffico di rete per identificare eventuali trasmissioni di dati sensibili non criptati.
   - Verifica della sicurezza delle comunicazioni tra il server e la macchina offensiva.

   **Comandi utilizzati:**
   - **Cattura traffico MySQL (porta 3306):**
     ```bash
     sudo wireshark -i eth0 -f "tcp port 3306"
     ```
   - **Filtraggio per protocolli MySQL:**
     Utilizzare il filtro in Wireshark:
     ```
     mysql
     ```

---

## 6. **Tcpdump**
   **Descrizione:**
   Tcpdump è uno strumento da riga di comando per catturare pacchetti di rete. È più leggero di Wireshark e consente di catturare pacchetti in tempo reale per un'analisi successiva, utile soprattutto per la cattura di traffico critico in situazioni dove Wireshark non è disponibile.

   **Per cosa l'abbiamo usato:**
   - Cattura pacchetti di rete per l'analisi del traffico MySQL o HTTP durante gli attacchi.
   - Salvare il traffico per un'analisi post-cattura.

   **Comandi utilizzati:**
   - **Cattura pacchetti su MySQL (porta 3306):**
     ```bash
     sudo tcpdump -i eth0 port 3306 -w mysql_traffic.pcap
     ```

---

## 7. **Gobuster**
   **Descrizione:**
   Gobuster è uno strumento di directory brute forcing che esplora un server web alla ricerca di directory o file nascosti, utile per scoprire potenziali aree vulnerabili di un'applicazione web.

   **Per cosa l'abbiamo usato:**
   - Esplorazione di directory su Tomcat e altre web app per trovare risorse o file nascosti che potrebbero contenere informazioni sensibili o vulnerabilità.

   **Comandi utilizzati:**
   - **Scansione di directory su Tomcat:**
     ```bash
     gobuster dir -u http://15.161.94.124:8080/manager/html -w /usr/share/wordlists/dirbuster/directory-list-2.3-small.txt
     ```

---

## 8. **MySQL Client**
   **Descrizione:**
   Il client MySQL è uno strumento da riga di comando per interagire con i server MySQL. Viene utilizzato per eseguire query SQL, recuperare dati e manipolare database.

   **Per cosa l'abbiamo usato:**
   - Connessione al database MySQL per recuperare dati sensibili, come credenziali, da tabelle vulnerabili.
   - Esplorazione e manipolazione dei dati all'interno del database MySQL.

   **Comandi utilizzati:**
   - **Connessione al server MySQL:**
     ```bash
     mysql -h 35.152.43.69 -u root -p --disable-ssl
     ```
   - **Recupero delle tabelle e dati:**
     ```bash
     SHOW DATABASES;
     USE mydb;
     SHOW TABLES;
     SELECT * FROM users;
     ```

---


