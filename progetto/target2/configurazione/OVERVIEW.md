# **Progetto di Penetration Testing: Configurazione della Seconda Istanza Target (WordPress Vulnerabile)**

## **Introduzione**

Il progetto si concentra sulla configurazione di un ambiente simulato con un'istanza EC2 di **Ubuntu 24.04**, destinata a ospitare un'installazione vulnerabile di **WordPress**. La configurazione include Apache HTTP Server, PHP, MySQL e WordPress, con vulnerabilità appositamente introdotte per facilitare la simulazione di attacchi, come **Cross-Site Scripting (XSS)** e **Remote Code Execution (RCE)**. 

## **Componenti e Vulnerabilità**

1. **Apache HTTP Server (versione 2.4.58)**
   Apache è stato configurato come server web per ospitare WordPress. Non sono state configurate vulnerabilità specifiche su Apache in questa fase, ma è configurato come server proxy per l'hosting di WordPress.

2. **PHP (versione 7.2.34)**
   PHP è configurato con una versione vulnerabile che potrebbe avere debolezze note (es. buffer overflow, vulnerabilità di sicurezza nei moduli) che possono essere sfruttate in fase di testing. PHP è stato configurato per supportare WordPress.

3. **MySQL (versione 5.7.29)**
   MySQL è stato configurato come database backend per WordPress, con un'installazione di base vulnerabile. Una tabella di database è predisposta per l'archiviazione di dati sensibili. La configurazione del database è progettata per essere vulnerabile a iniezioni SQL.

4. **WordPress (versione 4.7.x)**
   WordPress è stato installato con la versione vulnerabile 4.7.x, che presenta vari tipi di vulnerabilità conosciute, tra cui **SQL Injection**, **Cross-Site Scripting (XSS)** e **Remote Code Execution (RCE)**. In particolare, WordPress è configurato con temi e plugin vulnerabili, che sono utilizzati per creare un ambiente favorevole all'esecuzione di exploit.

## **Fasi di Configurazione**

1. **Configurazione Apache e PHP**
   - Apache è stato configurato come web server e proxy per il server WordPress.
   - PHP è stato installato in una versione vulnerabile per garantire che eventuali debolezze di sicurezza possano essere sfruttate.

2. **Installazione di MySQL e Configurazione del Database**
   - MySQL 5.7.29 è stato installato e configurato come server di database per WordPress.
  

3. **Installazione e Configurazione di WordPress**
   - WordPress è stato installato nella versione 4.7.x, vulnerabile a exploit come XSS, SQL Injection e RCE.
   - Sono stati installati e configurati plugin vulnerabili per testare attacchi specifici.

4. **Vulnerabilità Introdotte**
   - **XSS (Cross-Site Scripting)**: Il filtraggio dei commenti è stato disabilitato per permettere l'esecuzione di codice JavaScript nei commenti degli utenti.
   - **RCE (Remote Code Execution)**: È stata configurata una vulnerabilità di RCE tramite l'uso di un plugin vulnerabile che consente l'esecuzione di comandi remoti sul server.


