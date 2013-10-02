#!/bin/sh

# build_repli.sh
#
# Copyright(c) 2013 Uptime Technologies, LLC.

MASTER_EIP=54.238.126.147
SLAVE_EIP=54.238.127.37

rm -f ~/.ssh/known_hosts

echo "Preparing chef solo on master and slave nodes..."
time knife solo prepare ec2-user@${MASTER_EIP}
time knife solo prepare ec2-user@${SLAVE_EIP}

echo "Running chef solo on master and slave nodes..."
time knife solo cook ec2-user@${MASTER_EIP}
time knife solo cook ec2-user@${SLAVE_EIP}
