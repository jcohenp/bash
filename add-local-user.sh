#!/bin/bash

# execute the script as root user:
USERID=$(id -u)
ROOTUSERID='0'
if [[ $USERID -ne $ROOTUSERID ]]
then
    echo 'the script should be executed as root user. The script will exit'
    exit 1
fi

# User informations
read -p 'What is the username ' USERNAME
read -p 'What is the real name of the user ' COMMENT
read -p 'What is the password of the user ' PASSWORD

# User creation
useradd -c "${COMMENT}" -m ${USERNAME}
echo ${PASSWORD} | passwd --stdin ${USERNAME}

if [[ ${?} -ne '0' ]]
then
	echo "the user was not able to be created"
	exit 1
fi
# Ask to the user to change password
passwd -e ${USERNAME}

# echo username, password and host

echo 
echo "username: ${USERNAME}"
echo "password: ${PASSWORD}"
echo "comment: ${COMMENT}"
echo "hostname: ${HOSTNAME}"
