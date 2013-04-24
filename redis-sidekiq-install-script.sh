#!/bin/bash

# install and setup redis
wget http://redis.googlecode.com/files/redis-2.6.12.tar.gz
tar xzf redis-2.6.12.tar.gz
rm redis-2.6.12.tar.gz -f

cd redis-2.6.12
make
make install

mkdir /etc/redis /var/lib/redis
cp src/redis-server src/redis-cli /usr/local/bin
cp redis.conf /etc/redis

sed -e "s/^daemonize no$/daemonize yes/" -e "s/^# bind 127.0.0.1$/bind 127.0.0.1/" -e "s/^dir \.\//dir \/var\/lib\/redis\//" -e "s/^loglevel verbose$/loglevel notice/" -e "s/^logfile stdout$/logfile \/var\/log\/redis.log/" redis.conf > /etc/redis/redis.conf


# add redis as a service
wget https://raw.github.com/messick/install-redis-amazon-linux-centos/master/redis-server
mv redis-server /etc/init.d
chmod 755 /etc/init.d/redis-server

chkconfig --add redis-server
chkconfig --level 345 redis-server on

service redis-server start


# add sidekiq as a service
wget https://raw.github.com/messick/install-redis-amazon-linux-centos/master/sidekiq
mv sidekiq /etc/init.d
chmod 755 --level/init.d/sidekiq

chkconfig --add sidekiq
chkconfig --level 345 sidekiq on
