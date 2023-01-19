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

echo -e "\e[34m $2\e[0m"
}

