# Report Pen Testing 
Il nostro obiettivo principale durante questa fase di penetration testing è stato testare la sicurezza di un'istanza di EC2 di AWS configurata con Apache, Tomcat e MySQL. Il nostro approccio si è sviluppato in varie fasi, a partire dalla verifica della connessione alla macchina target fino all'esplorazione approfondita di Apache, Tomcat e MySQL.

### ***Verifica della Connessione tra Offenser e Target***
La prima fase del testing ha riguardato la verifica della connessione di rete tra la macchina offensiva (Kali Linux) e il server target. Abbiamo configurato i gruppi di sicurezza in AWS per limitare l'accesso al server target solo alla nostra macchina Kali e ad altre risorse interne, al fine di garantire che l'attacco fosse effettuato solo da fonti autorizzate.

Per assicurarci che la connessione fosse attiva, abbiamo eseguito dei test con ping e scansioni di rete usando strumenti come Nmap, per identificare i servizi attivi sul server target. Una volta confermato che la connessione fosse corretta, siamo passati all'analisi dei singoli servizi che sarebbero stati oggetto del testing.

### ***Apache - Identificazione delle Vulnerabilità***
Il nostro primo obiettivo è stato Apache, il server web che ospita il nostro target. Utilizzando Nmap e Nikto, abbiamo analizzato il servizio web per identificare eventuali configurazioni deboli o vulnerabilità note. Durante questa fase, abbiamo scoperto che il server Apache era vulnerabile ad attacchi di tipo Directory Traversal, una vulnerabilità nota che permette di navigare nelle directory del sistema di file in modo non autorizzato.

Abbiamo quindi verificato le configurazioni di sicurezza e riscontrato che non erano state implementate protezioni adeguate. L'accesso a directory sensibili come la Tomcat Manager non era limitato, il che ci ha permesso di continuare l'esplorazione.

### ***Tomcat - Esplorazione e Sfruttamento delle Vulnerabilità***
Successivamente, abbiamo esaminato Tomcat, un'applicazione di servlet Java che eseguiva sul server. Tomcat è noto per presentare diverse vulnerabilità se configurato in modo errato. Abbiamo effettuato un accesso tramite l'interfaccia Tomcat Manager, che era protetta da credenziali deboli (admin:admin), che sono facilmente indovinabili con un attacco di forza bruta.

Dopo aver ottenuto l'accesso a Tomcat, abbiamo identificato una configurazione che permetteva il caricamento di file WAR (Web Application Archive). Abbiamo quindi caricato un'applicazione web vulnerabile contenente una backdoor JSP, che ci ha consentito di eseguire comandi remoti sul server e ottenere l'accesso completo al sistema.

Questa vulnerabilità è stata sfruttata in modo sistematico per testare la sicurezza del sistema, e abbiamo documentato il processo di caricamento di un file WAR con una backdoor per dimostrare come un attaccante possa facilmente compromettere Tomcat se non vengono implementate adeguate misure di sicurezza.

***MySQL - Esplorazione del Database e Accesso a Dati Sensibili***

La fase finale del penetration testing si è concentrata su MySQL, il database che supporta l'applicazione web. Dopo aver esaminato le configurazioni del server MySQL, abbiamo trovato che il database era vulnerabile a un attacco di tipo accesso remoto non sicuro, con la possibilità di connettersi utilizzando credenziali deboli.

Abbiamo quindi tentato di connetterci al database utilizzando il comando MySQL, ma inizialmente ci siamo imbattuti in problemi relativi alla protezione SSL. Dopo aver disabilitato SSL, siamo riusciti a connetterci al database con l'utente root e a esplorare le tabelle presenti. Tra queste, abbiamo trovato la tabella users, che conteneva informazioni sensibili come username e password.

Successivamente, abbiamo estratto i dati sensibili dal database eseguendo una semplice query SQL per selezionare tutte le informazioni nella tabella. In seguito, abbiamo anche tentato di esportare i dati in un file CSV, ma la protezione secure-file-priv impediva l'esportazione diretta su file di sistema, ma abbiamo comunque acquisito informazioni utili.

Abbiamo quindi dimostrato che la configurazione del database MySQL, non protetta correttamente, consentiva a un attaccante di ottenere informazioni sensibili con pochi passaggi.

## ***Conclusione***
La fase di penetration testing ha avuto successo, con l'identificazione e lo sfruttamento di vulnerabilità in Apache, Tomcat e MySQL. In particolare, l'uso di credenziali deboli in Tomcat Manager ha consentito di caricare file con backdoor, mentre la configurazione non sicura di MySQL ha permesso di ottenere informazioni sensibili dal database.

In sintesi, abbiamo confermato che una cattiva configurazione e l'uso di credenziali deboli rappresentano un grave rischio per la sicurezza dei sistemi. Questi risultati evidenziano la necessità di implementare pratiche di sicurezza migliori, come la gestione sicura delle credenziali e la protezione dei servizi con tecnologie di cifratura appropriate.