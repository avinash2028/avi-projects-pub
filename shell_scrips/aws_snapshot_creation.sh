#!/bin/bash
# EBS volume Snapshot creation script

export JAVA_HOME=/usr/lib/jvm/jre-1.7.0-openjdk.x86_64/
export EC2_HOME=/usr/local/aws
export PATH=$PATH:$EC2_HOME/bin
ec2_bin=/usr/local/aws/bin
export AWS_ACCESS_KEY=***********
export AWS_SECRET_KEY=**************

# Defining Instance, Volume & Region info
region="us-east-1"
volume=$1
machine_info=$2
volume_type=$3

# Defining Log file
LOGFILE='/var/log/aws/create_snapshot.log'
TMPFILE='/tmp/snap_info.txt'
snapid='/tmp/snapid.txt'
 
# Defining Date of the Month and Week of the Month Variable 
wom=$((($(date +%d))/7+1))
dow=$(date +%u)
year=$(date +%Y)
dom=$(date +%e)
month=$(date +%m)

if [[ "$volume" == "" ]]

then 
	echo "volume name is empty cannot create a snapshot" | tee 2>&1 >> $LOGFILE 
	exit
else
# Description for the snapshot
        description="${machine_info}-${volume_type}-vol-id:${volume}---`date +%Y-%m-%d`"
	 
# Creating Snapshot
        $ec2_bin/ec2-create-snapshot -region $region  -d "$description" $volume | tee 2>&1 $snapid 
		snapshot_id="$(cat $snapid |  awk '{print $2}')"

# Adding Name on Sanpshot		
		$ec2_bin/ec2tag  -region $region $snapshot_id -t Name="${year}-month${month}-week${wom}-snap${dow}"
#	   description="Daily backup of volume id:${volume}_Week:${wom}_Year:${year}"
		echo "day${dom}:snap${dow} created successfully and the snapshot id is ${snapshot_id}" 2>&1 >> $LOGFILE
fi
# End of the Script
