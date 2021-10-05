adb shell pm list package -3 | sed 's/^package://g' |while read line
do

	grep $line while.list 1>/dev/null  2>&1 
	if [ $? -eq 0 ]; then	
		# echo $line
		continue	# $line in while.list
	fi
	echo $line
	adb uninstall $line
done
