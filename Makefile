#!/usr/bin/make -f

default:
	@echo "try make trigger"

build:
	docker compose -f compose.yml build

env:
	docker compose -f compose.yml up -d

trigger: env
	curl -s http://127.0.0.1:8080/off/ >/dev/null
	sleep 1
	for i in $$(jot 5); do \
		curl -s http://127.0.0.1:8080/on/test$${i} >/dev/null ; \
	done
	curl -fs http://127.0.0.1:9113/metrics | grep -- "^nginxplus_server_zone_responses" | egrep "5xx|502|503"

clean:
	docker compose -f compose.yml down

.PHONY: env trigger clean
