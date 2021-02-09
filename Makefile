build-dev-image:
	cd ./packer; \
	packer build build-development.json

build-aws-image:
	cd ./packer; \
	packer build build-aws.json

set-up-env:
	cd ./bin; \
	sh initializer.sh

	cd ./bin; \
	sh get-app.sh

	ssh-keygen -t rsa -f ./packer/ansible/roles/common/files/id_rsa

	cd ./packer; \
	packer build build-development.json

up:
	sh ./bin/docker-init.sh

build-new-app:
	cd ./bin; \
	sh initializer.sh

	cd ./bin; \
	sh build-new-app.sh

	ssh-keygen -t rsa -f ./packer/ansible/roles/common/files/id_rsa

	cd ./packer; \
	packer build build-development.json

stop:
	docker-compose stop
	docker-sync stop
	cd ./bin; \
	sh docker-clearn.sh

login:
	docker exec -it zeroney_private_api_env_web_1 bash


clean:
	rm -rf templates/nginx
	rm -rf repo/*
	rm -rf docker-compose.yml
	rm -rf docker-sync.yml
	rm -rf .ruby_version
	rm -rf packer/build-development.json
	rm -rf ./packer/ansible/roles/common/files/id_rsa
	rm -rf ./packer/ansible/roles/common/files/id_rsa.pub
	rm -rf ./packer/ansible/roles/common/tasks/web.yml

delete-all-imgs:
	docker rmi `docker images -f "dangling=true" -q`
