#!/bin/bash

# This script demonstrates I/O redirection.

# Redirect STDOUT to a file.
FILE="/tmp/data"
echo "foo" 1> $FILE

# Redirect STDIN to a program.
read LINE < ${FILE}
echo ${LINE}

# Redirect STDOUT to a file, overwriting the file.
echo "foo" > ${FILE}
echo "Content of the file:"
cat ${FILE}

# Redirect STDOUT to a file, appending to the file.
echo "bar" >> ${FILE}
echo "Content of the file:"
cat ${FILE}

# Redirect STDIN to a program, using FD 0.
read LINE 0< ${FILE}
echo "LINE: ${LINE}"

# Redirect STDOUT to a file using FD 1, overwriting the file.
echo "new content" 1> ${FILE}
echo "content of the file:"
cat ${FILE}

# Redirect STDERR to a file using FD 2.
ERR_FILE="/tmp/data.err"
head -n1 /fake/path 2> ${ERR_FILE}
echo "Content of the file:"
cat ${ERR_FILE}

# Redirect STDOUT and STDERR to a file.
head -n1 /etc/passwd /fake/file &> ${FILE}
echo "Content of the file:"
cat ${FILE}

# Redirect STDOUT and STDERR through a pipe.
head -n3 /etc/passwd /fake/file |& cat -n

# Send output to STDERR
echo "foo" 1>&2

# Discard STDOUT
echo "foo" 1> /dev/null

# Discard STDERR
echo "foo" 2> /dev/null

# Discard STDOUT and STDERR
echo "foo" &> /dev/null

# Clean up
rm ${ERR_FILE} ${FILE} &> /dev/null 
