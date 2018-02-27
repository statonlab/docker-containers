FROM statonlab/drupal7

USER root

WORKDIR /var/www/html

RUN set -x \
	&& sudo -u postgres pg_ctl -D /var/lib/pgsql/data -l /var/log/pgsql.log start \
	&& git clone https://github.com/tripal/tripal.git sites/all/modules/custom/tripal \
	&& sleep 3 \
	&& drush en -y tripal tripal_chado tripal_chado_views tripal_ds tripal_ws \
	&& drush eval "module_load_include('inc', 'tripal_chado', 'includes/tripal_chado.install'); tripal_chado_load_drush_submit('Install Chado v1.3');" \
	&& drush trp-run-jobs --username=admin \
	&& drush eval "module_load_include('inc', 'tripal_chado', 'includes/setup/tripal_chado.setup'); tripal_chado_prepare_drush_submit();" \
	&& drush trp-run-jobs --username=admin

EXPOSE 80 5432

ENTRYPOINT ["init.sh"]
