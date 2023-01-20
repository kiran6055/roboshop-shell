#!/bin/bash
#author:kiran
#description: script for creating redis server

source common.sh

print_head "creating redis repo file"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${LOG}
status_check

print_head "enableing redis"
dnf module enable redis:remi-6.2 -y &>>${LOG}
status_check

print_head "installing redis"
yum install redis -y &>>${LOG}
status_check

print_head "editin g config file with 0.0.0.0"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${LOG}
status_check

print_head "enabling redis"
systemctl enable redis &>>${LOG}
status_check

print_head "starting redis"
systemctl start redis &>>${LOG}
status_check