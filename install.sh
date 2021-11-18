#!/bin/bash

sleep 30

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install -y openjdk-11-jdk
sudo apt-get install -y jenkins
sudo apt-get install -y unzip
sudo apt-get install -y docker.io
sudo wget https://releases.hashicorp.com/terraform/$TF_VERSION/terraform_${TF_VERSION}_linux_amd64.zip -O /tmp/terraform.zip
sudo unzip /tmp/terraform.zip
sudo mv terraform /usr/local/bin
