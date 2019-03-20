FROM centos:7
MAINTAINER Abdullah Almsaeed <abdullah@almsaeedstudio.com>

USER root

# Update the system and add any missing repos
RUN set -x \
	&& yum update -y

# Install services
# (Apache2, php7.1, posgtes, curl, git, zip, unzip, supervisor ... etc)
RUN set -x \
 	&& yum install -y wget curl git zip unzip httpd crontabs \
	&& wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
	&& wget http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
	&& rpm -Uvh remi-release-7.rpm epel-release-latest-7.noarch.rpm

# Database and other services
RUN set -x \
	&& yum install -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm \
	&& yum install -y postgresql96-server postgresql96-contrib \
    && yum install -y yum-utils \
    && yum-config-manager --enable remi-php71 \
    && yum update -y \
    && yum install -y mod_php php-mcrypt php-mbstring php-json php-posix php-pgsql \
      				  php-pdo php-xml php-curl php-gd supervisor sudo \
      				  patch which sendmail

WORKDIR /var/www/html

# Clean up the system
RUN yum clean all \
	&& rm -f epel-release-latest-7.noarch.rpm \
	&& rm -f remi-release-7.rpm

# Install composer and drush
COPY install-composer.sh /install-composer.sh
RUN chmod +x /install-composer.sh \
	&& /install-composer.sh \
	&& rm /install-composer.sh \
	&& mv composer.phar /usr/local/bin/composer \
	&& composer global require drush/drush:8.*

ENV PATH "/root/.composer/vendor/bin:/usr/pgsql-9.6/bin:$PATH"
ENV PGDATA "/var/lib/pgsql/9.6/data"

# Prepare the Database
RUN set -x \
	&& sudo -u postgres /usr/pgsql-9.6/bin/initdb -D /var/lib/pgsql/9.6/data \
	&& touch /var/log/pgsql.log \
	&& chown postgres:postgres /var/log/pgsql.log \
	&& sudo -u postgres /usr/pgsql-9.6/bin/pg_ctl -D /var/lib/pgsql/9.6/data -l /var/log/pgsql.log start \
	&& sleep 30 \
	# Centos postgres needs to accept UTF8 encoding
	&& sudo -u postgres /usr/pgsql-9.6/bin/psql -c "update pg_database set datistemplate=false where datname='template1';" \
	&& sudo -u postgres /usr/pgsql-9.6/bin/psql -c "drop database Template1;" \
    &&  sudo -u postgres /usr/pgsql-9.6/bin/psql -c "create database template1 with owner=postgres encoding='UTF-8' \
									 lc_collate='en_US.utf8' lc_ctype='en_US.utf8' template template0;" \
 	&& sudo -u postgres /usr/pgsql-9.6/bin/psql -c "update pg_database set datistemplate=true where datname='template1';" \
	&& sudo -u postgres /usr/pgsql-9.6/bin/createuser drupal \
	&& sudo -u postgres /usr/pgsql-9.6/bin/createdb -O drupal -E 'utf8' drupal \
	&& sudo -u postgres /usr/pgsql-9.6/bin/psql -c "ALTER USER drupal WITH password 'secret'" \
	# Download drupal and other modules
	&& wget https://www.drupal.org/files/projects/drupal-7.59.tar.gz \
	&& tar -zxvf drupal-7.59.tar.gz \
   	&& mv drupal-7.59/* ./ \
   	&& mv drupal-7.59/.editorconfig ./ \
   	&& mv drupal-7.59/.gitignore ./ \
   	&& mv drupal-7.59/.htaccess ./ \
   	&& rm -r drupal-7.59 drupal-7.59.tar.gz \
   	&& mkdir /var/www/html/sites/all/modules/custom \
   	&& cd /var/www/html/sites/all/modules \
   	&& drush dl -y ctools, date, devel, ds, link, entity, libraries, \
       redirect, token, uuid, jquery_update, views, webform, field_group, \
       field_group_table, field_formatter_class, field_formatter_settings \
	# Install Drupal and enable tripal dependencies
	&& cd /var/www/html \
	&& drush si --db-url=pgsql://drupal:secret@127.0.0.1/drupal --account-pass=secret -y \
	# Enable dependencies
	&& drush en -y ctools, date, devel, ds, link, entity, libraries, \
       redirect, token, uuid, jquery_update, views, webform, field_group, \
       field_group_table, field_formatter_class, field_formatter_settings \
    # Finally update drupal to the latest version
    && drush pm-update drupal -y

# Apply patches
RUN wget --no-check-certificate https://drupal.org/files/drupal.pgsql-bytea.27.patch \
    && patch -p1 < drupal.pgsql-bytea.27.patch \
    && cd /var/www/html/sites/all/modules/views \
    && wget --no-check-certificate https://raw.githubusercontent.com/tripal/tripal/7.x-3.x/tripal_chado_views/views-sql-compliant-three-tier-naming-1971160-30.patch \
    && patch -p1 < views-sql-compliant-three-tier-naming-1971160-30.patch

# Add custom modules dicrectory
RUN ln -s /var/www/html/sites/all/modules/custom /modules

# Set files directory permissions
RUN chown -R apache:apache /var/www/html/sites/default/files

# Expose http and psql port
EXPOSE 80 5432

# Configuration files
COPY supervisord.conf /etc/supervisord.d/app.ini
COPY apache.conf /etc/httpd/conf.d/apache.conf

# Activation scripts
COPY init.sh /usr/bin/init.sh
RUN chmod +x /usr/bin/init.sh

ENTRYPOINT ["init.sh"]
