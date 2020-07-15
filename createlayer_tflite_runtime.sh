#!/bin/bash

if [ "$1" == "3.8" ]; then
	echo "Creating layer compatible with python version $1"
	docker run -v "$PWD":/var/task "lambci/lambda:build-python$1" /bin/sh -c "
	yum install git unzip wget gcc-c++ -y;
	git clone https://github.com/tensorflow/tensorflow.git;
	cd tensorflow;
	git checkout r2.1;
	pip install numpy;
	./tensorflow/lite/tools/make/download_dependencies.sh;
	./tensorflow/lite/tools/pip_package/build_pip_package.sh;
	wget https://dl.google.com/coral/python/tflite_runtime-2.1.0.post1-cp37-cp37m-linux_x86_64.whl;
	pip install --upgrade ./tflite_runtime-2.1.0-cp37-cp37m-linux_x86_64.whl -t python/lib/python$1/site-packages/;exit"
	zip -r layer.zip python > /dev/null
	rm -r python
	echo "Done creating layer!"
	ls -lah tflite_layer.zip

else
	echo "Enter python version 3.8 as argument - ./createlayer_tflite_runtime.sh 3.8"
fi
