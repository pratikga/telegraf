############################################################
# Dockerfile to build Telegraf and Influxdb container images
# Based on Centos
############################################################

# Set the base image to centos
FROM centos

# File Author / Maintainer
MAINTAINER Pratik

# Update the repository sources list
RUN yum -y update

# Install Dependencies
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
