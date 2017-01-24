FROM openjdk:8-jdk-alpine
WORKDIR /opt/liquibase
ENV VERSION_LIQUIBASE 3.5.3
ENV VERSION_MYSQL_JDBC 5.1.40
RUN apk add --update curl bash \
 && rm -rf /var/cache/apk/* \
 && mkdir -p /opt/jdbc_drivers \
 && curl -LS -o /tmp/liquibase-bin.tar.gz https://github.com/liquibase/liquibase/releases/download/liquibase-parent-${VERSION_LIQUIBASE}/liquibase-${VERSION_LIQUIBASE}-bin.tar.gz \
 && tar zxvf /tmp/liquibase-bin.tar.gz -C /opt/liquibase \
 && chmod +x /opt/liquibase/liquibase \
 && rm /tmp/liquibase-bin.tar.gz \
 && ln -s /opt/liquibase/liquibase /usr/local/bin/ \
 && curl -LS -o mysql-connector-java-${VERSION_MYSQL_JDBC}.zip http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${VERSION_MYSQL_JDBC}.zip \
 && unzip mysql-connector-java-${VERSION_MYSQL_JDBC}.zip -d /opt/jdbc_drivers/ \
 && chmod +x /opt/jdbc_drivers/mysql-connector-java-${VERSION_MYSQL_JDBC}/mysql-connector-java-${VERSION_MYSQL_JDBC}-bin.jar \
 && mkdir -p /opt/liquibase/lib/ \
 && ln -s /opt/jdbc_drivers/mysql-connector-java-${VERSION_MYSQL_JDBC}/mysql-connector-java-${VERSION_MYSQL_JDBC}-bin.jar /opt/liquibase/lib/ \
 && cp /opt/jdbc_drivers/mysql-connector-java-${VERSION_MYSQL_JDBC}/mysql-connector-java-${VERSION_MYSQL_JDBC}-bin.jar /opt/jdbc_drivers/mysql.jar \
 && curl -LS -o /opt/jdbc_drivers/postgresql.jar https://search.maven.org/remotecontent?filepath=org/postgresql/postgresql/9.4.1211/postgresql-9.4.1211.jar
ADD scripts /opt/liquibase/scripts
RUN chmod -R +x /opt/liquibase/scripts
VOLUME /changelogs
ENTRYPOINT ["./scripts/liquibase_command.sh"]
