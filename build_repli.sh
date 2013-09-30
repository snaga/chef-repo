#!/bin/sh

rm -f ~/.ssh/known_hosts

time knife solo prepare ec2-user@54.238.126.147
time knife solo prepare ec2-user@54.238.127.37

time knife solo cook ec2-user@54.238.126.147
time knife solo cook ec2-user@54.238.127.37
