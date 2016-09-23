
IMAGE_NAME = luiscoms/openshift-rabbitmq

build:
	docker build -t $(IMAGE_NAME) -f Dockerfile .
	docker tag $(IMAGE_NAME) $(IMAGE_NAME):3
	docker tag $(IMAGE_NAME) $(IMAGE_NAME):3.6
	docker tag $(IMAGE_NAME) $(IMAGE_NAME):3.6.5
	docker build -t $(IMAGE_NAME):3-management -f management/Dockerfile .
	docker tag $(IMAGE_NAME):3-management $(IMAGE_NAME)3.6-management
	docker tag $(IMAGE_NAME):3-management $(IMAGE_NAME)3.6.5-management
