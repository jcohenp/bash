#!/bin/bash


# Ensure that the script is running with one argument: max size of log file

re_integer='^[0-9]+$'
MAX_SIZE="${1}"

if [[ "${#}" -ne '1' ]]
then
	echo "You need to specify one argument that represent the max size of the log files" >&2
	exit 1
elif ! [[ "${MAX_SIZE}" =~ ${re_integer} ]]
then
	echo "the argument is not an integer - invalide size" >&2
	exit 1
fi

find . -type f -name "*.log" | while read FILE
do
	SIZE_FILE=$(stat -c %s "${FILE}")
	CREATION_DATE=$(date +'%Y-%m-%d-%H:%M:%S' -d @$(stat -c %W "${FILE}"))
	CURRENT_DATE=$(date +'%Y-%m-%d-%H:%M:%S')
	if [[ "${SIZE_FILE}" -gt "${MAX_SIZE}" ]]
	then
		mv "${FILE}" "${FILE%.*}.${CREATION_DATE}-${CURRENT_DATE}.log"
		if [[ "${?}" -ne 0 ]]
		then
			echo "error on mv operation" >&2
			exit 1
		fi
		echo "new log file rotation created successfully"
		touch ${FILE}
		if [[ "${?}" -ne 0 ]]
		then
			echo "Error on the touch operation" >&2
			exit 1
		fi
		echo "the current log file: ${FILE} is now empty"
	fi
done

exit 0
