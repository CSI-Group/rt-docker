#!/bin/bash

set -euf -o pipefail
docker compose -f docker-compose.yml run --rm rt bash -c 'cd /opt/rt5 && perl ./sbin/rt-setup-database --action init --skip-create'
docker compose -f docker-compose.yml run --rm rt bash -c 'cd /opt/rt5 && perl /opt/rt5/sbin/rt-setup-fulltext-index