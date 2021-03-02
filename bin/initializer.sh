#!/bin/bash
export $(cat ../.env | xargs)

if [ ! -e ../docker-compose.yml ]; then
  echo "===rbenv install==="
  rbenv install $RUBYVERSION
  rbenv local $RUBYVERSION
  gem install rails
  gem install docker-sync

  sed -e "s/{{APPNAME}}/$APPNAME/g" ../templates/all_template > ../packer/ansible/group_vars/all
  sed -i -e "s^{{RUBYVERSION}}^$RUBYVERSION^g" ../packer/ansible/group_vars/all
  rm ../packer/ansible/group_vars/all-e

  sed -e "s/{{RUBYVERSION}}/$RUBYVERSION/g" ../templates/.ruby-version > ../.ruby-version

  sed -e "s/{{SYNCVOLUME}}/$SYNCVOLUME/g" ../templates/docker-compose-template.yml > ../docker-compose.yml
  sed -i -e "s^{{PORT}}^$PORT^g"  ../docker-compose.yml
  sed -i -e "s^{{WEBUSERNAME}}^$WEBUSERNAME^g"  ../docker-compose.yml
  sed -i -e "s^{{APPNAME}}^$APPNAME^g"  ../docker-compose.yml
  sed -i -e "s^{{IMGNAME}}^$IMGNAME^g"  ../docker-compose.yml
  sed -i -e "s^{{ROOT}}^$ROOT^g"  ../docker-compose.yml

  sed -e "s/{{APPNAME}}/$APPNAME/g" ../templates/web.yml > ../packer/ansible/roles/common/tasks/web.yml
  sed -e "s/{{APPNAME}}/$APPNAME/g" ../templates/docker-sync-template.yml > ../docker-sync.yml

  sed -e "s/{{OSVERSION}}/$OSVERSION/g" ../templates/build-development-template.json > ../packer/build-development.json
  sed -i -e "s^{{IMGNAME}}^$IMGNAME^g"  ../packer/build-development.json
  rm ../packer/build-development.json-e
  rm ../docker-compose.yml-e
fi
