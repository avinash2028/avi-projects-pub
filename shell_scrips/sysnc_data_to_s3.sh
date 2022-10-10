! /bin/bash
from='2018-10-01 00:00:00' # 01-Aug-13
to='2018-11-31 23:59:59'   # 31-Aug-13

for file in /var/log/* ; do
    modified=$( stat -c%y "$file" )
    if [[ $from < $modified && $modified < $to ]] ; then
        echo "$file"
    fi
done
