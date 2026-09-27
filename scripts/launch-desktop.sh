#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/home/paolo/Apps/gods-eye-view"
APP_URL="http://127.0.0.1:4173"
LOG_FILE="$APP_DIR/.desktop-server.log"

cd "$APP_DIR"

if ! curl --silent --fail --max-time 1 "$APP_URL" >/dev/null 2>&1; then
  nohup npm run dev -- --host 127.0.0.1 --port 4173 >"$LOG_FILE" 2>&1 &

  ready=0
  for _ in $(seq 1 30); do
    if curl --silent --fail --max-time 1 "$APP_URL" >/dev/null 2>&1; then
      ready=1
      break
    fi
    sleep 1
  done

  if [ "$ready" -ne 1 ]; then
    echo "God's Eye View no pudo iniciar. Revisa: $LOG_FILE" >&2
    exit 1
  fi
fi

exec google-chrome-stable --app="$APP_URL" --class=GodsEyeView "$@"
