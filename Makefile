-include .env
export $(shell sed 's/=.*//' .env)

export GUACAMOLE_HOSTNAME=${GUACAMOLE_CONTAINER}.${NGINX_HOSTNAME}
export GUACAMOLE_HTTP_URL=http://${GUACAMOLE_HOSTNAME}:${NGINX_PROXY_HTTP}
export GUACAMOLE_HTTPS_URL=https://${GUACAMOLE_HOSTNAME}:${NGINX_PROXY_HTTPS}
export GUACAMOLE_EXTERNAL_URL=${GUACAMOLE_HTTPS_URL}

.PHONY: env_var
env_var: # Print environnement variables
	@cat .env
	@echo
	@echo GUACAMOLE_HOSTNAME=${GUACAMOLE_HOSTNAME}
	@echo GUACAMOLE_HTTP_URL=${GUACAMOLE_HTTP_URL}/guacamole
	@echo GUACAMOLE_HTTPS_URL=${GUACAMOLE_HTTPS_URL}/guacamole
	@echo GUACAMOLE_EXTERNAL_URL=${GUACAMOLE_EXTERNAL_URL}/guacamole

.PHONY: env
env: # Create .env and tweak it before initialize
	cp .env.default .env

# Username: guacadmin
# Password: guacadmin
.PHONY: guacamole
guacamole: pull init up

.PHONY: pull
pull:
	docker pull guacamole/guacd:${GUACD_TAG}
	docker pull guacamole/guacamole:${GUACAMOLE_TAG}
	docker pull postgres:${POSTGRES_TAG}

.PHONY: init
init:
	umask 0022 && mkdir -p guacamole/{data,drive,init,record}
	umask 0022 && docker run --rm guacamole/guacamole:${GUACAMOLE_TAG} /opt/guacamole/bin/initdb.sh --postgres > ./guacamole/init/initdb.sql

.PHONY: erase
erase:
	rm -rf guacamole

.PHONY: config
config: # Show docker-compose configuration
	docker-compose -f docker-compose.yml config

.PHONY: up
up: # Start containers and services
	docker-compose -f docker-compose.yml up -d

.PHONY: down
down: # Stop containers and services
	docker-compose -f docker-compose.yml down

.PHONY: start
start: # Start containers
	docker-compose -f docker-compose.yml start

.PHONY: stop
stop: # Stop containers
	docker-compose -f docker-compose.yml stop

.PHONY: restart
restart: # Restart container
	docker-compose -f docker-compose.yml restart

.PHONY: delete
delete: down erase

.PHONY: mount
mount: init up

.PHONY: reset
reset: down up

.PHONY: hard-reset
hard-reset: delete mount

.PHONY: logs
logs: # Tail all logs; press Ctrl-C to exit
	docker-compose logs -f

.PHONY: logs-app
logs-app:
	docker logs ${GUACAMOLE_CONTAINER} -f

.PHONY: logs-d
logs-d:
	docker logs guacd -f

.PHONY: logs-db
logs-db:
	docker logs ${GUACAMOLE_CONTAINER}-db -f

.PHONY: logs-rails
logs-rails: # Drill down to a sub-directory of /var/log/gitlab
	docker exec -it ${GUACAMOLE_CONTAINER} gitlab-ctl tail gitlab-rails

.PHONY: logs-nginx
logs-nginx: # Drill down to an individual file
	docker exec -it ${GUACAMOLE_CONTAINER} gitlab-ctl tail nginx/GUACAMOLE_error.log

.PHONY: shell
shell: # Open a shell on a started container
	docker exec -it ${GUACAMOLE_CONTAINER} /bin/bash

.PHONY: shell-d
shell-d: # Open a shell on a started container
	docker exec -it guacd /bin/bash

.PHONY: shell-db
shell-db: # Open a shell on a started container
	docker exec -it ${GUACAMOLE_CONTAINER}-db /bin/bash

.PHONY: url
url:
	@echo ${GUACAMOLE_EXTERNAL_URL}
