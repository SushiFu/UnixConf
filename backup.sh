#!/bin/bash

# One full backup 2 weeks, Incrementals every day at 5:00am
# Remove backup if older than 1 month
# Backups are located in /backup

echo "############# Backups Started : $(date) #############"

export PASSPHRASE=YourPassphrase

echo "#################### Backup /etc ####################"

echo "-> Backup : $(date)"
duplicity --full-if-older-than 1W /etc file:///backup/etc

echo "-> Remove older : $(date)"
duplicity remove-older-than 1M --force file:///backup/etc

echo "#################### Backup /home ###################"

echo "-> Backup : $(date)"
duplicity --full-if-older-than 1W /home file:///backup/home

echo "-> Remove older : $(date)"
duplicity remove-older-than 1M --force file:///backup/home

echo "################### Backup /docker ##################"

cd /var/local/lib/docker

echo "-> Stop and Remove all containers : $(date)"
docker-compose stop
docker-compose rm -f

echo "-> Backup : $(date)"
duplicity --full-if-older-than 1W /var/local/lib/docker file:///backup/docker

echo "-> Remove older : $(date)"
duplicity remove-older-than 1M --force file:///backup/docker

echo "-> Generate Global docker-compose config : $(date)"
docker run -t --rm -v /var/local/lib/docker:/docker sushifu/compose-merger

echo "-> Restart All Containers : $(date)"
docker-compose up -d

echo "-> Clean old images and volumes : $(date)"
docker images -q | xargs docker rmi
docker volume ls -qf dangling=true | xargs -r docker volume rm

unset PASSPHRASE

echo "############# Backups Finished : $(date) ############"
