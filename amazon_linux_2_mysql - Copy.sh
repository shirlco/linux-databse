#!/bin/bash 


#--------------------------------------------------------------------
# https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-centos-7

# https://techviewleo.com/how-to-install-mysql-8-on-amazon-linux-2/
# https://galaxydata.ru/community/failing-package-is-mysql-community-the-gpg-keys-listed-for-the-mysql-8-0-community-server-repository-are-already-installed-but-they-are-not-correct-for-this-package-1683


sudo yum -y update

sudo yum  -y install https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
sudo yum repolist


sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
sudo  yum -y install mysql-community-server
systemctl status mysqld;
sudo systemctl enable --now mysqld;
systemctl status mysqld;


#########sudo nano /etc/my.cnf
		#bind-address=0.0.0.0
#OR	
##sudo echo cant exit file under permission
### *will not work* sudo echo "bind-address=0.0.0.0" >> 	/etc/my.cnf 
echo "bind-address=0.0.0.0" | sudo tee -a /etc/my.cnf >/dev/null

#alter root user and add new password
#create user  and set password
#connect using the new user
export TEST_USER_PASS=123abcA@
#thwe pipeline will get the last word (password) from the log entry which states the temp password
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

#validate the data :
echo "show databases;" |sudo mysql -u root --password=$TEST_USER_PASS 
#classicmodels is the schema we uploaded


#install sql client like sql workbanch 
#connect using the public ip and mysql port
#using the new usser we just created
# 


​