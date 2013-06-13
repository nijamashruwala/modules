#!/bin/bash
# chkconfig: 345 95 05
# description: Wrapper script for apigee software. Not for use on datastores - does not handle Zookeeper and Cassandra
# processname: java


APIGEE_BIN_DIR='/mnt/apigee4/bin'
MNT_DIR='/mnt'
INIT_LOG="$MNT_DIR/logs/init_events.log"
server_types="management-server|router|message-processor|ingest-server|qpid-server|postgres-server"
datestamp=`date +%F.%H.%M.%S`

case "$1" in
start)
   $APIGEE_BIN_DIR/all-start.sh
   java_pid=`ps -elf|grep java|grep apigee|egrep -i "${server_types}"|awk '{ print $4 }'`;
   echo "$datestamp - START service with pid $java_pid" >> $INIT_LOG
;;
status)
   status_str=`$APIGEE_BIN_DIR/all-status.sh`
   if [[ $status_str =~ .*running.* && !($status_str =~ .*stopped.*) ]] ; then 
     is_running=0				# true
   else is_running=1		# false
   fi
   echo "$datestamp - status check, status is $is_running (0 is true, 1 is false)" >> $INIT_LOG 
   exit $is_running
;;
stop)
	 # Because puppet is dumb, this handles the restart case too
   java_pid=`ps -elf|grep java|grep apigee|egrep -i "${server_types}"|awk '{ print $4 }'`;
   if [ -x /root/get_logs.sh ] ; then
     echo "$datestamp - got logs on STOP" >> $INIT_LOG
     /root/get_logs.sh;
   fi
   echo "$datestamp - STOPPING service with pid $java_pid" >> $INIT_LOG
   $APIGEE_BIN_DIR/all-stop.sh
	 sleep 4
   is_stopped=`ps -elf|grep $java_pid|egrep -v grep|awk '{ print $4 }'`
   if [ ! -z $is_stopped ] ; then
     echo "$datestamp - KILLING java process $java_pid" >> $INIT_LOG
     kill -9 $java_pid
   fi
;;

restart)
    if [ -x /root/get_logs.sh ] ; then
      /root/get_logs.sh;
			echo "$datestamp - got logs on RESTART" >> $INIT_LOG 
    fi
  	$0 stop
  	$0 start
;;

*)
        echo "Usage: $0 {status|start|stop|restart}"
        exit 1
esac

