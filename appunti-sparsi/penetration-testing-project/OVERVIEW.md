# **Panoramica del Progetto di Penetration Testing**

## **Introduzione**
Questo progetto è stato sviluppato con l'obiettivo di creare un **ambiente controllato vulnerabile** su un'istanza **AWS EC2** per testare tecniche di penetration testing reali. L'idea alla base del progetto è quella di configurare un **server target vulnerabile** che possa essere attaccato da una macchina **Kali Linux**, utilizzando strumenti come **Metasploit** per identificare e sfruttare vulnerabilità note.

Abbiamo suddiviso il lavoro in **due fasi principali**:
1. **Fase 1 - Configurazione del Target** ✅ (Completata)
   - Installazione e configurazione di software vulnerabile.
   - Integrazione tra Apache e Tomcat tramite mod_jk.
   - Messa in sicurezza dell'ambiente per evitare interferenze esterne.
2. **Fase 2 - Attacco e sfruttamento delle vulnerabilità** (Prossima fase)
   - Ricognizione e scansione del target.
   - Utilizzo di exploit per compromettere il sistema.
   - Analisi dei risultati e documentazione degli attacchi.

---

## **Obiettivi del Progetto**
Il nostro obiettivo è simulare scenari di attacco reali, identificando le vulnerabilità presenti e comprendendo come possano essere sfruttate da un attaccante. Le fasi di questo penetration test ci aiuteranno a:
- **Comprendere le vulnerabilità più comuni** in software web e di rete.
- **Testare exploit noti** in un ambiente sicuro.
- **Documentare il processo** in modo dettagliato, così da poterlo replicare in futuro.

Abbiamo scelto una serie di applicazioni vulnerabili per costruire il nostro **server target**. Queste applicazioni rappresentano un mix di vulnerabilità legate a **server web, database, CMS e servizi di autenticazione**.

---

## **Ambiente e Tecnologie Utilizzate**
Il laboratorio di test è stato costruito utilizzando i seguenti strumenti:

- **Infrastruttura:** Istanza **AWS EC2 Ubuntu 20.04**
- **Target:** Server vulnerabile
  - **Apache 2.4.49** → CVE-2021-41773 (Path Traversal & RCE)
  - **Tomcat 8.5.32** → CVE-2020-1938 (Ghostcat - AJP File Inclusion)
  - **MySQL 5.7.29** → CVE-2020-2555 (SQL Injection, Privilege Escalation)
  - **WordPress 5.2.3** → CVE-2019-17671 (XSS, RCE)
  - **OpenSSH 7.2p2** → CVE-2016-0777 (Credential Leak, Brute-force)
- **Attaccante:** Macchina Kali Linux con Metasploit, Nmap e altri strumenti di pentesting.

L'integrazione tra Apache e Tomcat è stata gestita utilizzando **mod_jk**, permettendo di sfruttare la vulnerabilità **Ghostcat** (AJP File Inclusion) in un contesto reale.

---

## **Struttura della Repository**
Per garantire una documentazione chiara e ben organizzata, abbiamo suddiviso la repository Git in due macro-sezioni principali: **Target (server vulnerabile)** e **Offensive (attacco)**.

### 📁 **target/** (Setup del server vulnerabile)
- 📁 `docs/` → Documentazione dettagliata sulla configurazione.
- 📁 `configs/` → File di configurazione di Apache, Tomcat e altri servizi.
- 📁 `scripts/` → Script di automazione per l'installazione del target.

### 📁 **offensive/** (Attacco e sfruttamento delle vulnerabilità)
- 📁 `docs/` → Guide dettagliate sulle fasi di attacco.
- 📁 `exploits/` → Codici exploit personalizzati e testati.
- 📁 `scripts/` → Automazioni per le attività offensive.

### 📁 **reports/** (Resoconto finale)
- 📄 `penetration_test_report.md` → Documento che raccoglie i risultati degli attacchi effettuati e le analisi finali.

---

