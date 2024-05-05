#!/usr/bin/env bash

set -e

export d="docker"
export dc="docker compose"

function script_usage() {
  cat << HLP
Usage:
  ./$(basename "$0") [options]

Options:
  -h, --help    Show this message
  -v, --version Sentry version to test against
HLP
}

function parse_opts() {
  local opt

  if [[ $# == 0 ]]
  then
    script_usage
    exit 0
  fi

  while [[ $# -gt 0 ]]
  do
    opt="$1"
    shift
    case $opt in
      -h | --help)
        script_usage
        exit 0
        ;;
      -v | --version)
        version=$1
        if [[ -z "${version}" ]]
        then
          echo "Invalid argument for ${opt} option, should be non empty string"
          exit 1
        fi
        shift
        ;;
      *)
        echo "Invalid option provided: $opt"
        exit 1
        ;;
    esac
  done
}

function log() {
  echo "[$(date -u +%Y-%m-%d-%H:%M:%SZ)] === $1"
}

function prepare_test_environment() {
  log "Preparing test environment…"
  $dc up --detach
  $dc exec -it snuba sh -c 1>/dev/null "snuba migrations migrate --force"
  [[ $? -eq 0 ]] && log "Test environment prepared."
}

function run_test_container() {
  local dockerfile
  local imagetag="test-sentry-telegram:${version}"

  dockerfile="$(mktemp)"
  
  cat <<DOCKERFILE > "$dockerfile"
  FROM getsentry/sentry:${version}
  WORKDIR /app
  RUN pip install \
      fixtures \
      pytest \
      pytest-django \
      pytest-xdist \
      responses \
      selenium \
      time_machine
  COPY . .
  ENTRYPOINT ["sh", "-c"]
  CMD ["pytest"]
DOCKERFILE
  
  log "Building test image…"
  $d rmi "$imagetag" || true
  $d build --no-cache --file "$dockerfile" --tag "$imagetag" --quiet .
  [[ $? -eq 0 ]] && log "Test image build successful."
  
  log "Starting test container…"
  $d run --rm --network=host "$imagetag"
  [[ $? -eq 0 ]] && log "Finished test run."
}

function cleanup() {
  log "Cleaning up."
  $dc down
}

function main() {
  parse_opts "$@"
  trap cleanup EXIT INT TERM
  cleanup
  prepare_test_environment
  run_test_container
}

main "$@"

exit 0
