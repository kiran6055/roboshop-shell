#!/bin/bash
#author: kiran
#description: cataloguescript



print_head settingup node repository
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "installing NodeJS"
yum install nodejs -y &>>${LOG}

status_check

print_head "creating user roboshop"
useradd roboshop &>>${LOG}
status_check

print_head "creating app"
mkdir -p /app &>>${LOG}
status_check

print_head "downloading catalogue code"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check
cd /app


print_head "unziping catalogue code"
unzip /tmp/catalogue.zip &>>${LOG}
status_check

cd /app
status_check

print_head "installing NodeJS dependencies"
npm install &>>${LOG}
status_check

print_head "configuring catalgoue service file"
cp ${script_location}/files/catalogueservice /etc/systemd/system/catalogue.service &>>${LOG}
status_check

print_head "system reload"
systemctl daemon-reload &>>${LOG}
status_check

print_head "enable catalogue"
systemctl enable catalogue &>>${LOG}
status_check

print_head "tarting catalogue"
systemctl start catalogue &>>${LOG}
status_check

print_head "setting up mongodbrepo config file"
cp ${script_location}/files/mongoDBrepo /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check

print_head "loading Schema"
yum install mongodb-org-shell -y &>>${LOG}
status_check
mongo --host localhost </app/schema/catalogue.js &>>${LOG}
status_check