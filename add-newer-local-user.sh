#!/bin/bash


USERID=$(id -u)
ROOTUSERID='0'

if [[ $USERID -ne $ROOTUSERID ]]
then
	echo "You need to run the script as root" 1>&2
	exit 1
fi

if  [[ $# -eq '0' ]]
then 
	echo "USAGE: ${0} USERNAME [COMMENT]" 1>&2
	exit 1
fi

USERNAME=$1
shift
COMMENT=$*

PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c 48)
SPECIAL_CHARACTER=$( echo '!@#$%^&*()_+' | fold -w1 | shuf | head -c1)

PASSWORD=${PASSWORD}${SPECIAL_CHARACTER}


# User creation
useradd -c "${COMMENT}" -m ${USERNAME} &> /dev/null
echo ${PASSWORD} | passwd --stdin ${USERNAME} &> /dev/null

if [[ ${?} -ne '0' ]]
then
        echo "the user was not able to be created" 1>&2
        exit 1
fi
# Ask to the user to change password
passwd -e ${USERNAME} &> /dev/null

# echo username, password and host

echo
echo "username: ${USERNAME}"
echo "password: ${PASSWORD}"
echo "comment: ${COMMENT}"
echo "hostname: ${HOSTNAME}"

exit 0
