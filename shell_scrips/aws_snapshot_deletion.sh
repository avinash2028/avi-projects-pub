#!/bin/bash
# EBS Snapshot volume script

export JAVA_HOME=/usr/lib/jvm/jre-1.7.0-openjdk.x86_64/
export EC2_HOME=/opt/aws
export PATH=$PATH:$EC2_HOME/bin
ec2_bin=/opt/aws/bin
export AWS_ACCESS_KEY=**************
export AWS_SECRET_KEY=**************

# Defining Instance, Volume & Region info
region="us-east-1"

# type = daily,  weekly,  Monthly

type=$1

# duration = 7, 31, 365 

duration=$2

# Defining Log file
LOGFILE='/var/log/aws/delete_snapshot.log'
snap_tag='/tmp/d_snap_info.txt'
TMPFILE='/tmp/tmp-snap.txt'
TAG='/tmp/tag_sanp_info.txt'

# Defining Date of the Month and Week of the Month Variable
#wom=$((($(date +%d))/7+1))
#wom_old=$((($(date +%d)-1)/7+1))

#dow=$(date +%u)
#year=$(date +%Y)
#dom=$(date +%e)

datecheck=`date +%Y-%m-%d --date "$duration days ago"`
datecheck_s=`date --date="$datecheck" +%s`
#datenow=`date +%Y-%m-%d-%H:%M:%S`

# Get all snapshot info
$ec2_bin/ec2-describe-snapshots -region $region | grep "TAG" > $TAG 2>&1
$ec2_bin/ec2-describe-snapshots -region $region | grep "SNAPSHOT" > $TMPFILE 2>&1


#$ec2_bin/ec2-describe-snapshots -region $region | grep "Name" 2>&1 >  $snap_tag

for obj0 in $(cat $TMPFILE | grep "SNAPSHOT" | awk '{print $2}')
do
		
        snapshot_name=`cat $TMPFILE | grep "$obj0" | awk '{print $2}'`
        datecheck_old=`cat $TMPFILE | grep "$snapshot_name" | awk '{print $5}' | awk -F "T" '{print $1}'`
        datecheck_s_old=`date --date="$datecheck_old" +%s`
		TAG_Check="$(cat  $TAG |  grep "$obj0" | awk '{print $5}')" 

#	Checking the snapshot does it belongs to the script or not.

		if [[ $TAG_Check !=  *-month*-week*-snap*  ]]
		then
		echo  "" 2>&1 >> $LOGFILE
		echo "${snapshot_name} This Snapshot doesn't belongs to this deletion script that's why preserving it." 2>&1 >> $LOGFILE
		echo  "" 2>&1 >> $LOGFILE
		#continue
		fi
		
#	Checking for Daily backup
		
		if [[ $type == 'daily' && $datecheck_s_old = $datecheck_s && $TAG_Check == *-*-*-snap1 ]]
		
		then 
		echo "${snapshot_name} is need to be preserved as week backup"   2>&1 >> $LOGFILE
		
		elif [[ $type == 'daily' && $datecheck_s_old = $datecheck_s && $TAG_Check != *-*-*-snap1 ]]
		then
		echo  "" 2>&1 >> $LOGFILE
		echo "Deleting the snapshot ${snapshot_name} as it is one week older." 2>&1 >> $LOGFILE
		$ec2_bin/ec2-delete-snapshot -region $region $snapshot_name  2>&1 >> $LOGFILE
		
		fi
# 	Checking for weekly backup
		
        if [[ $type == 'weekly' && $datecheck_s_old = $datecheck_s && $TAG_Check == *-*-week1-* ]]
		
		then 
		echo "${snapshot_name} is need to be preserved as monthly backup"   2>&1 >> $LOGFILE
		echo "copying snapshot $snapshot_name to other availability zone as its week's first snapshot" 2>&1 >> $LOGFILE
		$ec2_bin/ec2-copy-snapshot --region us-west-2 -r $region -s $snapshot_name  2>&1 >> $LOGFILE
		
		elif [[ $type == 'weekly' && $datecheck_s_old = $datecheck_s && $TAG_Check != *-*-week1-snap1  ]]
		then
		echo  "" 2>&1 >> $LOGFILE
		echo "Deleting the snapshot ${snapshot_name}  as it is one month older." 2>&1 >> $LOGFILE
		$ec2_bin/ec2-delete-snapshot -region $region $snapshot_name  2>&1 >> $LOGFILE
	
		fi
		
# 	Checking for Monthly backup

        if [[ $type == 'monthly' && $datecheck_s_old = $datecheck_s && $TAG_Check == *-month01-*-* ]]
		
		then 
		echo "${snapshot_name} is need to be preserved as yearly backup"  2>&1 >> $LOGFILE
		
		elif [[ $type == 'monthly' && $datecheck_s_old = $datecheck_s && $TAG_Check !=  *-month01-week1-snap1 ]]
		then
		echo  "" 2>&1 >> $LOGFILE
		echo "Deleting the snapshot ${snapshot_name}  as it is one year older." 2>&1 >> $LOGFILE
		$ec2_bin/ec2-delete-snapshot -region $region $snapshot_name  2>&1 >> $LOGFILE
		
		fi

done

#  End of Script
