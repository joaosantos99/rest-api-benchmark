.PHONY: tune build run summarize clean

tune:
	bash utils/sysctl.sh

build:
	docker compose build

run:
	bash orchestration/run-suite.sh

summarize:
	node utils/summarize.mjs

clean:
	docker compose down -v || true
	rm -rf results/raw/* results/summary/*
