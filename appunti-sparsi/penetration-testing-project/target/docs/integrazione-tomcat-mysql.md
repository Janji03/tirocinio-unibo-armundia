# **Integrazione tra Tomcat e MySQL**

## **Introduzione**
L'integrazione tra **Apache Tomcat 8.5.32** e **MySQL 5.7.29** è stata configurata per permettere alle applicazioni web deployate su Tomcat di connettersi al database MySQL. Questa configurazione utilizza **JDBC (Java Database Connectivity)** e il **MySQL Connector/J**.

Per rendere il sistema più realistico e vulnerabile, abbiamo configurato **Tomcat per leggere credenziali MySQL memorizzate in chiaro** all'interno dei suoi file di configurazione.

## **1. Preparazione dell'ambiente**
Abbiamo verificato che Tomcat fosse installato e funzionante:

```bash
sudo systemctl status tomcat
```

E che MySQL fosse in esecuzione sulla porta 3306:

```bash
sudo ss -tulnp | grep 3306
```

Se MySQL non è attivo, avviarlo con:

```bash
sudo /usr/local/mysql/bin/mysqld_safe --user=mysql &
```

## **2. Creazione del database e dell'utente MySQL per Tomcat**
Abbiamo creato un database chiamato **tomcat_db** e un utente **tomcat** con permessi completi:

```sql
CREATE DATABASE tomcat_db;
CREATE USER 'tomcat'@'%' IDENTIFIED BY 'tomcat123';
GRANT ALL PRIVILEGES ON tomcat_db.* TO 'tomcat'@'%';
FLUSH PRIVILEGES;
```

Abbiamo verificato che l'utente potesse connettersi al database con:

```bash
sudo /usr/local/mysql/bin/mysql -u tomcat -p -h 127.0.0.1
```

## **3. Configurazione di Tomcat per MySQL**
Tomcat deve essere configurato per utilizzare il database. Per farlo, abbiamo modificato il file **context.xml**:

```bash
sudo nano /opt/tomcat/tomcat/conf/context.xml
```

Aggiungendo la seguente configurazione:

```xml
<Resource name="jdbc/tomcatdb"
          auth="Container"
          type="javax.sql.DataSource"
          username="tomcat"
          password="tomcat123"
          driverClassName="com.mysql.cj.jdbc.Driver"
          url="jdbc:mysql://127.0.0.1:3306/tomcat_db?autoReconnect=true&useSSL=false"
          maxActive="20"
          maxIdle="10"
          maxWait="-1"/>
```

Questa configurazione permette a Tomcat di connettersi a **tomcat_db** usando il driver MySQL.

## **4. Installazione del connettore JDBC per MySQL**
Abbiamo scaricato e installato il **MySQL Connector/J**, necessario per la connessione JDBC:

```bash
cd /opt/tomcat/tomcat/lib
sudo wget https://downloads.mysql.com/archives/get/p/3/file/mysql-connector-java-5.1.49.tar.gz
sudo tar -xvzf mysql-connector-java-5.1.49.tar.gz
sudo mv mysql-connector-java-5.1.49/mysql-connector-java-5.1.49-bin.jar /opt/tomcat/tomcat/lib/
```

Dopo l'installazione, abbiamo riavviato Tomcat:

```bash
sudo /opt/tomcat/tomcat/bin/shutdown.sh
sudo /opt/tomcat/tomcat/bin/startup.sh
```

## **5. Test della connessione con una pagina JSP**
Abbiamo creato una pagina di test JSP per verificare che Tomcat possa connettersi a MySQL. Il file **testdb.jsp** è stato creato nella directory ROOT di Tomcat:

```bash
sudo nano /opt/tomcat/tomcat/webapps/ROOT/testdb.jsp
```

Contenuto del file:

```jsp
<%@ page import="java.sql.*" %>
<html>
<head><title>Test MySQL Connection</title></head>
<body>
<h2>Testing MySQL Connection...</h2>
<%
    String url = "jdbc:mysql://127.0.0.1:3306/tomcat_db?autoReconnect=true&useSSL=false";
    String user = "tomcat";
    String password = "tomcat123";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(url, user, password);
        out.println("<h3>✅ Connection Successful!</h3>");
        conn.close();
    } catch (Exception e) {
        out.println("<h3>❌ Connection Failed: " + e.getMessage() + "</h3>");
    }
%>
</body>
</html>
```

Dopo aver salvato il file, abbiamo riavviato Tomcat:

```bash
sudo /opt/tomcat/tomcat/bin/shutdown.sh
sudo /opt/tomcat/tomcat/bin/startup.sh
```

E testato la connessione visitando:

```
http://[IP_PUBBLICO]:8080/testdb.jsp
```

Se la connessione è avvenuta con successo, la pagina mostra:

```
✅ Connection Successful!
```

## **Conclusione**
Abbiamo completato con successo l'integrazione tra Tomcat e MySQL. Tomcat ora può accedere a **tomcat_db**, e la configurazione memorizza le credenziali in chiaro, rendendo il sistema vulnerabile all'esfiltrazione di dati tramite path traversal o altri exploit.

