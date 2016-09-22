
IMAGE_NAME = luiscoms/openshift-rabbitmq

build:
	docker build -t luiscoms/centos7-erlang -f Dockerfile.erlang .
	docker build -t $(IMAGE_NAME) .
