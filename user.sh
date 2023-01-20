#!/bin/bash
#author: kiran
#description: creating cart server with automation

source common.sh

print_head "settingup node repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
status_check


print_head "installing nodejs"
yum install nodejs -y
status_check

Print_head "useradd"
useradd roboshop
status_check

print_head "creating directory"
mkdir /app
status_check


print_head "downloading zip artificat"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
status_check

print_head "goint to app folder for unzip userer.zip"
cd /app
unzip /tmp/user.zip
status_check

cd /app

print_head "downloading nodejs dependencies"
npm install
status_check

print_head "changing user.conf"
cp ${script_location}/files/user.service /etc/systemd/system/user.conf
status_check

print_head "reloading user"
systemctl daemon-reload
status_check

print_head "enable User"
systemctl enable user
status_check

print_head "starting user"
systemctl start user
status_check

print_head "config mongodbrepo file"
cp ${script_location}/file/mongoDBrepo /etc/yum.repos.d/mongodb.repo
status_check

print_head "Downloading Mongodb"
yum install mongodb-org-shell -y
status_check

print_head "creating user schema "
mongo --host MONGODB-SERVER-IPADDRESS </app/schema/user.js
status_check