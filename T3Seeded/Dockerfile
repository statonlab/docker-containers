FROM statonlab/Tripal3

USER root

WORKDIR /var/www/html

RUN set -x \
	# Get the DB and apache up to populate the tables
	&& sudo -u postgres pg_ctl -D /var/lib/pgsql/data -l /var/log/pgsql.log start \
	&& apachectl \
	# Get tripal 3
	&& git clone https://github.com/statonlab/tripal_dev_mini_dataset.git \
	# Make sure the servers are up
	&& sleep 5 \
	# Delete, recreate DB
	&& sudo -u postgres dropdb drupal \
	&& sudo -u postgres createdb -O drupal -E 'utf8' drupal \
	# Read in latest seed SQL dump
	&& sudo -u postgres psql drupal < tripal_dev_mini_dataset/database_backups/latest.sql \
	# run updates if necessary
	&& drush updatedb -y\
	# Populate the cache
	&& curl localhost > /dev/null

EXPOSE 80 5432

ENTRYPOINT ["init.sh"]
