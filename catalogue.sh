#!/bin/bash
#author: kiran
#description: cataloguescript

script_location=$(pwd)

set -e
curl -sL https://rpm.nodesource.com/setup_lts.x | sudo bash
yum install nodejs -y
#useradd roboshop
#mkdir /app
#curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
#unzip /tmp/catalogue.zip
cd /app
npm install
cp ${script_location}/files/catalogueservice /etc/systemd/system/catalogue.service
Systemctl daemon-reload

systemctl enable catalogue
systemctl start catalogue

cp ${script_location}/files/mongoDBrepo /etc/yum.repos.d/mongodb.repo
yum install mongodb-org-shell -y

mongo --host localhost </app/schema/catalogue.js