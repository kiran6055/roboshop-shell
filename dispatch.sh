source common.sh


component=dispatch
schema_load=false

golang

if [ -z "${roboshop_rabbitmq_password}" ]; then
  echo " variable roboshop_rabbitmq_password is missing"
  exit 1

fi