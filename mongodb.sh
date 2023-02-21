source common.sh

print_head "Setup MongoDB repository"
cp ${code_dir}/Config/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

print_head "Install MongoDB"
yum install mongodb-org -y &>>${log_file}

print_head "Update MongoDB Listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log_file}

print_head "Enable MongoDB"
systemctl enable mongod &>>${log_file}

print_head "Start MongoDB Service"
systemctl restart mongod &>>${log_file}


# update /etc/mongodb.conf file from 127.0.0.1 to 0.0.0.0-completed