#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

echo "== Installing dependencies =="
bundle check || bundle install

echo "== Preparing database =="
bin/rails db:prepare

echo "== Starting Rails server =="
exec bin/dev
