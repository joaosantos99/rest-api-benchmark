.PHONY: build run summarize clean upload-mongo

tune:
	bash utils/sysctl.sh

build:
	docker compose build

run:
	bash orchestration/run-suite.sh

summarize:
	node utils/summarize.mjs

upload-mongo:
	node utils/upload-mongo.mjs

clean:
	docker compose down -v || true
	rm -rf results/raw/* results/summary/*
