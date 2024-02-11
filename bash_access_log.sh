#!/bin/bash

if [[ "$#" -eq '0' ]]
then
	echo "You need to specify pattern as argument of the script" >&2
	echo "Usage: ${0} <pattern> ..." >&2
	echo "All the arguments will be consider as a String for the pattern" >&2
	exit 1
fi

ACCESS_LOG=access.log
PATTERN=${1}

if [[ ! -f "${ACCESS_LOG}" ]]
then
	echo "Access log file is not found or not readable" >&2
	exit 1
fi

MATCHING_IPS=$(grep -E "${PATTERN}" "${ACCESS_LOG}" | awk '{ print $1 }') 

# Total numbers of requests for matching IP address
COUNT=$(echo "${MATCHING_IPS}" | wc -l)

echo "${COUNT}"

# List of Uniq IP addresses
UNIQ_IPS=$(echo "${MATCHING_IPS}" | sort -u) 

echo "${UNIQ_IPS}"

# Frequency distribution of requests per IP address
echo "${MATCHING_IPS}" | sort | uniq -c | awk '{ print $1, $2}'
