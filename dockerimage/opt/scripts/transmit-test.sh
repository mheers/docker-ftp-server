#!/bin/bash

HOST='some.ip'
USER='some.user'
PASSWD='some.password'
FILE='/data/some.file'

ftp -n $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PASSWD
binary
send $FILE FTPUE.csv
quit
END_SCRIPT

rm $FILE

exit 0
