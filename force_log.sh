#am force-stop强杀进程，并且记录强杀过程中logcat日志




# app_uid="a149"
# pkg_name="com.maiya.xiangyu"

# app_uid="a292"
# pkg_name="com.cleandroid.server.ctsthor"

pkg_name=$1
app_uid=`adb shell ps -ef|grep $pkg_name|awk '{sub(/u0_a/,"")}{print $1}'|sort -u|tail -1`

date=`date +"%Y%m%d%H%M%S"`


adb shell ps -ef|grep $app_uid >>$date.log
echo '------------------------------------------------'>>$date.log

v_pid=`adb shell ps -ef|grep $app_uid |head  -1 |awk '{print $2}'`
adb logcat -c
adb shell am force-stop $pkg_name
while true; do
	#process teminate
	adb shell ps -ef|grep $app_uid
	if [  $? == 0 ];then
		break
	fi

	#process relive
	v_pid2=`adb shell ps -ef|grep $app_uid |head  -1 |awk '{print $2}'`
	adb shell ps -ef|grep $app_uid
	if [  $v_pid != $v_pid2 ];then
		break
	fi

	sleep 0.2
done

	
sleep 1
adb logcat -d >> $date.log
echo '------------------------------------------------'>>$date.log

adb shell ps -ef|grep $app_uid >>$date.log


