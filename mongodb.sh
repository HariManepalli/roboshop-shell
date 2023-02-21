source common.sh

print_head "Setup-mongodb repository"
cp Config/mongodb.repo /etc/yum.repos.d/mongo.repo

print_head "Install mongodb"
yum install mongodb-org -y

print_head "Update mongodb Listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongodb.conf

print_head "Enable mongodb"
systemctl enable mongod

print_head "Start mongodb service"
systemctl start mongod

# update /etc/mongodb.conf file from 127.0.0.1 to 0.0.0.0