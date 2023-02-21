source common.sh

print_head "configure nodejs Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

print_head "Install NodeJS"
yum install nodejs -y &>>${log_file}

print_head "Create Roboshop file"
useradd roboshop &>>${log_file}

print_head "Create application directory"
mkdir /app &>>${log_file}

print_head "delete old content"
rm -rf /app/* &>>${log_file}

print_head "Downloading App content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
cd /app

print_head "Extracting App content"
unzip /tmp/catalogue.zip &>>${log_file}

print_head "Installing NodeJS Dependencies"
npm install &>>${log_file}

print_head "Copy SystemD Service file"
cp ${code_dir}/Config/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}

print_head "Reload SystemD"
systemctl daemon-reload &>>${log_file}

print_head "Enable Catalogue service"
systemctl enable catalogue &>>${log_file}

print_head "Restart Catalogue service"
systemctl restart catalogue &>>${log_file}

print_head "Copy mongodb Repo file"
cp {code_dir}/Config/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}

print_head "Install mongo client"
yum install mongodb-org-shell -y &>>${log_file}

print_head "Load the schema"
mongo --host  mongodb.devopsb71m.online </app/schema/catalogue.js &>>${log_file}

