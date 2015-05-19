#!/bin/bash

# removing all stopped docker containers:
sudo docker rm -f $(sudo docker ps -a -q)

# removing all unused docker images:
sudo docker images -q |xargs sudo docker rmi
