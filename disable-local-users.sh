#!/bin/bash

# Allow for a local Linux account to be disabled, deleted and optionnaly archived


# Enforces that the script is executed as root user
USERID=$(id -u)
if [[ "${USERID}" -ne '0' ]]
then
	echo "You should run this script with root privileges" >&2
	exit 1
fi

# Provide a Usage statement: 
# -d deletes account(just disabled account without -d option) 
# -r Remove the home directory associated with the account
# -a Creates an archive of the home directory associated with the account(s) and stores the archive in the /archives directory
# Other options will display the usage and exist with an exist status of 1
usage() {
	echo "${0} Usage: [dra] USER [USER]..." >&2
	echo "-d Delete the account" >&2
	echo "-r Remove the home directory associated with the account" >&2
	echo "-a Creates an archive of the home directory associated and stores it in the /archives directory" >&2
	exit 1
}

# Accepts a list of user. At least one username is required
# or the script will display a usage statement and exit 1 - all events will be displayed on stderr
while getopts dra OPTION
do
	case ${OPTION} in
		d) DELETE_ACCOUNT='true' ;;
		r) REMOVE_HOME='-r' ;;
		a) CREATE_ARCHIVE='true' ;;
		?) usage ;;
	esac
done	

# Remove getopts arguments
shift $(( OPTIND - 1 ))

# Check if users are specified in arguments
if [[ "${#}" -eq '0'  ]]
then
	usage
fi

# Refused to disable or delete any accounts that have a UID less then 1000
#
for USER in "${@}"
do
	if [[ $(id -u ${USER}) -lt '1000' ]]
	then
		echo "Only normal users could be deleted. Makes sure that the user id is greater than 999" >&2
		exit 1
	fi
	if [[ "${CREATE_ARCHIVE}" = 'true' ]]
	then 
		ARCHIVE_FOLDER="/archives"
		if [[ ! -d ${ARCHIVE_FOLDER} ]]
		then 
			mkdir -p ${ARCHIVE_FOLDER} &> /dev/null
			if [[ "${?}" -ne '0' ]]
			then
				echo "unable to create the ARCHIVE_FOLDER: ${ARCHIVE_FOLDER}"
				exit 1
			fi
			echo "the archive folder: ${ARCHIVE_FOLDER} has been created successfully"
		fi
		HOME_DIR="/home/${USER}"
		if [[ -d ${HOME_DIR} ]]
		then
			tar -zcvf "${ARCHIVE_FOLDER}/${USER}.tar.gz" ${HOME_DIR} &> /dev/null
			if [[ "${?}" -ne '0' ]]
			then
				echo "tar cmd failed" >&2
				exit 1
			fi
			echo "the home directory: ${HOME_DIR} has been archived successfully"
		else
			echo "HOME_DIR: ${HOME_DIR} does not exist" >&2
			exit 1
		fi
	fi
	if [[ "${DELETE_ACCOUNT}" = 'true' ]]
	then
		userdel ${REMOVE_HOME} "${USER}" &> /dev/null
		if [[ "${?}" -ne '0' ]]
		then
			echo "User deletion failed: ${USER}" >&2
			exit 1
		fi
		echo "The user: ${USER} has been deleted"
		if [[ ${REMOVE_HOME} = '-r' ]]
		then
			echo "The home directory: ${HOME_DIR} of the user: ${USER} has been deleted"
		fi
			
	else
		chage -E 0 ${USER} >&2
		if [[ "${?}" -ne '0' ]]
		then
			echo "disabling user: ${USER} failed" >&2
			exit 1
		fi
		echo "The user: ${USER} has been disabled"
	fi
done

exit 0
