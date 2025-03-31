
# Verifica della Connessione
La prima fase del testing ha riguardato la verifica della connessione di rete tra il nostro sistema offensivo (Kali Linux) e il target. Abbiamo configurato i Security Group in AWS per limitare l'accesso all'istanza target solo all'IP della macchina Kali e altre risorse interne, al fine di controllare e monitorare il traffico di rete.

Abbiamo testato la connettività tra Kali e la macchina target tramite:

Ping per verificare la disponibilità del server.

Nmap per identificare i servizi aperti e attivi sul target, in particolare la porta 80 per Apache, 8080 per Tomcat e 3306 per MySQL.

Una volta confermata la connettività e identificati i servizi in ascolto, abbiamo proceduto alla fase successiva del testing.

# Testing su Apache HTTP Server
La fase successiva ha visto il test di Apache HTTP Server. Abbiamo utilizzato Nmap e Nikto per eseguire una scansione di sicurezza sul servizio web, alla ricerca di potenziali vulnerabilità. Durante questa fase, abbiamo scoperto che Apache era vulnerabile a un attacco di tipo Directory Traversal, che permetteva l'accesso non autorizzato a file e directory del server.

In particolare, abbiamo identificato che l'interfaccia Tomcat Manager era accessibile senza restrizioni adeguate. Questo ha permesso di proseguire l'esplorazione della macchina target.

# Testing su Tomcat
Il passo successivo è stato Tomcat, che era configurato in modo errato con credenziali deboli (username: admin, password: admin), facilmente indovinabili tramite un attacco di forza bruta.

Con l'accesso a Tomcat Manager, abbiamo notato che il servizio permetteva il caricamento di file WAR (Web Application Archive), il che rappresentava una vulnerabilità significativa. Abbiamo quindi caricato un file WAR contenente una backdoor JSP, che ha consentito l'esecuzione di comandi remoti sul server compromesso.

Questa fase ha dimostrato come la configurazione errata e l'uso di credenziali deboli possano consentire a un attaccante di ottenere il controllo completo su una macchina che esegue Tomcat, sfruttando la possibilità di caricare e eseguire codice maligno.

# Testing su MySQL
L'ultima fase del testing si è concentrata su MySQL, il database che supporta l'applicazione web. Abbiamo utilizzato Nmap per identificare la porta di MySQL (3306) e confermare che fosse aperta. 

Siamo riusciti a connetterci al database utilizzando l'utente root. All'interno del database mydb, abbiamo identificato due tabelle principali: users e secrets. In particolare, la tabella users conteneva credenziali (username e password) in chiaro.

Abbiamo quindi eseguito una query per selezionare tutti i dati dalla tabella e successivamente abbiamo cercato di esportare i dati in un file CSV. Sebbene la configurazione del server MySQL impedisse l'esportazione diretta dei dati (a causa della protezione secure-file-priv), siamo riusciti a ottenere informazioni sensibili riguardanti gli utenti.

Analisi e Considerazioni Finali
Il penetration testing ha messo in luce diverse vulnerabilità critiche:

Apache HTTP Server: La vulnerabilità di Directory Traversal è stata identificata come un rischio significativo. Sebbene non sia stata sfruttata direttamente, questa vulnerabilità potrebbe permettere a un attaccante di esplorare la struttura di file del server.

Tomcat: Le credenziali deboli per l'accesso a Tomcat Manager e la possibilità di caricare file WAR vulnerabili hanno rappresentato una grave falla di sicurezza. La capacità di caricare un'applicazione web con backdoor ha consentito l'esecuzione di comandi remoti sul server compromesso.

MySQL: La mancanza di protezione adeguata per il database ha consentito l'accesso a informazioni sensibili, come credenziali di accesso e dati utente. Sebbene alcune restrizioni siano state in atto (ad esempio la protezione secure-file-priv), queste non sono state sufficienti a impedire l'accesso non autorizzato.

