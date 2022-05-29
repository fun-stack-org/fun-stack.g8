#!/usr/bin/env bash
set -Eeuo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail

trap "trap - SIGTERM && kill -- -$$ && echo '\\n\\n'" SIGINT SIGTERM EXIT # kill background jobs on exit

echo "Checking for node..." && node --version
echo "Checking for yarn..." && yarn --version
echo "Checking for sbt..." && sbt --script-version

echo "Checking if ports can be opened..."
PORT_HTTP=8080
PORT_WS=8081
PORT_AUTH=8082
PORT_FRONTEND=12345

nc -z 127.0.0.1  $PORT_HTTP     &>/dev/null && (echo "Port $PORT_HTTP is already in use";     exit 1)
nc -z 127.0.0.1  $PORT_WS      &>/dev/null && (echo "Port $PORT_WS is already in use";      exit 1)
nc -z 127.0.0.1  $PORT_AUTH     &>/dev/null && (echo "Port $PORT_AUTH is already in use";     exit 1)
nc -z 127.0.0.1  $PORT_FRONTEND &>/dev/null && (echo "Port $PORT_FRONTEND is already in use"; exit 1)


prefix() (
  prefix="$1"
  color="$2"
  colored_prefix="[$(tput setaf "$color")$prefix$(tput sgr0)] "

  # flushing awk: https://unix.stackexchange.com/a/83853
  awk -v prefix="$colored_prefix" '{ print prefix $0; system("") }'
)

(cd lambda && yarn install && npx webpack \
    bundle \
    --watch \
    --config webpack.config.dev.js \
    | prefix "WEBPACK_BACKEND" 4 & \
)

(cd webapp && yarn install && npx webpack \
    serve \
    --port $PORT_FRONTEND \
    --config webpack.config.dev.js \
    | prefix "WEBPACK_FRONTEND" 4 & \
)

yarn install

npx fun-local-env \
    --auth $PORT_AUTH \
    --ws $PORT_WS \
    --http $PORT_HTTP \
    --http-api lambda/target/dev/main.js httpApi \
    --http-rpc lambda/target/dev/main.js httpRpc \
    --ws-rpc lambda/target/dev/main.js wsRpc \
    --ws-event-authorizer lambda/target/dev/main.js wsEventAuth \
    | prefix "BACKEND" 4 &

sbt dev shell
printf "\n"
