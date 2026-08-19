# syntax=docker/dockerfile:1.7
#
# PCOM - DI - Activiti
# --------------------
# Activiti 6.0.0 (BPM engine + apps) on Tomcat 8.5 for the Nubo Native Platform
# (NNP). Part of the Data Ingestion / integration components.
#
# Build:
#   docker build -t pcom-di-activiti:6.0.0-v1 .

FROM tomcat:8.5-jdk8-openjdk
ARG CATALINA_HOME=/opt/tomcat

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION="6.0.0-v1"

LABEL org.opencontainers.image.title="pcom-di-activiti" \
      org.opencontainers.image.description="Activiti 6.0.0 on Tomcat 8.5 for the NNP integration components." \
      org.opencontainers.image.vendor="Nubo Native Platform" \
      org.opencontainers.image.source="https://github.com/NNP-Platform-Components-PCOM/PCOM-DI-Activiti" \
      org.opencontainers.image.url="https://github.com/NNP-Platform-Components-PCOM/PCOM-DI-Activiti" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.created="${BUILD_DATE}"

ENV POSTGRESQL_DRIVER_VERSION=9.4-1201.jdbc41

RUN wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.0/bin/apache-tomcat-8.5.0.tar.gz \
    && tar xzvf apache-tomcat-8.5.0.tar.gz \
    && mkdir -p /opt/tomcat \
    && mv apache-tomcat-8.5.0/* /opt/tomcat/ \
    && chmod -R 777 /opt/tomcat/ \
    && chmod -R 777 /opt

RUN wget https://github.com/Activiti/Activiti/releases/download/activiti-6.0.0/activiti-6.0.0.zip -O /tmp/activiti.zip && \
    unzip /tmp/activiti.zip -d /tmp && \
    unzip /tmp/activiti-6.0.0/wars/activiti-app.war   -d ${CATALINA_HOME}/webapps/activiti-app && \
    unzip /tmp/activiti-6.0.0/wars/activiti-admin.war -d ${CATALINA_HOME}/webapps/activiti-admin && \
    unzip /tmp/activiti-6.0.0/wars/activiti-rest.war  -d ${CATALINA_HOME}/webapps/activiti-rest

COPY postgresql-42.7.3.jar ${CATALINA_HOME}/webapps/activiti-app/WEB-INF/lib/
COPY postgresql-42.7.3.jar ${CATALINA_HOME}/webapps/activiti-rest/WEB-INF/lib/
COPY postgresql-42.7.3.jar ${CATALINA_HOME}/webapps/activiti-admin/WEB-INF/lib/
COPY postgresql-42.7.3.jar ${CATALINA_HOME}/lib/

COPY groovy-json-4.0.9.jar ${CATALINA_HOME}/webapps/activiti-app/WEB-INF/lib/
COPY groovy-json-4.0.9.jar ${CATALINA_HOME}/webapps/activiti-rest/WEB-INF/lib/
COPY groovy-json-4.0.9.jar ${CATALINA_HOME}/webapps/activiti-admin/WEB-INF/lib/
COPY groovy-json-4.0.9.jar ${CATALINA_HOME}/lib/

COPY json-20240303.jar ${CATALINA_HOME}/webapps/activiti-app/WEB-INF/lib/
COPY json-20240303.jar ${CATALINA_HOME}/webapps/activiti-rest/WEB-INF/lib/
COPY json-20240303.jar ${CATALINA_HOME}/webapps/activiti-admin/WEB-INF/lib/
COPY json-20240303.jar ${CATALINA_HOME}/lib/

ADD . /tmp/activiti6
COPY config/context.xml ${CATALINA_HOME}/webapps/manager/META-INF/
COPY config/tomcat-users.xml ${CATALINA_HOME}/conf/

COPY start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 8080
CMD ["/usr/local/bin/start.sh"]
