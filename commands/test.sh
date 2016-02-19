#!/bin/bash
source /root/.nvm/nvm.sh

#Add your local environment here
echo "127.0.0.1    traffic-addresses.dev.mercadolibre.com.ar">> /etc/hosts

# Verify that the app is launched
function waitForPing() {
  COUNT=0
  echo "Waiting for app up"
  while [[ $COUNT -lt 1200 ]]; do
    OUT=$(curl -m 1 --write-out %{http_code} --silent --output /dev/null 127.0.0.1:8080/ping)
    if [[ "$OUT" == "200" ]]; then
      echo "App started"
      return
    fi
    sleep 1;
    COUNT=$(( $COUNT + 1 ))
  done
  echo "Wait for /ping timedout"
  exit 100
}

if [[ -z "$CI_CONTEXT" || "$CI_CONTEXT" == "push" ]]; then
  apt-get --assume-yes  install libfontconfig1
  npm cache clean
  cd auth-oauth_frontend_mocks/
  npm install
  npm start &
  export GRAILS_ENV="test"
  cd /app/ui-test; npm install && npm install -g nightwatch && ./node_modules/selenium-standalone/bin/selenium-standalone install; cd /app
  java -jar /app/ui-test/node_modules/selenium-standalone/.selenium/selenium-server/2.50.1-server.jar -browser "browserName=phantom,platform=LINUX" &
  echo "Tests running by continuous integrator"
  source /commands/load_grails.sh /app/application.properties
  GRAILS_VARS="$GRAILS_OPTS"
  grails test-app --non-interactive
  grails $GRAILS_VARS run-app &
  waitForPing
  cd ui-test; nightwatch -e phantom;
  status=$?
  echo "Terminating jobs..."
  jobs -p | xargs kill
  running=$(jobs | wc -l)
  count=0
  while [ $running -gt 0 ]; do
    if [ $count -gt 30 ]; then
        break
    fi
    sleep 1
    count=$(( $count + 1 ))
    running=$(jobs | wc -l)
  done
  if [ $running -gt 0 ]; then
      echo "Killing jobs..."
      jobs -p | xargs kill -9
  fi
  exit $status
else
  echo "Build is being generated, don't run tests..."
  exit 0
fi
