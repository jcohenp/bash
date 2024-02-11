#!/bin/bash

# File provided as an argument.
# If a file is not provided, or it cannot be read, then the script will display an error message and exist with a status of 1

LOG_FILE="${1}"

if [[ ! -e "${LOG_FILE}" ]]
then
	echo "The file that you specify is not readable" >&2
	exit 1
fi

# Counts the number of failed login attempts by IP adress
# If there are any IP addresses  with more than 10 failed login attempts, the number of attempts made, the IP address from which thosr attempts were made, and the location of the IP address will be displayed
# Use geoiplookup cmd to find the localtion of the IP address

cat ${LOG_FILE} | grep -vE "^Count" | awk -F, '{ print $1, $2 }' | while read COUNT IP
do
	echo "${COUNT}"
	echo "${IP}"
done
