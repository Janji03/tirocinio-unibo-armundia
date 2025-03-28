# Vulnerabilità e Percorso di Attacco sull'Istanza WordPress

## Panoramica Generale

Questa istanza è stata configurata per emulare un ambiente vulnerabile in modo controllato, utile per esercitazioni di penetration testing. Il sistema è composto da:

- **Apache HTTP Server 2.4.58**
- **PHP 7.2.34**
- **MySQL 8.0.41**
- **WordPress 4.7.0**

Ciascun componente è affetto da vulnerabilità note o è stato configurato in modo insicuro per aumentare la superficie di attacco. Le vulnerabilità sono pensate per essere concatenate e offrire un percorso logico e progressivo di compromissione.

---

## 1. **WordPress 4.7.0**

###  **RCE tramite REST API - CVE-2017-1001000**
- **Descrizione**: La versione 4.7.0 di WordPress contiene una vulnerabilità nella REST API che permette la modifica arbitraria di post anche senza privilegi adeguati.
- **Sfruttabilità**: L'attaccante può abusare della REST API per eseguire codice dannoso o iniettare contenuto arbitrario in pagine esistenti.
- **Fonte**: https://wpscan.com/vulnerability/9183

###  **CSRF e XSS in wp-admin**
- **Descrizione**: Alcune parti della dashboard di WordPress 4.7.0 sono vulnerabili a Cross-Site Scripting (XSS) e Cross-Site Request Forgery (CSRF).
- **Sfruttabilità**: Un attaccante può indurre un amministratore autenticato a eseguire azioni non volute o iniettare script nella dashboard.

---

## 2. **PHP 7.2.34**

###  **Memory corruption / Use After Free (CVE-2019-11043)**
- **Descrizione**: Sebbene questa vulnerabilità si manifesti in specifiche condizioni (FPM + NGINX), PHP 7.2.x include numerose vulnerabilità note che potrebbero essere combinate con altre configurazioni errate.
- **Sfruttabilità**: In ambienti particolari, potrebbe consentire esecuzione di codice remoto.

###  **Fine del supporto ufficiale**
- PHP 7.2 non riceve più aggiornamenti di sicurezza. Qualsiasi nuova vulnerabilità non viene corretta.

---

## 3. **MySQL 8.0.41**

###  **Configurazione con utente debole (`wp_user:password123`)**
- **Descrizione**: L'istanza MySQL accetta connessioni da WordPress tramite credenziali deboli configurate appositamente per facilitare SQL Injection.
- **Sfruttabilità**: Se un attaccante riesce a sfruttare un'iniezione SQL in WordPress, può ottenere accesso completo al database.

### **Nessuna restrizione IP su `wp_user@localhost`**
- Anche se l’accesso remoto non è abilitato per `wp_user`, in caso di compromissione del server, le query possono essere eseguite localmente per estrarre i flag.

---

## 4. **Apache HTTP Server 2.4.58**

###  **Nessuna vulnerabilità nota diretta (al momento)**
- Questa versione è aggiornata e sicura, ma può essere usata come vettore per esporre servizi PHP/WordPress.
- Se mal configurato, Apache può permettere directory listing, file upload non sicuri o esecuzione arbitraria di script PHP.

---

##  Percorso di Attacco Previsto

### **Fase 1 – Ricognizione e analisi WordPress**
1. L'attaccante visita `http://<ip>/wordpress/` e verifica la versione tramite il codice sorgente HTML o strumenti come WhatWeb o Wappalyzer.
2. Conferma che si tratta della versione 4.7.0, nota per contenere vulnerabilità pubbliche.

### **Fase 2 – Exploit della REST API (CVE-2017-1001000)**
1. L'attaccante invia richieste POST malformate alla REST API per modificare contenuti del sito senza autenticazione.
2. Potrebbe riuscire a iniettare JavaScript (XSS) in un post visibile da un amministratore oppure creare un backdoor PHP tramite contenuti.

### **Fase 3 – SQL Injection (se configurata nell'applicazione)**
1. Se è presente un plugin vulnerabile o un form custom con input non filtrati, l'attaccante può lanciare attacchi SQLi.
2. Una volta iniettato il payload, può ottenere dump delle tabelle, incluse `wp_users` e `secrets`.

### **Fase 4 – Estrazione Flag o Shell**
1. Con accesso ai dati o upload di una webshell via vulnerabilità REST API/XSS, l'attaccante può eseguire codice remoto.
2. Con accesso al filesystem o al DB può leggere il flag finale.

Esempio:
```sql
SELECT * FROM secrets;
```

---


