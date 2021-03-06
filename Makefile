NAME := eep-automation-suite
VERSION := $(shell git rev-parse --short HEAD)
IMAGE_LATEST := $(NAME):latest


.PHONY : *

readme:
	more readme.txt

build:
	docker build -f Dockerfile --pull -t ${IMAGE_LATEST} .
	docker images | grep ${NAME}

shell-dev:
	docker run -it --rm --entrypoint '/bin/sh' \
		-e "EEP_DOC_DIR=/eep" \
		-v `pwd`/src:/app \
		-v `pwd`/templates:/app/templates \
		-v ~/Documents/eep:/eep \
		${IMAGE_LATEST}

shell:
	docker run -it --rm --entrypoint '/bin/sh' \
		-e "EEP_DOC_DIR=/eep" \
		-v ~/Documents/eep:/eep \
		${IMAGE_LATEST}

cropper:
	pipenv run python src/eep-photo-cropper.py

combine:
	pipenv run python src/eep-merge-sheets-from-raw-excel.py

eeplist:
	pipenv run python src/eep-generate-lists.py
