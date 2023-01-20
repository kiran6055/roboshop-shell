 source common.sh

if [ -z "${root_mysql_password}" ]; then
  echo "variable root_mysql_password missing"
  exit 1
fi

print_head "disabling mysql default version"
dnf module disable mysql -y &>>${LOG}
status_check

print_head "copy mysql repo file"
cp ${script_location}/files/mysql.repo /etc/yum.repos.d/mysql.repo &>>${LOG}
status_check

print_head "installing mysql"
yum install mysql-community-server -y &>>${LOG}
status_check

print_head "enabling and starting Mysql"
systemctl enable mysqld &>>${LOG}
systemctl restart mysqld
status_check

mysql_secure_installation --set-root-pass ${root_mysql_password &>>${LOG}
if [ $? -eq 1 ]; then
  echo "password is already changed"
fi
status_check
