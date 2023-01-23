source common.sh

componet=payment
schema_load=false

if [ -z ${roboshop_rabbitmq_password} ]; then
  echo "variable roboshop_rabbitmq_password missing"
  exit 1
fi

PYTHON
