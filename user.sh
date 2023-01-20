#!/bin/bash
#author: kiran
#description: creating cart server with automation

source common.sh

print_head "settingup node repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check


print_head "installing nodejs"
yum install nodejs -y &>>${LOG}
status_check

 << mycomm
Print_head "useradd"
useradd roboshop  &>>${LOG}
status_check

print_head "creating directory"
mkdir /app &>>${LOG}
status_check


print_head "downloading zip artificat"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${LOG}
status_check

print_head "goint to app folder for unzip userer.zip"
cd /app &>>${LOG}
unzip /tmp/user.zip
status_check

cd /app &>>${LOG}

print_head "downloading nodejs dependencies"
npm install &>>${LOG}
status_check
mycomm

print_head "changing user.conf"
cp ${script_location}/files/user.service /etc/systemd/system/user.service &>>${LOG}
status_check

print_head "reloading user"
systemctl daemon-reload &>>${LOG}
status_check

print_head "enable User"
systemctl enable user &>>${LOG}
status_check

print_head "starting user"
systemctl start user &>>${LOG}
status_check

print_head "config mongodbrepo file"
cp ${script_location}/files/mongoDBrepo /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check

print_head "Downloading Mongodb"
yum install mongodb-org-shell -y &>>${LOG}
status_check

print_head "creating user schema "
mongo --host MONGODB-SERVER-IPADDRESS </app/schema/user.js &>>${LOG}
status_check