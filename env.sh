#!/bin/sh

# env.sh
#
# Copyright(c) 2013 Uptime Technologies, LLC.

JAVA_HOME=/usr
export JAVA_HOME
EC2_HOME=~/ec2-api-tools-1.6.10.1
export EC2_HOME

PATH=$EC2_HOME/bin:$PATH
export PATH

if [ -z "$AWS_ACCESS_KEY" -o -z "$AWS_SECRET_KEY" ]; then
  echo Specify AWS_ACCESS_KEY and AWS_SECRET_KEY.
  exit 1
fi

