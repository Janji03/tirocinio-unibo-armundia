# 1. Preparazione dell'Ambiente

**Accesso alla Macchina Target**: Mi sono connesso all'istanza Ubuntu tramite RDP.

## Installazione delle Dipendenze

Ho tentato di eseguire il seguente comando per aggiornare i pacchetti e installare Java (OpenJDK 8), wget e unzip:  
***sudo apt update && sudo apt install -y openjdk-8-jdk wget unzip***  
Durante l'esecuzione, ho riscontrato un errore di permessi poiché il mio utente non era presente nel file `/etc/sudoers`. Ho quindi modificato questo file per concedere i permessi necessari al mio utente.

nome_utente ALL=(ALL) ALL 


# 2. Installazione di Apache Tomcat

## Download di Tomcat

Ho scaricato Apache Tomcat (versione 8.5.5) utilizzando `wget` con il seguente comando:

***wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.5/bin/apache-tomcat-8.5.5.tar.gz***  

## Estrazione dei File

Dopo il download, ho estratto l'archivio tar.gz con il comando:

***tar -xvzf apache-tomcat-8.5.5.tar.gz***  
Questo comando ha creato una directory chiamata `apache-tomcat-8.5.5`.

## Rinomina della Directory

Ho rinominato la directory per facilitare l'accesso con il comando:

***mv apache-tomcat-8.5.5 /opt/tomcat***  

## Configurazione dei Permessi

Per garantire che gli script nella cartella `bin` di Tomcat fossero eseguibili, ho modificato i permessi con:

***chmod +x /opt/tomcat/bin/*.sh***  

## Avvio di Tomcat

Ho avviato il server Tomcat eseguendo:

*** /opt/tomcat/bin/startup.sh***  
Ho controllato i log di avvio per assicurarmi che Tomcat fosse in esecuzione correttamente, visualizzando i messaggi che confermavano l'avvio.

# 3. Installazione di Apache Struts

## Download di Struts

Ho scelto di installare Apache Struts, optando per la versione 2.3.20. Ho scaricato il file zip contenente i file e le applicazioni con:

***wget https://archive.apache.org/dist/struts/2.3.20/struts-2.3.20-all.zip***  

## Estrazione e Navigazione

Dopo il download, ho estratto il file zip con:

***unzip struts-2.3.20-all.zip***  
Ho navigato nella directory `apps` per vedere le applicazioni disponibili:

cd struts-2.3.20/apps  
ls -l

Selezione dell'Applicazione
Ho scelto di utilizzare struts2-showcase.war, un'applicazione di esempio utile per testare vulnerabilità e dimostrare il funzionamento di Struts.

# 4. Deployment e Accesso
## Deploy dell'Applicazione
Ho spostato il file struts2-showcase.war nella directory webapps di Tomcat con il comando:

sudo mv struts2-showcase.war /opt/tomcat/webapps/

Una volta avviato Tomcat, ho aperto un browser e ho raggiunto la pagina di benvenuto dell'applicazione Struts2 Showcase all'URL:  
http://<IP_SERVER>/struts2-showcase/index.action  
Ho confermato che l'applicazione fosse stata distribuita correttamente visualizzando la pagina di benvenuto.