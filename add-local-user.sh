#!/bin/bash

# execute the script as root user:
USERID=$(uid)
ROOTUSERID='0'
if [[ USERID -ne ROOTUSERID]]
then
    echo "the script should be execited as root user. The script will exit"
    exit(1)
fi

# User informations
read -p 'What is the username' USERNAME
read -p 'What is the real name of the user' COMMENT
read -p 'What is the password of the user' PASSWORD

# User creation
useradd 
