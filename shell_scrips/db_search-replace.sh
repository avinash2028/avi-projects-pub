#!/bin/bash
# Search and Replace script for wordpress migration from one domain to another domain
# take two database bakeup of wordpress
Date=`date +"%Y_%m_%d_%I:%M"`
# Backup path
Path=/home/blended/mysqldump/
# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
# Database variable
User=root
Host=localhost
Pass=root
## Get database list ##
DBS="$(mysql -u$User -h $Host -p$Pass -Bse 'show databases')"
echo $DBS
read -p "Please enter your database name: " Database_name
mysqldump -u$User -p$Pass $Database_name > $Path"$Database_name"_bk.sql
sleep 5
mysqldump -u$User -p$Pass $Database_name > $Path"$Database_name"-$Date.sql
# Search and Replace
Search_replace() {
echo "Search and replace the url"
echo ""
read -p "Enter old url: " Oldurl 
read -p "Enter new url: " Newurl
sed -i -e 's/'"$Oldurl"'/'"$Newurl"'/g' $Path"$Database_name"_bk.sql
# count number of
count1=0
for i in `cat $Path"$Database_name"_bk.sql `
do
  if [ $i == $Oldurl ]
  then
     count1=`expr $count1 + 1`
  fi
done

echo "The number of $Oldurl is $count1"
# Replace the old with new
count2=0
for i in `cat $Path"$Database_name"_bk.sql `
do
  if [ $i == $Newurl ]
  then
     count1=`expr $count2 + 1`
  fi
done

echo "The number of $Oldurl is $count2"
# if [count1 = count2] then
	echo "Url replcae with new one"
  else
     echo "Not replcae with new one"
  fi
  
}