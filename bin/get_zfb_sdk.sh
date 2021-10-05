#准备脚本环境
if test `uname` == "Linux" ;then
    AAPT="/home/zdn/Android/Sdk/build-tools/30.0.3/aapt"
fi

if test `uname` == "Darwin" ;then
    AAPT="/Users/zdn/Library/Android/sdk/build-tools/28.0.3/aapt"
fi


APK=$1
# echo $1
rm -rf tmp/*
unzip $APK -d tmp > /dev/null	
find tmp -type f|grep AndroidManifest.xml
if [ $? -ne 0 ];then
	APK=`find tmp -type f|head -1`
	find tmp -type f -exec unzip {} -d tmp >/dev/null \; 
	# echo hello
fi

# APK=`find tmp -type f|head -1`
# echo $APK	
# aapt dump badging $APK

packagename=`$AAPT dump badging $APK 2> /dev/null|grep 'package: name'|cut -d "'" -f2`
versionname=`$AAPT dump badging $APK 2> /dev/null|grep 'versionName='|cut -d "'" -f6`
applicationlabel=`$AAPT dump badging $APK 2> /dev/null|grep 'application-label-zh-CN'|cut -d "'" -f2`
if test -z $applicationlabel ; then
    applicationlabel=`$AAPT dump badging $APK2> /dev/null|grep 'application: label='|cut -d "'" -f2`
fi
echo $applicationlabel
echo $packagename
echo $versionname


find tmp/lib -type f|egrep 'toy|zkfv'|xargs -n1 md5
