docker build -t 10.1.12.61:5000/mavendind  -f Dockerfile  /Users/prk/kubernetes/k8s-new/09mavenDind/ 


docker run -d --name mavendind  10.1.12.61:5000/mavendind
docker exec -it mavendind /bin/bash

docker push  10.1.12.61:5000/mavendind