#!/bin/bash

PATTERN="${1}"
DIR_TO_SEARCH="${2}"

if [[ "${#}" -ne '2' ]]
then
	echo "usage: ${0} pattern directory" >&2
	exit 1
elif [[ ! -d "${DIR_TO_SEARCH}" ]]
then
	echo "Directory not found" >&2
	exit 1
fi

find "${DIR_TO_SEARCH}" -type f -name "*.c" | while read FILE
do
	LINE_FOUND=$(grep -Eno "${PATTERN}" "${FILE}" | cut -f1 -d: | tr "\n" "," | sed 's/,$//')
	if [[ -n "${LINE_FOUND}" ]]
	then
		echo "${FILE}:${LINE_FOUND}"
	fi
done
