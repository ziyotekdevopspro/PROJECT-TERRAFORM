#!/bin/bash
sudo yum install -y httpd
cd /var/www/html
sudo wget https://devops16-project-bucket.s3.amazonaws.com/images/beautiful-landscape.jpg
sudo wget https://devops16-project-bucket.s3.amazonaws.com/images/index.html
sudo systemctl enable httpd --now