# **Target 1 Vulnerabilità Apache, Tomcat e MySQL**

## **Introduzione**

 Ho configurato un ambiente simulato con tre componenti principali: **Apache HTTP Server** (versione 2.4.49), **Apache Tomcat** (versione 8.5.32) e **MySQL** (versione 5.7.29). Ogni componente è stato configurato con vulnerabilità specifiche che insieme formano una catena di attacco concatenato. L'obiettivo dell'attaccante è sfruttare queste vulnerabilità per ottenere l'accesso a dati sensibili memorizzati nel database MySQL.

## **Componenti e Vulnerabilità**

1. **Apache HTTP Server 2.4.49 come Proxy**
   Apache HTTP Server versione 2.4.49 è configurato come un reverse proxy, inoltrando le richieste esterne al server Tomcat. Il suo ruolo di proxy verso Tomcat costituisce un punto di ingresso per l'attaccante, che può sfruttare le debolezze di Tomcat attraverso Apache.

2. **Apache Tomcat 8.5.32 e l'Applicazione Vulnerabile**
   Tomcat 8.5.32 ospita un'applicazione web vulnerabile a **SQL Injection**. La pagina di login dell'applicazione è configurata in modo errato, consentendo all'attaccante di manipolare le query SQL tramite input non validato. Questo permette di bypassare i controlli di accesso e ottenere l'accesso all'applicazione con credenziali arbitrarie.

3. **MySQL 5.7.29 e la Memorizzazione dei Dati Sensibili**
   MySQL 5.7.29 è configurato con una tabella `secrets` che contiene dati sensibili, come un flag che rappresenta l'obiettivo finale dell'attaccante. MySQL è configurato per permettere connessioni locali da Tomcat, ma presenta una configurazione di accesso insicura, che consente all'attaccante di interrogare il database una volta che è riuscito a ottenere l'accesso tramite l'applicazione vulnerabile di Tomcat.

## **Come Funziona l'Attacco Concatenato**

L'attacco concatenato sfrutta le vulnerabilità in **Apache**, **Tomcat** e **MySQL**, e può essere descritto nei seguenti passaggi:

1. **Accesso al Servizio Web**
   L'attaccante accede al sito web tramite Apache HTTP Server, che agisce come un intermediario tra l'attaccante e Tomcat. Il reverse proxy Apache inoltra la richiesta a Tomcat, dove è ospitata l'applicazione vulnerabile.

2. **SQL Injection**
   L'attaccante sfrutta la vulnerabilità di SQL Injection nella pagina di login di Tomcat. Invece di inserire credenziali valide, l'attaccante manipola l'input per modificare la query SQL, consentendo l'accesso non autorizzato.

3. **Accesso ai Dati Sensibili**
   Una volta ottenuto l'accesso all'applicazione, l'attaccante può eseguire una query SQL malformata per interrogare il database MySQL e recuperare il flag o altre informazioni sensibili dalla tabella `secrets`.

## **Obiettivo dell'Attacco**

L'obiettivo finale dell'attacco è ottenere il **flag** memorizzato nella tabella `secrets` del database MySQL. Una volta che l'attaccante ha ottenuto l'accesso all'applicazione tramite SQL Injection, può facilmente recuperare il flag e completare l'attacco.


