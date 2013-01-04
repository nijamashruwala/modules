#!/bin/bash

# Purpose:  Collect logs to dump on the puppetmaster
# Author:   Nija Mashruwala

datestamp=`date +%F-%H.%M.%S`
tempdir="/mnt/logs"
#TODO - Need to make sure this is the right java pid... Right now, there's only one java process
javapid=`pgrep java`
num_jstacks=5

mkdir -p $tempdir/$datestamp
cd $tempdir/$datestamp

# Jstack trace
for (( i=0; i<$num_jstacks; i++ )) ; do 
	/usr/java/jdk1.6.0_35/bin/jstack -l $javapid >> $HOSTNAME.jstack.dump
	sleep 5
	echo "# After sleeping for 5 - $i" >> $HOSTNAME.jstack.dump
done;

# Logs
LOG_FILES="/var/log/apigee/message-processor/system-monitor.log /var/log/apigee/message-processor/logs/system.log /var/log/apigee/message-processor/logs/transactions.log /var/log/apigee/message-processor/logs/access.log /var/log/apigee/router/system-monitor.log /var/log/apigee/router/logs/system.log /var/log/apigee/router/logs/transactions.log /var/log/apigee/router/logs/access.log"

for file in $LOG_FILES ; do
	if [ -e $file ] ; then 
    #echo "$file"
		cp $file .
	fi
done

# Process info
echo "ps -elf|egrep -i \"apigee|java\"" >> process.info
ps -elf| egrep -i "apigee|java" >> process.info

# JVM info
echo "/usr/java/default/bin/jps -lVvm | grep -v Jps" >> jvm.info
/usr/java/default/bin/jps -lVvm | grep -v Jps >> jvm.info
echo "" >> jvm.info
echo "/usr/java/default/bin/jinfo $javapid" >> jvm.info
/usr/java/default/bin/jinfo $javapid &> jvm.info
echo "" >> jvm.info

# System info
echo "cat /proc/$javapid/limits" >> system.info
cat /proc/$javapid/limits >> system.info
echo "" >> system.info

# Tar up and transport
cd ..
tar -czf $HOSTNAME.$datestamp.tar.gz $datestamp/*
scp $HOSTNAME.$datestamp.tar.gz root@puppetmaster:/mnt/logdumps
