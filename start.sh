#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="/Users/kriyanshi/test-dags-setup"
DAG_DIR="${DAG_DIR:-${ROOT_DIR}/dags}"
API_HOST="${API_HOST:-http://localhost:8080}"
UI_ORIGIN="${UI_ORIGIN:-http://localhost:8081}"
REMOTE_NODE="${REMOTE_NODE:-local}"
PAYLOAD='{"params":"1=\"foo\""}'

HEADERS=(
  -H 'Accept: */*'
  -H 'Accept-Language: en-US,en;q=0.8'
  -H 'Connection: keep-alive'
  -H "Origin: ${UI_ORIGIN}"
  -H "Referer: ${UI_ORIGIN}/"
  -H 'Sec-Fetch-Dest: empty'
  -H 'Sec-Fetch-Mode: cors'
  -H 'Sec-Fetch-Site: same-site'
  -H 'Sec-GPC: 1'
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36'
  -H 'content-type: application/json'
  -H 'sec-ch-ua: "Not;A=Brand";v="99", "Brave";v="139", "Chromium";v="139"'
  -H 'sec-ch-ua-mobile: ?0'
  -H 'sec-ch-ua-platform: "Windows"'
)

if ! compgen -G "${DAG_DIR}/*.yaml" >/dev/null; then
  echo "No DAG definition files found in ${DAG_DIR}" >&2
  exit 1
fi

echo "Enqueuing DAGs discovered in ${DAG_DIR}"

for dag_file in "${DAG_DIR}"/*.yaml; do
  [[ -f "${dag_file}" ]] || continue
  dag_name="$(basename "${dag_file}" .yaml)"

  echo "→ Enqueue ${dag_name}"
  curl "${API_HOST}/api/v2/dags/${dag_name}/enqueue?remoteNode=${REMOTE_NODE}" \
    "${HEADERS[@]}" \
    --data-raw "${PAYLOAD}"
done

echo "All DAGs enqueued."
