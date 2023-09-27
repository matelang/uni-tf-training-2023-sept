#!/bin/bash
yum update -y && yum install -y docker

systemctl start docker.service && systemctl enable docker.service
usermod -a -G docker ec2-user
docker run -d -p 5678:5678 hashicorp/http-echo -text="hello uni"
