#!/bin/bash 
sudo yum -y update
sudo yum  -y install https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
sudo yum repolist
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
sudo  yum -y install mysql-community-server
systemctl status mysqld;
sudo systemctl enable --now mysqld;
sudo systemctl start mysqld;
systemctl status mysqld;
echo "bind-address=0.0.0.0" | sudo tee -a /etc/my.cnf >/dev/null
export TEST_USER_PASS=123abcA@
root_pass=$(sudo grep 'temporary password' /var/log/mysqld.log|rev|cut -f1 -d " " |rev)
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY \"$TEST_USER_PASS\" ;" |sudo mysql -u root --password=$root_pass --connect-expired-password
#test local connection
echo "show databases;" |sudo mysql -u root --password=$TEST_USER_PASS 
echo "CREATE USER 'testuser' IDENTIFIED BY \"$TEST_USER_PASS\";" | sudo mysql -u root --password=$TEST_USER_PASS 
echo "grant all privileges on *.* to 'testuser' ;" | sudo mysql -u root --password=$TEST_USER_PASS 
sudo systemctl restart mysqld
curl  https://www.mysqltutorial.org/wp-content/uploads/2018/03/mysqlsampledatabase.zip --output data.zip
unzip data.zip
sudo mysql -u root --password=$TEST_USER_PASS < mysqlsampledatabase.sql
#echo "source 'mysqlsampledatabase.sql';" | sudo mysql -u root --password=$TEST_USER_PASS  
#validate the data :
echo "show databases;" |sudo mysql -u root --password=$TEST_USER_PASS 
sudo systemctl enable --now mysqld;