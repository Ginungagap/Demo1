#!/bin/bash

#install git and java
sudo yum install git -y -q
sudo yum install java-1.8.0-openjdk-devel -y -q

#install ansible
sudo yum install epel-release -y
yum install ansible

#install docker
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce
yum install python-pip -y
pip install docker-py
sudo systemctl start docker.service
sudo systemctl enable docker.service

#create docker swarm
sudo docker swarm init
sudo docker network create --driver=overlay --attachable microservices-net

#install jenkins
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install jenkins -y 
sudo systemctl start jenkins
sudo systemctl enable jenkins

#create and send keys and credentials
sudo su <<_EOF_
mkdir -p /var/lib/jenkins/.ssh
chmod 700 /var/lib/jenkins/.ssh
mkdir -p /var/lib/jenkins/credentials
chmod 700 /var/lib/jenkins/credentials
mkdir /var/lib/jenkins/docker_credentials
chmod 700 /var/lib/jenkins/docker_credentials
mv /tmp/project-for-terraform.json /var/lib/jenkins/credentials/
chown -R jenkins:jenkins /var/lib/jenkins/.ssh
chown -R jenkins:jenkins /var/lib/jenkins/credentials
exit
_EOF_

sudo su -s /bin/bash jenkins <<_EOF_
ssh-keygen -N "" -f /var/lib/jenkins/.ssh/id_rsa
chmod 600 /var/lib/jenkins/.ssh/id_rsa
chmod 600 /var/lib/jenkins/.ssh/id_rsa.pub
docker swarm join-token worker | sed '1,2d;s/^ *//' > /var/lib/jenkins/docker_credentials/swarm_key
chmod 600 /var/lib/jenkins/docker_credentials/swarm_key
exit
_EOF_

echo "Jenkins server"
echo "All Done"