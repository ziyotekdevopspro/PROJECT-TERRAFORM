#!/bin/bash
sudo yum install -y httpd
cd /var/www/html
sudo mkdir images
cd images
sudo wget https://devops16-project-bucket.s3.amazonaws.com/images/beautiful-landscape.jpg
sudo wget https://devops16-project-bucket.s3.amazonaws.com/images/index-image.html
sudo mv index-image.html index.html
sudo systemctl enable httpd --now