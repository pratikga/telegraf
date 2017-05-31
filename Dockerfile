FROM centos:7

# File Author / Maintainer
MAINTAINER Pratik

ENV container docker

# Manual systemctl installation
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]


# Update the repository sources list and Install Dependencies
RUN yum -y update
RUN yum -y install epel-release \
    java \
    telnet \
    vim \
    unzip \
    wget


################## BEGIN INSTALLATION ######################

# Installing Influxdb
# Manually adding the repo file
ADD influxdb.repo /etc/yum.repos.d/influxdb.repo

RUN yum -y install influxdb

# Copying the original conf file and adding the custom conf file
RUN mv /etc/influxdb/influxdb.conf /etc/influxdb/influxdb.conf.orig

ADD influxdb.conf /etc/influxdb/influxdb.conf

# Installing Telegraf
RUN wget https://repos.influxdata.com/rhel/7/amd64/stable/telegraf-1.2.1.x86_64.rpm

RUN yum -y localinstall telegraf-1.2.1.x86_64.rpm

# Copying the original conf file and adding the custom conf file
RUN mv /etc/telegraf/telegraf.conf /etc/telegraf/telegraf.conf.orig

ADD telegraf.conf  /etc/telegraf/telegraf.conf

##################### INSTALLATION END #####################
