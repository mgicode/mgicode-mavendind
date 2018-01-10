#FROM maven  
#maven3.5 and docker 17.06 
FROM 10.1.12.61:5000/maven
MAINTAINER pengrk

RUN apt-get update  && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables

RUN curl -sSL https://get.docker.com/ | sh

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

RUN apt-get install -y   expect
# Define additional metadata for our image.
#ssh连接The authenticity of host can't be established
RUN echo "StrictHostKeyChecking no" >>/etc/ssh/ssh_config
RUN echo "UserKnownHostsFile /dev/null" >>/etc/ssh/ssh_config

#epel-release  ansible
# Define additional metadata for our image.
VOLUME /var/lib/docker
CMD ["wrapdocker"]

