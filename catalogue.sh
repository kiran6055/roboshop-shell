#!/bin/bash
#author: kiran
#description: cataloguescript

script_location=$(pwd)
LOG=/tmp/roboshop.log
set -e

echo -e "\e[34m settingup node repository\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}

if [ $? -eq 0 ]
then
  echo SUCCESS
else
  echo Failure
fi

echo -e "\e[35m installing NodeJS\e[0m"
yum install nodejs -y &>>${log}

if [ $? -eq 0 ]
then
  echo SUCCESS
else
  echo Failure
fi

echo -e "\e[31m creating user roboshop[0m"
useradd roboshop &>>${log}

if [ $? -eq 0 ]
then
  echo SUCCESS
else
  echo Failure
fi

echo -e "\e[31m creating app\e[0m"
mkdir -p /app &>>${log}
if [ $? -eq 0 ]
then
  echo SUCCESS
else
  echo Failure
fi

echo -e "\e[31m downloading catalogue code\e[0m"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}
if [ $? -eq 0 ]
then
  echo SUCCESS
else
  echo Failure
fi

cd /app

if [ $? -eq 0 ]
then
  echo SUCCESS
else
  echo Failure
fi

echo -e "\e[31m unziping catalogue code\e[0m"
unzip /tmp/catalogue.zip &>>${log}
if [ $? -eq 0 ]
then
  echo SUCCESS
else
  echo Failure
fi

cd /app
if [ $? -eq 0 ]
then
  echo SUCCESS
else
  echo Failure
fi

echo -e "\e[34m installing NodeJS dependencies\e[0m"
npm install &>>${log}
if [ $? -eq 0 ]
then
  echo SUCCESS
else
  echo Failure
fi

echo -e "\e[33m configuring catalgoue service file\e[0m"
cp ${script_location}/files/catalogueservice /etc/systemd/system/catalogue.service &>>${log}
if [ $? -eq 0 ]
then
  echo SUCCESS
else
  echo Failure
fi

echo -e "\e[31m system reload\e[0m"
systemctl daemon-reload &>>${log}
if [ $? -eq 0 ]
then
  echo SUCCESS
else
  echo Failure
fi

echo -e "\e[31m enable catalogue\e[0m"
systemctl enable catalogue &>>${log}
if [ $? -eq 0 ]
then
  echo SUCCESS
else
  echo Failure
fi

echo -e "\e[31m starting catalogue\e[0m"
systemctl start catalogue &>>${log}
if [ $? -eq 0 ]
then
  echo SUCCESS
else
  echo Failure
fi
echo -e "\e[32m setting up mongodbrepo config file\e[0m"
cp ${script_location}/files/mongoDBrepo /etc/yum.repos.d/mongodb.repo &>>${log}
if [ $? -eq 0 ]
then
  echo SUCCESS
else
  echo Failure
fi

echo -e "\e[31m loading Schema\e[0m"
yum install mongodb-org-shell -y &>>${log}
if [ $? -eq 0 ]
then
  echo SUCCESS
else
  echo Failure
fi

mongo --host localhost </app/schema/catalogue.js &>>${log}
if [ $? -eq 0 ]
then
  echo SUCCESS
else
  echo Failure
fi