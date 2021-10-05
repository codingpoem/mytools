#!/bin/sh
#########################################################
# Function :show adj value of UID                	    
# Date     :2021-05-13                                  
# Author   :zdn			                                
# $1: UID
#########################################################

adb shell ps -ef|grep $1 1>/dev/null 2>&1
if [ ! $? -eq 0 ]; then
	echo "$1 is not alive"	
	exit
fi




printf "%-6s\t%-6s\t%-8s\t%-8s\t%-8s\t%-8s\n" "UID" "PID" "oom_adj" "oom_score" "oom_score_adj" "CMD"
adb shell ps -ef|grep $1|awk '{print $2,$8}' | while read line 
do
uid=$1
pid=${line% *}
pname=${line#* }

ooms=$(adb shell << EOF|xargs
su
cat /proc/${pid}/oom_adj
cat /proc/${pid}/oom_score
cat /proc/${pid}/oom_score_adj
exit
EOF
)

printf "%-6s\t%-6s\t%-8s\t%-8s\t%-8s\t%-8s\n" $uid $pid $ooms $pname
done