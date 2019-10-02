#!/bin/bash

sudo yum install git -y -q
sudo yum install java-1.8.0-openjdk-devel -y -q

curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install jenkins -y 
sudo systemctl start jenkins
sudo systemctl enable jenkins

# echo "Jenkins Unlock Key"
# sudo cat /var/lib/jenkins/secrets/initialAdminPassword

sudo su <<_EOF_
mkdir -p /var/lib/jenkins/.ssh
chmod 700 /var/lib/jenkins/.ssh
ssh-keygen -N "" -f /var/lib/jenkins/.ssh/jenkins
chmod 600 /var/lib/jenkins/.ssh/jenkins
chmod 600 /var/lib/jenkins/.ssh/jenkins.pub
chown -R jenkins:jenkins /var/lib/jenkins/.ssh
exit
_EOF_

echo "All Done"