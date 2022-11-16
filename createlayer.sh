#!/bin/bash

if [ "$1" != "" ] || [$# -gt 1]; then
	echo "Creating layer compatible with python version $1"
	if [ "$1" == "3.9" ]; then
		echo "Using public.ecr.aws, lambci has no support for python 3.9"
		docker run -v "$PWD":/var/task "public.ecr.aws/sam/build-python3.9:latest" /bin/sh -c "pip install -r requirements.txt -t python/lib/python$1/site-packages/; exit"
	else
		docker run -v "$PWD":/var/task "lambci/lambda:build-python$1" /bin/sh -c "pip install -r requirements.txt -t python/lib/python$1/site-packages/; exit"
	fi
	zip -r layer.zip python > /dev/null
	rm -r python
	echo "Done creating layer!"
	ls -lah layer.zip

else
	echo "Enter python version as argument - ./createlayer.sh 3.6"
fi
