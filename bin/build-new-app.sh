#!/bin/bash
export $(cat ../.env | xargs)

if [ ! -e ../repo/$APPNAME ]; then
  cd ../repo;rails new $APPNAME -B
fi

if [ ! -e ../repo/${APPNANE}/config/nginx ]; then
  cp -r ../templates/nginx_temp ../templates/nginx
  cp -r ../templates/unicorn_temp ../templates/unicorn
  sed -e "s/{{APPNAME}}/$APPNAME/g" ../templates/nginx/development/nginx-template.conf > ../templates/nginx/development/nginx.conf
  sed -e "s/{{APPNAME}}/$APPNAME/g" ../templates/nginx/development/sites-enabled/application-template.conf > ../templates/nginx/development/sites-enabled/application.conf
  sed -i -e "s^{{PORT}}^$PORT^g" ../templates/nginx/development/sites-enabled/application.conf
  sed -e "s/{{APPNAME}}/$APPNAME/g" ../templates/nginx/development/conf.d/unicorn-template.conf > ../templates/nginx/development/conf.d/unicorn.conf
  sed -e "s/{{APPNAME}}/$APPNAME/g" ../templates/unicorn/development-template.rb > ../templates/unicorn/development.rb
  rm ../templates/nginx/development/conf.d/unicorn-template.conf
  rm ../templates/nginx/development/sites-enabled/application-template.conf
  rm ../templates/nginx/development/nginx-template.conf
  APP=`ls ../repo`
  mv -f ../templates/nginx ../repo/$APP/config/nginx
  mv -f ../templates/unicorn ../repo/$APP/config/unicorn
  cp  ../templates/docker-web ../repo/$APP/bin/docker-web
  cp  ../templates/setup ../repo/$APP/bin/setup
  rm ../repo/$APP/config/unicorn/development-template.rb
  rm -rf ../repo/$APP/config/nginx/development/sites-enabled/application.conf-e

fi

if [ ! -e ../repo/$APPNANE/bin/unicorn_start ]; then
  sed -e "s/{{APPNAME}}/$APPNAME/g" ../templates/unicorn_start > ../repo/${APPNAME}/bin/unicorn_start
  sed -e "s/{{APPNAME}}/$APPNAME/g" ../templates/unicorn_stop > ../repo/${APPNAME}/bin/unicorn_stop
fi

mkdir -p ../repo/${APPNAME}/tmp/sockets
mkdir -p ../repo/${APPNAME}/tmp/pids
