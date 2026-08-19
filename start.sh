#!/bin/bash
set -e
set -x
CATALINA_HOME=${CATALINA:-/opt/tomcat}
DB=${DB:-postgresql}
DB_DRIVER=${DB_DRIVER:-org.postgresql.Driver}
DB_URL=${DB_URL:-jdbc:postgresql://postgresql:5432/activitidb}
DB_USERNAME=${DB_USERNAME:-activiti}
DB_PASSWORD=${DB_PASSWORD:-mypassword}
DB_DIALECT=${DB_DIALECT:-org.hibernate.dialect.PostgreSQLDialect}

case "${DB}" in
  h2|postgresql)
    sed 's#{{DB}}#'"${DB}"'#g' -i /tmp/activiti6/config/db.properties
    sed 's#{{DB_DRIVER}}#'"${DB_DRIVER}"'#g' -i /tmp/activiti6/config/db.properties
    sed 's#{{DB_URL}}#'"${DB_URL}"'#g' -i /tmp/activiti6/config/db.properties
    sed 's#{{DB_USERNAME}}#'"${DB_USERNAME}"'#g' -i /tmp/activiti6/config/db.properties
    sed 's#{{DB_PASSWORD}}#'"${DB_PASSWORD}"'#g' -i /tmp/activiti6/config/db.properties

    sed 's#{{DB_DRIVER}}#'"${DB_DRIVER}"'#g' -i /tmp/activiti6/config/activiti-app.properties
    sed 's#{{DB_URL}}#'"${DB_URL}"'#g' -i /tmp/activiti6/config/activiti-app.properties
    sed 's#{{DB_USERNAME}}#'"${DB_USERNAME}"'#g' -i /tmp/activiti6/config/activiti-app.properties
    sed 's#{{DB_PASSWORD}}#'"${DB_PASSWORD}"'#g' -i /tmp/activiti6/config/activiti-app.properties
    sed 's#{{DB_DIALECT}}#'"${DB_DIALECT}"'#g' -i /tmp/activiti6/config/activiti-app.properties
	
	sed 's#{{DB_DRIVER}}#'"${DB_DRIVER}"'#g' -i /tmp/activiti6/config/activiti-admin.properties
    sed 's#{{DB_URL}}#'"${DB_URL}"'#g' -i /tmp/activiti6/config/activiti-admin.properties
    sed 's#{{DB_USERNAME}}#'"${DB_USERNAME}"'#g' -i /tmp/activiti6/config/activiti-admin.properties
    sed 's#{{DB_PASSWORD}}#'"${DB_PASSWORD}"'#g' -i /tmp/activiti6/config/activiti-admin.properties
    sed 's#{{DB_DIALECT}}#'"${DB_DIALECT}"'#g' -i /tmp/activiti6/config/activiti-admin.properties

    cp -f /tmp/activiti6/config/activiti-app.properties ${CATALINA_HOME}/webapps/activiti-app/WEB-INF/classes/META-INF/activiti-app/
	cp -f /tmp/activiti6/config/activiti-admin.properties ${CATALINA_HOME}/webapps/activiti-admin/WEB-INF/classes/META-INF/activiti-admin/
    cp -f /tmp/activiti6/config/db.properties ${CATALINA_HOME}/webapps/activiti-rest/WEB-INF/classes/

    sed 's#create.demo.users=true#create.demo.users=false#g' -i ${CATALINA_HOME}/webapps/activiti-rest/WEB-INF/classes/engine.properties
    sed 's#create.demo.definitions=true#create.demo.definitions=false#g' -i ${CATALINA_HOME}/webapps/activiti-rest/WEB-INF/classes/engine.properties
    sed 's#create.demo.models=true#create.demo.models=false#g' -i ${CATALINA_HOME}/webapps/activiti-rest/WEB-INF/classes/engine.properties
    ;;
esac

catalina.sh run
