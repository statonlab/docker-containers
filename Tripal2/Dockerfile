FROM statonlab/drupal7

USER root

WORKDIR /var/www/html

RUN set -x \
	# Get the DB and apache up to populate the tables
	&& sudo -u postgres /usr/pgsql-9.6/bin/pg_ctl -D /var/lib/pgsql/9.6/data -l /var/log/pgsql.log start \
	&& apachectl \
	# Get Tripal 2:latest
	&& git clone https://github.com/tripal/tripal.git sites/all/modules/custom/tripal \
	&& cd sites/all/modules/custom/tripal \
	&& git checkout 7.x-2.x \
	&& cd /var/www/html \
	# Make sure the server woke up
	&& sleep 20 \
	# Enable tripal 2 main modules
	&& drush en -y tripal_core \
	&& drush eval "module_load_include('inc', 'tripal_core', 'includes/tripal_core.chado_install'); tripal_add_job('Install Chado v1.3', 'tripal_core','tripal_core_install_chado', ['Install Chado v1.3'], 1);" \
	&& drush trp-run-jobs --username=admin \
	&& drush en -y tripal_analysis tripal_contact tripal_cv tripal_db tripal_feature tripal_library tripal_organism tripal_views \
	# Populate the cache
	&& curl localhost > /dev/null

EXPOSE 80 5432

ENTRYPOINT ["init.sh"]
