FROM tomcat:8-jre8                          
# MAINTAINER                                
MAINTAINER "Wissem"                         
# COPY WAR FILE ON TO Contaire              
COPY /target/Gestion.war /usr/local/tomcat/webapps
CMD ["catalina.sh", "run"]
EXPOSE 8080
