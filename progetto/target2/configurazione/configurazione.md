# **Dettaglio Completo della Configurazione dell'Istanza WordPress**

## **Introduzione**

Questa istanza è configurata per eseguire una versione vulnerabile di WordPress, utilizzando tre principali componenti software: **Apache HTTP Server 2.4.58**, **PHP 7.2.34**, e **MySQL 8.0.41**. L'obiettivo di questa configurazione è quello di testare la sicurezza di un ambiente WordPress vulnerabile, sfruttando una vulnerabilità XSS e un'altra vulnerabilità che verrà configurata tramite un plugin vulnerabile.

## **Componente 1: Apache HTTP Server 2.4.58**

Apache HTTP Server, versione 2.4.58, è configurato come server web per l'applicazione WordPress. Apache è configurato per gestire il traffico HTTP e inoltrarlo al server PHP che gestisce il contenuto dinamico di WordPress.

### **Configurazione di Apache**
1. **Reverse Proxy e Web Server**:
   - Apache è configurato per fungere da server web principale per WordPress. La configurazione prevede l'utilizzo di moduli come `mod_php` per gestire i file PHP e servire il contenuto di WordPress tramite il browser.
   
2. **Vulnerabilità (CVE-2021-41773)**:
   - Apache è configurato con la vulnerabilità **Directory Traversal (CVE-2021-41773)**, che consente a un attaccante di accedere ai file al di fuori della root del server web.

---

## **Componente 2: PHP 7.2.34**

PHP è il linguaggio di scripting che WordPress utilizza per generare contenuti dinamici. La versione di PHP utilizzata è la 7.2.34, che include diverse vulnerabilità conosciute e non più supportate ufficialmente.

### **Configurazione di PHP**
1. **Compatibilità con WordPress**:
   - La versione di PHP è compatibile con WordPress 4.7.x, che è la versione vulnerabile di WordPress che stiamo utilizzando.
   
2. **Vulnerabilità**:
   - L'uso di una versione di PHP non più supportata (7.2.34) introduce una vulnerabilità nel sistema, poiché non vengono più applicati aggiornamenti di sicurezza.

---

## **Componente 3: MySQL 8.0.41**

MySQL è configurato come database backend per WordPress. La versione di MySQL utilizzata è 8.0.41, che è una versione aggiornata, ma utilizzata con configurazioni di default che potrebbero essere vulnerabili.

### **Configurazione di MySQL**
1. **Database e Accesso**:
   - MySQL è configurato con un database denominato `wordpress`, utilizzato da WordPress per archiviare tutte le informazioni dinamiche del sito, tra cui utenti, post, e configurazioni.
   - L'utente `wp_user` è stato creato per accedere al database `wordpress` con privilegi limitati, ma configurato per l'accesso tramite una connessione insicura e utilizzando credenziali di default (debole).

2. **Vulnerabilità di MySQL (Credenziali Deboli)**:
   - MySQL è configurato con credenziali deboli per l'utente `wp_user`, che consente a chiunque di connettersi con il nome utente e la password predefiniti. Inoltre, l'accesso remoto non è stato limitato, aumentando il rischio di attacchi di tipo **brute force**.

---

## **Componente 4: WordPress 4.7.x**

WordPress è configurato con una versione vulnerabile (4.7.x), che presenta diverse vulnerabilità note, come la **Cross Site Scripting (XSS)**, che può essere sfruttata tramite i commenti degli utenti non filtrati.

### **Configurazione di WordPress**
1. **Plugin Vulnerabili**:
   - È stato installato il plugin **CommentPress** per introdurre la vulnerabilità di tipo **XSS**. La vulnerabilità permette a un attaccante di iniettare codice JavaScript malevolo nei commenti, che viene poi eseguito nel browser degli altri utenti che visualizzano il commento.
   
2. **Filtraggio dei Commenti**:
   - Il filtraggio dei commenti è disabilitato per consentire agli utenti di inserire script maligni nei commenti. Ciò consente a un attaccante di sfruttare la vulnerabilità XSS e rubare i dati delle sessioni degli utenti.

3. **Tema e Configurazione**:
   - WordPress è stato configurato con il tema predefinito e la pagina di benvenuto è visibile agli utenti. L'installazione è stata completata e il sito è ora funzionante.

---

## **Vulnerabilità Attivate su WordPress**
1. **XSS (Cross-Site Scripting)**:
   - La vulnerabilità XSS è attiva tramite il plugin vulnerabile **CommentPress**. Gli utenti malintenzionati possono inserire codice JavaScript nei commenti, che poi viene eseguito sui browser degli utenti che visualizzano i commenti.

2. **Seconda Vulnerabilità: Plugin Vulnerabile**:
   - Una seconda vulnerabilità, probabilmente tramite un altro plugin, sarà configurata successivamente per completare il setup dell'istanza vulnerabile. Questo plugin consentirà un altro tipo di attacco per testare la robustezza della configurazione di sicurezza di WordPress.

---

## **Concatenamento dei Componenti**

La configurazione di questa istanza è progettata per simulare un ambiente vulnerabile e sfruttare vulnerabilità nei vari componenti:

1. **Apache come Proxy e Web Server**:
   - Apache HTTP Server agisce come il server web principale per WordPress. L'uso di una versione vulnerabile di Apache e PHP espone l'istanza a rischi legati a vulnerabilità note.

2. **PHP come Processore di WordPress**:
   - La versione di PHP non aggiornata rende l'applicazione vulnerabile ad attacchi noti, come l'iniezione di codice dannoso attraverso plugin vulnerabili.

3. **MySQL come Storage**:
   - MySQL è configurato per consentire accesso remoto e vulnerabile, con l'utente `wp_user` che ha accesso completo al database. Questo consente a un attaccante che riesce a penetrare nell'applicazione di eseguire query dirette al database, manipolando i dati sensibili.

4. **WordPress come Target**:
   - WordPress è il target principale dell'attacco, con vulnerabilità sfruttabili tramite XSS e altri plugin vulnerabili. La configurazione corrente di WordPress permette di testare queste vulnerabilità in un ambiente controllato.

---

## **Prossimi Passi**

1. **Completare la Configurazione dei Plugin Vulnerabili**: Installare un altro plugin vulnerabile per rendere l'istanza più interessante per il penetration testing.
2. **Test di Penetration Testing**: Utilizzare gli strumenti di pen testing per attaccare l'istanza e verificare le vulnerabilità presenti, come XSS e altre vulnerabilità nel sistema.
3. **Documentare e Monitorare gli Attacchi**: Una volta che le vulnerabilità sono attive, documentare i risultati del penetration testing e monitorare i log per rilevare attività sospette.

---

