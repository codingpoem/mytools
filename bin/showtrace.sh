#!/bin/sh
#########################################################
# Function :show adj value of UID                	    
# Date     :2021-05-13                                  
# Author   :zdn			                                
# $1: UID
#########################################################
# set -x

adb shell ps -ef|grep $1 1>/dev/null 2>&1
if [ ! $? -eq 0 ]; then
	echo "$1 is not alive"	
	exit
fi


adb shell cat proc/22318/status|grep "TracerPid"
adb shell cat proc/22664/status|grep "TracerPid"


printf "%-6s\t%-6s\t%-8s\t%-8s\t%-8s\t%-8s\n" "UID" "PID" "oom_adj" "oom_score" "oom_score_adj" "CMD"
adb shell ps -ef|grep $1 | while read line 
do
# echo $line
uid=`echo $line|awk '{print $1}'`
pid=`echo $line|awk '{print $2}'`
ppid=`echo $line|awk '{print $3}'`
pname=`echo $line|awk '{print $8}'`

echo "adb shell cat proc/${pid}/status|grep "TracerPid""
# adb shell cat proc/${pid}/status|grep "TracerPid"
# tracepid=$(adb shell cat proc/${pid}/status|grep "TracerPid")



echo $uid $pid $ppid $pname
# echo $tracepid
done