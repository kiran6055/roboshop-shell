#!/bin/bash
#author:kiran
#description: creating function which are similar in every script to save time

script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check() {
  if [ $? -eq 0 ]
  then
    echo -e "\e[1;32m Sucess\e[0m"
  else
    echo -e "\e[1;31m Failure\e[0m"
    echo "refer lof file LOG - ${LOG}"
    exit
  fi
}

print_head() {

echo -e "\e[1m $1 \e[0m"
}


app-preq () {

  print_head "creating user roboshop"
  id roboshop &>>${LOG}
  if [ $? -ne 0 ]
  then
    useradd roboshop &>>${LOG}
  fi
  status_check

  print_head "creating appdirectory"
  mkdir -p /app &>>${LOG}
  status_check

  print_head "downloading ${componet} code"
  curl -L -o /tmp/${componet}.zip https://roboshop-artifacts.s3.amazonaws.com/${componet}.zip &>>${LOG}
  status_check

  print_head "cleanup old content"
  rm -rf /app/* &>>${LOG}
  status_check


  print_head "unziping ${componet} code"
  cd /app
  unzip /tmp/${componet}.zip &>>${LOG}
  status_check

}

systemd_setup () {

print_head "configuring ${componet} service file"
cp ${script_location}/files/${componet}.service /etc/systemd/system/${componet}.service &>>${LOG}
status_check

print_head "system reload"
systemctl daemon-reload &>>${LOG}
status_check

print_head "enable ${componet}"
systemctl enable ${componet} &>>${LOG}
status_check

print_head "restarting ${componet}"
systemctl restart ${componet} &>>${LOG}
status_check
}


load_schema () {
  if [ ${schema_load} == "true" ]; then
    if [ ${schema_type} == "mongo"]; then
      print_head "setting up mongodbrepo config file"
      cp ${script_location}/files/mongoDBrepo /etc/yum.repos.d/mongodb.repo &>>${LOG}
      status_check

      print_head "installing mongoclient"
      yum install mongodb-org-shell -y &>>${LOG}
      status_check
      print_head "loading schema"
      mongo --host mongodb-dev.kiranprav.link/app/schema/${componet}.js &>>${LOG}
      status_check
    fi
    if [ ${schema_type} == "mysql"]; then
      print_head "install mysql client"
      yum install mysql -y &>>${LOG}
      status_check

      print_head "load schema"
      mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -p${root_mysql_password} < /app/schema/${componet}.sql &>>${LOG}
      status_check
    fi
  fi


}


Node () {
print_head "settingup node repository"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "installing NodeJS"
yum install nodejs -y &>>${LOG}
status_check

app_preq


print_head "installing NodeJS dependencies"
cd /app
npm install &>>${LOG}
status_check

systemd_setup


load_schema

}

maven () {

  print_head "installing Maven"
  yum install maven -y &>>${LOG}
  status_check

  app_preq

  print_head "building Package"
  mvn clean package &>>${LOG}
  status_check

  systemd_setup

  print_head "copy app file to app location"
  mv target/${component}-1.0.jar ${component}.jar
  status_check

  load_schema

}