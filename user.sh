source common.sh

print_head "configure nodejs Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head "Install NodeJS"
yum install nodejs -y &>>${log_file}
status_check $?

print_head "Create Roboshop file"
id roboshop &>>${log_file}
if [ $? -ne 0 ];then
  useradd roboshop &>>${log_file}
fi
status_check $?

print_head "Create application directory"
if [ ! -d /app ]; then
  mkdir /app &>>${log_file}
fi
status_check $?

print_head "delete old content"
rm -rf /app/* &>>${log_file}
status_check $?

print_head "Downloading App content"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${log_file}
cd /app
status_check $?

print_head "Extracting App content"
unzip /tmp/user.zip &>>${log_file}
status_check $?

print_head "Installing NodeJS Dependencies"
npm install &>>${log_file}
status_check $?

print_head "Copy SystemD Service file"
cp ${code_dir}/Config/user.service /etc/systemd/system/user.service &>>${log_file}
status_check $?

print_head "Reload SystemD"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "Enable User service"
systemctl enable user &>>${log_file}
status_check $?

print_head "Restart user service"
systemctl restart user &>>${log_file}
status_check $?

print_head "Copy mongodb Repo file"
cp ${code_dir}/Config/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
status_check $?

print_head "Install mongo client"
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

print_head "Load the schema"
mongo --host  mongodb.devopsb71m.online </app/schema/user.js &>>${log_file}
status_check $?

