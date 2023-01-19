#!/bin/bash
#author: kiran
#description: cataloguescript

script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check() {
  if [ $? -eq 0 ]
  then
    echo -e '\e[32m Sucess\e[om'
  else
    echo -e '\e[31m Failure\e[om'
    exit
  fi
}
set -e

echo -e "\e[34m settingup node repository\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

echo -e "\e[35m installing NodeJS\e[0m"
yum install nodejs -y &>>${LOG}

status_check

echo -e "\e[31m creating user roboshop[0m"
useradd roboshop &>>${LOG}
status_check

echo -e "\e[31m creating app\e[0m"
mkdir -p /app &>>${LOG}
status_check

echo -e "\e[31m downloading catalogue code\e[0m"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check
cd /app


echo -e "\e[31m unziping catalogue code\e[0m"
unzip /tmp/catalogue.zip &>>${LOG}
status_check

cd /app
status_check

echo -e "\e[34m installing NodeJS dependencies\e[0m"
npm install &>>${LOG}
status_check

echo -e "\e[33m configuring catalgoue service file\e[0m"
cp ${script_location}/files/catalogueservice /etc/systemd/system/catalogue.service &>>${LOG}
status_check

echo -e "\e[31m system reload\e[0m"
systemctl daemon-reload &>>${LOG}
status_check

echo -e "\e[31m enable catalogue\e[0m"
systemctl enable catalogue &>>${LOG}
status_check

echo -e "\e[31m starting catalogue\e[0m"
systemctl start catalogue &>>${LOG}
status_check

echo -e "\e[32m setting up mongodbrepo config file\e[0m"
cp ${script_location}/files/mongoDBrepo /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check

echo -e "\e[31m loading Schema\e[0m"
yum install mongodb-org-shell -y &>>${LOG}
status_check

mongo --host localhost </app/schema/catalogue.js &>>${LOG}
status_check