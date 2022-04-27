#!/bin/bash
sudo amazon-linux-extras install epel -y
sudo yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager ––enable remi–php70
sudo yum-config-manager ––enable remi–php71y
sudo yum install -y httpd php php-mysqlnd php-gd php-xml php-intl mariadb-server mariadb php-mbstring php-json
sudo systemctl enable httpd --now
sudo systemctl enable mariadb --now

mkdir /tmp
cd /tmp/
sudo wget https://releases.wikimedia.org/mediawiki/1.36/mediawiki-1.36.1.tar.gz
sudo tar -xvzf /tmp/mediawiki-*.tar.gz
sudo mv mediawiki-1.36.1 /var/www/html/mediawiki
sudo ln -s /var/lib/mediawiki /var/www/html/mediawiki
sudo chown -R apache:apache /var/www/html/mediawiki/
getenforce
sudo restorecon -FR /var/www/html/mediawiki/
sudo yum install php-intl -y
sudo amazon-linux-extras enable php7.4

sudo yum install firewalld -y
sudo systemctl enable firewalld --now
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload