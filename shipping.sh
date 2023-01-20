source common.sh

if [ -z "${root_mysql_password}" ]; then
  echo "variable root_mysql_password is required need to mention"
  exit
fi

componet=shipping
schema_load=true
schema_type=mysql
maven
