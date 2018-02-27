#!/usr/bin/env bash
bash /install-composer.sh
export PATH="/root/.composer/vendor/bin:$PATH"
supervisord -c /etc/supervisord.conf
