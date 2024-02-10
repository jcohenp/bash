#!/bin/bash

# This script demonstrates the use of functions.

log() {
  # This function sends a message to syslog and to standard output if VERBOSE is true.
  local MESSAGE="${@}"
  if [[ "$VERBOSE" == "true" ]]
  then
	  echo "${MESSAGE}"
  fi
  logger -t function.sh "${MESSAGE}"
}

backup_file() {
  # This function creates a backup of a file.  Returns non-zero status on error.
  local FILE="${1}"
  FILE_BACKUP="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
  if [[ -f "${FILE}" ]]
  then
	  log "Backing up ${FILE} to ${FILE_BACKUP}"
	  cp ${FILE} ${FILE_BACKUP}
  else
	  return 1
  fi
}

readonly VERBOSE='true'

backup_file /etc/passwd

# Make a decision based on the exit status of the function.
# Note this is for demonstration purposes.  You could have
# put this functionality inside of the backup_file function.
if [[ "${?}" -eq '0' ]]
then
	log "File has been backed up successfully"
else
	log "ERROR on backup"
	exit 1
fi

