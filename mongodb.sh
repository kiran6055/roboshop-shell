#!/bin/bash
#author:kiran
#description: mongoDB automation

source common.sh

print_head "creating mongorepo"
cp ${script_location}/files/mongoDBrepo /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check

print_head "installing mongodb"
yum install mongodb-org -y &>>${LOG}
status_check

systemctl enable mongod &>>${LOG}
systemctl start mongod &>>${LOG}

print_head "changing 127.0.0.1 to 0.0.0.0"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG}
status_check

systemctl restart mongod &>>${LOG}
status_check