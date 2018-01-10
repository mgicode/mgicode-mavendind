docker build -t 10.1.12.61:5000/mavendind  -f Dockerfile  /Users/prk/kubernetes/k8s-new/09mavenDind/ 


docker run -d --name mavendind  10.1.12.61:5000/mavendind
docker exec -it mavendind /bin/bash

docker push  10.1.12.61:5000/mavendind


docker tag 10.1.12.61:5000/mavendind registry.cn-hangzhou.aliyuncs.com/prk/mgicode-mavendind:1.0
docker push registry.cn-hangzhou.aliyuncs.com/prk/mgicode-mavendind:1.0


docker pull registry.cn-hangzhou.aliyuncs.com/prk/mgicode-mavendind:1.0


docker build -t 10.1.12.61:5000/mavendind:1.1  -f Dockerfile  /Users/prk/Projects/mgicode-new/mgicode-mavendind/


docker build -t 10.1.12.61:5000/mavendind:1.2  -f Dockerfile  /Users/prk/kubernetes/k8s-new/09mavenDind/
docker push  10.1.12.61:5000/mavendind:1.2

docker tag  10.1.12.61:5000/mavendind:1.2  registry.cn-hangzhou.aliyuncs.com/prk/mgicode-mavendind:1.2
docker push registry.cn-hangzhou.aliyuncs.com/prk/mgicode-mavendind:1.2