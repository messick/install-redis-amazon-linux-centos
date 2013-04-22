#!/bin/bash

sudo yum -y update
sudo yum -y install gcc gcc-c++ make 

sudo wget http://redis.googlecode.com/files/redis-2.6.12.tar.gz
sudo tar xzf redis-2.6.12.tar.gz
sudo rm redis-2.6.12.tar.gz -f

cd redis-2.6.12
sudo make
sudo make install

sudo mkdir /etc/redis /var/lib/redis
sudo cp src/redis-server src/redis-cli /usr/local/bin
sudo cp redis.conf /etc/redis

sudo sed -e "s/^daemonize no$/daemonize yes/" -e "s/^# bind 127.0.0.1$/bind 127.0.0.1/" -e "s/^dir \.\//dir \/var\/lib\/redis\//" -e "s/^loglevel verbose$/loglevel notice/" -e "s/^logfile stdout$/logfile \/var\/log\/redis.log/" redis.conf > /etc/redis/redis.conf

wget https://raw.github.com/messick/install-redis-amazon-linux-centos/master/redis-server

sudo mv redis-server /etc/init.d
sudo chmod 755 /etc/init.d/redis-server

sudo chkconfig --add redis-server
sudo chkconfig --level 345 redis-server on

sudo service redis-server start

wget https://raw.github.com/messick/install-redis-amazon-linux-centos/master/sidekiq

sudo mv sidekiq /etc/init.d
sudo chmod 755 --level/init.d/sidekiq

sudo chkconfig --add sidekiq
sudo chkconfig --level 345 sidekiq on

sudo service sidekiq start
