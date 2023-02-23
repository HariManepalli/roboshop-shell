code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head() {
  echo -e "\e[35m$1\e[0m"
}

status_check() {
  if [ $1 -eq 0 ]; then
    echo success
  else
    echo failure
    echo "Read the log file ${log_file} for more information about error"
        exit 1
  fi
}

schema_setup() {
  if [ "${schema_type}" == "mongo" ]; then
    print_head "Copy MongoDB Repo File"
    cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
    status_check $?

    print_head "Install Mongo Client"
    yum install mongodb-org-shell -y &>>${log_file}
    status_check $?

    print_head "Load Schema"
    mongo --host mongodb-dev.devopsb71.online </app/schema/${component}.js &>>${log_file}
    status_check $?
  elif [ "${schema_type}" == "mysql" ]; then
    print_head "Install MySQL Client"
    yum install mysql -y &>>${log_file}
    status_check $?

    print_head "Load Schema"
    mysql -h mysql-dev.devopsb71.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql &>>${log_file}
    status_check $?
  fi
}

nodejs() {
  print_head "Configure NodeJS Repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
  status_check $?

  print_head "Install NodeJS"
  yum install nodejs -y &>>${log_file}
  status_check $?

  app_prereq_setup

  print_head "Installing NodeJS Dependencies"
  npm install &>>${log_file}
  status_check $?

  schema_setup

  systemd_setup

}

