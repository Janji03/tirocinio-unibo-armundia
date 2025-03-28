#!/bin/bash

# File di log
LOG_FILE="/var/log/tomcat_install.log"

# Funzione di logging
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
}

# Aggiornamento dei pacchetti e installazione delle dipendenze
log "Inizio aggiornamento dei pacchetti e installazione delle dipendenze."
apt update && apt install -y openjdk-8-jdk wget unzip >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then
    log "Errore durante l'installazione delle dipendenze. Verificare i log."
    exit 1
fi
log "Dipendenze installate con successo."

# Download di Apache Tomcat
TOMCAT_VERSION="8.5.5"
log "Scaricamento di Apache Tomcat $TOMCAT_VERSION."
wget https://archive.apache.org/dist/tomcat/tomcat-8/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then
    log "Errore durante il download di Tomcat. Verificare i log."
    exit 1
fi

# Estrazione di Tomcat
log "Estrazione di Apache Tomcat."
tar -xvzf apache-tomcat-$TOMCAT_VERSION.tar.gz >> $LOG_FILE 2>&1
mv apache-tomcat-$TOMCAT_VERSION /opt/tomcat
if [ $? -ne 0 ]; then
    log "Errore durante l'estrazione di Tomcat. Verificare i log."
    exit 1
fi

# Configurazione dei permessi
log "Configurazione dei permessi degli script di Tomcat."
chmod +x /opt/tomcat/bin/*.sh >> $LOG_FILE 2>&1

# Avvio di Tomcat
log "Avvio di Apache Tomcat."
/opt/tomcat/bin/startup.sh >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then
    log "Errore durante l'avvio di Tomcat. Verificare i log."
    exit 1
fi
log "Apache Tomcat avviato con successo."

# Download di Apache Struts
STRUTS_VERSION="2.3.20"
log "Scaricamento di Apache Struts $STRUTS_VERSION."
wget https://archive.apache.org/dist/struts/$STRUTS_VERSION/struts-$STRUTS_VERSION-all.zip >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then
    log "Errore durante il download di Struts. Verificare i log."
    exit 1
fi

# Estrazione di Struts
log "Estrazione di Apache Struts."
unzip struts-$STRUTS_VERSION-all.zip >> $LOG_FILE 2>&1

# Deploy dell'applicazione Struts Showcase
log "Distribuzione dell'applicazione Struts2 Showcase."
mv struts-$STRUTS_VERSION/apps/struts2-showcase.war /opt/tomcat/webapps/ >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then
    log "Errore durante la distribuzione dell'applicazione. Verificare i log."
    exit 1
fi

log "Installazione completata con successo. Apache Tomcat e Struts sono pronti all'uso."
log "Visita l'URL: http://<IP_SERVER>:8080/struts2-showcase/index.action per accedere all'applicazione."
