#!/bin/sh

# launch_instances.sh
#
# Copyright(c) 2013 Uptime Technologies, LLC.

MASTER_EIP=54.238.126.147
SLAVE_EIP=54.238.127.37

. ./env.sh

function launch_instances()
{
  cat /dev/null > /tmp/ec2-run-instances.log

  echo "Launching an instance in ap-northeast-1a..."
ec2-run-instances ami-39b23d38 --region ap-northeast-1 \
  -O $AWS_ACCESS_KEY -W $AWS_SECRET_KEY \
  -k uptime_snaga \
  -g uptime-ssh -g test-pgsql \
  --instance-type t1.micro \
  --availability-zone ap-northeast-1a \
 | tee -a /tmp/ec2-run-instances.log

  echo "Launching an instance in ap-northeast-1b..."
ec2-run-instances ami-39b23d38 --region ap-northeast-1 \
  -O $AWS_ACCESS_KEY -W $AWS_SECRET_KEY \
  -k uptime_snaga \
  -g uptime-ssh -g test-pgsql \
  --instance-type t1.micro \
  --availability-zone ap-northeast-1b \
 | tee -a /tmp/ec2-run-instances.log
}

function assign_eips()
{
  echo "Assigning $MASTER_EIP to $MASTER..."

ec2-associate-address --region ap-northeast-1 \
  -O $AWS_ACCESS_KEY -W $AWS_SECRET_KEY \
  -i $MASTER \
  $MASTER_EIP

  echo "Assigning $SLAVE_EIP to $SLAVE..."

ec2-associate-address --region ap-northeast-1 \
  -O $AWS_ACCESS_KEY -W $AWS_SECRET_KEY \
  -i $SLAVE \
  $SLAVE_EIP
}

launch_instances

MASTER=`grep ^INSTANCE /tmp/ec2-run-instances.log | awk '{ print $2 }' | head -1`
SLAVE=`grep ^INSTANCE /tmp/ec2-run-instances.log | awk '{ print $2 }' | tail -1`

./check_instances.sh

assign_eips


