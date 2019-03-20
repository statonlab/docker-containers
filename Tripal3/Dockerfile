FROM statonlab/drupal7

USER root

WORKDIR /var/www/html

RUN set -x \
	# Get the DB and apache up to populate the tables
	&& sudo -u postgres /usr/pgsql-9.6/bin/pg_ctl -D /var/lib/pgsql/9.6/data -l /var/log/pgsql.log start \
	&& apachectl \
	# Get tripal 3
	&& git clone https://github.com/tripal/tripal.git sites/all/modules/custom/tripal \
	# Make sure the servers are up
	&& sleep 5 \
	# Enable tripal 3 modules
	&& drush en -y tripal tripal_chado tripal_chado_views tripal_ds tripal_ws \
	# Prepare chado and drupal
	&& drush eval "module_load_include('inc', 'tripal_chado', 'includes/tripal_chado.install'); tripal_chado_load_drush_submit('Install Chado v1.3');" \
	&& drush trp-run-jobs --username=admin \
	&& drush eval "module_load_include('inc', 'tripal_chado', 'includes/setup/tripal_chado.setup'); tripal_chado_prepare_drush_submit();" \
	&& drush trp-run-jobs --username=admin \
	&& drush dis -y overlay \
	# Populate the cache
	&& curl localhost > /dev/null

EXPOSE 80 5432

ENTRYPOINT ["init.sh"]
