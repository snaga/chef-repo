#!/bin/sh

# check_instances.sh
#
# Copyright(c) 2013 Uptime Technologies, LLC.

. ./env.sh

function wait_for_instances()
{
MASTER=`grep ^INSTANCE /tmp/ec2-run-instances.log | awk '{ print $2 }' | head -1`
SLAVE=`grep ^INSTANCE /tmp/ec2-run-instances.log | awk '{ print $2 }' | tail -1`

while [ 1 ];
  do cat /dev/null > /tmp/ec2-describe-instance-status.log

     echo "Checking master node..."
     echo "[instance]"
     ec2-describe-instances \
       --region ap-northeast-1 \
       -O $AWS_ACCESS_KEY -W $AWS_SECRET_KEY \
       $MASTER

     echo "[status]"
     ec2-describe-instance-status \
       --region ap-northeast-1 \
       -O $AWS_ACCESS_KEY -W $AWS_SECRET_KEY \
       $MASTER \
       | tee -a /tmp/ec2-describe-instance-status.log
     echo

     echo "Checking slave node..."
     echo "[instance]"
     ec2-describe-instances \
       --region ap-northeast-1 \
       -O $AWS_ACCESS_KEY -W $AWS_SECRET_KEY \
       $SLAVE

     echo "[status]"
     ec2-describe-instance-status \
       --region ap-northeast-1 \
       -O $AWS_ACCESS_KEY -W $AWS_SECRET_KEY \
       $SLAVE \
       | tee -a /tmp/ec2-describe-instance-status.log

     RUNNING=`grep ^INSTANCE /tmp/ec2-describe-instance-status.log | grep -v INSTANCESTATUS| grep -c running`
     echo "$RUNNING instance(s) running."

     if [ $RUNNING -eq 2 ]; then
       break;
     fi
     sleep 10;
done;
}

wait_for_instances
