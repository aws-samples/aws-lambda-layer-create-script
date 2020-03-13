## Build Machine Learning Layers for Python Lambda functions with 10 lines of code

### Introduction
This repository will introduce a simple way to create layers for Lambda in Python. Although this uses the example of ```sklearn```, which is a package for machine learning, you will learn how to build any python layer using the files provided here. Once this layer is created, you can use the layer to host your own models on lambda for inference or prediction. Although this post is specific to building machine learning specific layers, you can use the same procedure to create any python layer that is compatible with lambda, as long as the additional packages you need can be installed with pip. Let’s get started!

### Steps

First, create a shell script (.sh file) with the following code (or use the one in this repository):

```html
#!/bin/bash

if [ "$1" != "" ] || [$# -gt 1]; then
	echo "Creating layer compatible with python version $1"
	docker run -v "$PWD":/var/task "lambci/lambda:build-python$1" /bin/sh -c "pip install -r requirements.txt -t python/lib/python$1/site-packages/; exit"
	zip -r layer.zip python > /dev/null
	rm -r python
	echo "Done creating layer!"
	ls -lah layer.zip

else
	echo "Enter python version as argument - ./createlayer.sh 3.6"
fi

```

Name the file “createlayer.sh” and save it. The scripts requires an argument for the python version that you want to use for the layer; the script checks for this argument and requires the following:

1.	Docker should be installed: https://docs.docker.com/install/. If you are using a local machine, and EC2 instance or a laptop, you will need to install docker. When using an Amazon Sagemaker notebook instance terminal window, or a AWS Cloud9 terminal, docker will already be installed. 
2.	A requirements.txt file that is in the same path as the “createlayer.sh” script that you created above, that has the packages that you need to install.  Refer to this documentation on creating requireemnts files https://pip.readthedocs.io/en/1.1/requirements.html


For this sklearn example, our requirements.txt file will look like this:
```html
scikit-learn
```

Add any other packages you may need, with version numbers with one package name per line. 

Next, make sure that your createlayer.sh script is executable; on linux or Mac OS terminal window, navigate to where you saved the createlayer.sh file and type in:

```html
chmod +x createlayer.sh
```

Now you are ready to create a layer. In the terminal, type:

```html
./createlayer.sh 3.6
```

This will pull the container that matches the lambda runtime (this ensures that your layer is compatible by default), creates the layer using packages specified in the requirements.txt file, and then saves a layer.zip that you can then upload to a Lambda function using instructions here - https://aws.amazon.com/blogs/compute/working-with-aws-lambda-and-lambda-layers-in-aws-sam/ 

Example logs when running this script to create a Lambda-compatible sklearn layer is shown below:

```html
./createlayer.sh 3.6
Creating layer compatible with python version 3.6
Unable to find image 'lambci/lambda:build-python3.6' locally
build-python3.6: Pulling from lambci/lambda
d7ca5f5e6604: Pull complete 
5e23dc432ea7: Pull complete 
fd755da454b3: Pull complete 
c81981d73e17: Pull complete 
Digest: sha256:059229f10b177349539cd14d4e148b45becf01070afbba8b3a8647a8bd57371e
Status: Downloaded newer image for lambci/lambda:build-python3.6
Collecting scikit-learn
  Downloading scikit_learn-0.22.1-cp36-cp36m-manylinux1_x86_64.whl (7.0 MB)
Collecting joblib>=0.11
  Downloading joblib-0.14.1-py2.py3-none-any.whl (294 kB)
Collecting scipy>=0.17.0
  Downloading scipy-1.4.1-cp36-cp36m-manylinux1_x86_64.whl (26.1 MB)
Collecting numpy>=1.11.0
  Downloading numpy-1.18.1-cp36-cp36m-manylinux1_x86_64.whl (20.1 MB)
Installing collected packages: joblib, numpy, scipy, scikit-learn
Successfully installed joblib-0.14.1 numpy-1.18.1 scikit-learn-0.22.1 scipy-1.4.1
Done creating layer!
-rw-r--r--  1 username  ANT\Domain Users    60M Feb 23 21:53 layer.zip
```

The script outputs the size of the zipped layer as shown above (60MB). Make sure you read the guidelines on limits published here - https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html

Any layer(.zip) above 10MB in size must be uploaded to S3 first so you can provide AWS Lambda with a link to the layer on S3, and layers less than 10MB can be uploaded directly through the AWS lambda console. Each function can have up to 5 layers, and the total size of all unzipped layers and code must be less than 250 MB. 

Use the same script to generate the layers you would like to use, for example – sagemaker, mxnet, onnx, pillow, tensorflow-lite, or Deep learning runtime (DLR, https://pypi.org/project/dlr/) to host your Machine Learning models on Lambda!


## References

1.	https://aws.amazon.com/blogs/aws/new-for-aws-lambda-use-any-programming-language-and-share-common-components/
2.	https://aws.amazon.com/blogs/compute/working-with-aws-lambda-and-lambda-layers-in-aws-sam/
3.	https://aws.amazon.com/blogs/compute/upcoming-changes-to-the-python-sdk-in-aws-lambda/
4.	https://aws.amazon.com/blogs/apn/tag/aws-lambda-layers/
5.	https://docs.docker.com/install/
6.	https://pip.readthedocs.io/en/1.1/requirements.html


## License

This library is licensed under the MIT-0 License. See the LICENSE file.

