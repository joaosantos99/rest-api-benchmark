#!/usr/bin/env bash
set -euo pipefail

LANGS=(node bun deno golang rust python cpp csharp java17 java21 elixir perl scala php)
TESTS=(hello n-body pi-digits)
SIZES=("1 2g 0" "2 4g 0-1" "4 8g 0-3") # CPUS MEM CPUSET
REPS=1
BREAK=1

mkdir -p results/raw

for scen in $(jq -c '.[]' k6/scenarios.json); do
  NAME=$(jq -r '.name' <<<"$scen")
  VUS=$(jq -r '.vus' <<<"$scen")
  DUR=$(jq -r '.dur' <<<"$scen")

  for row in "${SIZES[@]}"; do
    for lang in "${LANGS[@]}"; do
      for test in "${TESTS[@]}"; do
        for rep in $(seq 1 $REPS); do
          read CPUS MEM CPUSET <<<"$row"

          export IMAGE="bench/${lang}"
          export SERVICE="${lang}"
          export TEST_MODE="${test}"
          export CPUS MEM CPUSET
          export HOST_PORT=18080

          echo "==> ${lang} ${test} ${CPUS}vCPU rep${rep} scen:${NAME} (${VUS} vus / ${DUR})"
          docker compose up --build -d sut
          sleep 2

          # adjust target URL according to server routes
          if [[ "$test" == "hello" ]]; then
            URL_PATH="/api/hello-world"
          else
            URL_PATH="/api/${test}"
          fi

          TARGET_URL="http://127.0.0.1:${HOST_PORT}${URL_PATH}"
          OUT="results/raw/${lang}_${test}_${CPUS}vCPU_rep${rep}_${NAME}.json"

          VUS=${VUS} DURATION=${DUR} TARGET_URL=${TARGET_URL} \
            k6 run \
              --summary-trend-stats="p(50),p(95),p(99),min,max,avg" \
              --summary-export "${OUT%.json}_summary.json" \
              k6/http-bench.js

          docker compose down -v
          echo "==> cooling down for ${BREAK}s"
          sleep ${BREAK}
        done
      done
    done
  done
done
