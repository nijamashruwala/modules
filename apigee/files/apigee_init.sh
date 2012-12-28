#!/bin/bash
# chkconfig: 345 95 05
# description: Wrapper script for apigee software. Not for use on datastores - does not handle Zookeeper and Cassandra
# processname: java


APIGEE_BIN_DIR='/opt/apigee/bin'
server_types="management-server|router|message-processor|ingest-server|qpid-server|postgres-server"

case "$1" in
start)
	$APIGEE_BIN_DIR/all-start.sh
;;
status)
   status_str=`$APIGEE_BIN_DIR/all-status.sh`
   if [[ $status_str =~ .*running.* && !($status_str =~ .*stopped.*) ]] ; then 
     is_running=0				# true
   else is_running=1		# false
   fi
   echo "$status_str"
   #echo "is_running is $is_running (0 is true, 1 is false)"
   exit $is_running
;;
stop)
   java_pid=`ps -elf|grep java|grep apigee|egrep -i "${server_types}"|awk '{ print $4 }'`;
   $APIGEE_BIN_DIR/all-stop.sh
	 sleep 4
   is_stopped=`ps -elf|grep $java_pid|egrep -v grep|awk '{ print $4 }'`
   if [ ! -z $is_stopped ] ; then
     echo "Killing java process $java_pid"
     kill -9 $java_pid
   fi
;;

restart)
  	$0 stop
  	$0 start
;;

*)
        echo "Usage: $0 {status|start|stop|restart}"
        exit 1
esac
