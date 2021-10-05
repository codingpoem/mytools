#!/bin/sh


#准备脚本环境
if test `uname` == "Linux" ;then
    AAPT="/home/zdn/Android/Sdk/build-tools/30.0.3/aapt"
fi

if test `uname` == "Darwin" ;then
    AAPT="/Users/zdn/Library/Android/sdk/build-tools/28.0.3/aapt"
fi


getInfos(){
    ## aapt get packagename
    ls|egrep '\.apk$' | while read line
    do
    # echo $line
    #$AAPT dump badging $line \; 2>/dev/null|grep 'package: name'|cut -d "'" -f2
    packagename=`$AAPT dump badging $line 2> /dev/null|grep 'package: name'|cut -d "'" -f2`
    versionname=`$AAPT dump badging $line 2> /dev/null|grep 'versionName='|cut -d "'" -f6`
    applicationlabel=`$AAPT dump badging $line 2> /dev/null|grep 'application-label-zh-CN'|cut -d "'" -f2`
    if test -z $applicationlabel ; then
        applicationlabel=`$AAPT dump badging $line 2> /dev/null|grep 'application: label='|cut -d "'" -f2`
    fi

    if [ `uname` == "Linux" ]  ;then
        md5=`md5sum $line|cut -d" " -f1`

    fi

    if test `uname` == "Darwin" ;then
        md5=`md5 $line|cut -d "=" -f2`
    fi
    # echo $line $packagename $applicationlabel $md5
    # printf "%-10s\t%-10s\t%-30s\t%-20s\t%-10s\n"  $md5 "$line" "$packagename" "$applicationlabel" "$versionname"
    printf "%-45s %-15s %-35s %-50s %-20s\n"  "$packagename" "$versionname" $md5 "$line" "$applicationlabel" 

    # echo $applicationlabel
    # echo $md5
    # echo $packagename
    # echo $line
    # printf "|%-50s|\n"  $applicationlabel
    # echo "|$applicationlabel|"
    # printf "|%-50s|\n"  $md5
    # printf "|%-50s|\n"  $packagename
    # printf "|%-50s|\n"  $line
    done
}


startOne(){
    adb shell pm list package > ttmp
    ls|egrep '\.apk$' | while read line
do
    packagename=`$AAPT dump badging $line 2> /dev/null|grep 'package: name'|cut -d "'" -f2`

    if test ! -e "installed.list" ;then
        touch installed.list
    fi

    #grep $packagename ttmp || grep $packagename installed.list
    grep $packagename installed.list

    if test $? -eq 1 ; then
        #       adb uninstall  $packagename
        # adb install -r $line

        adb shell monkey -p $packagename -c android.intent.category.LAUNCHER 1
        echo $packagename $line |tee -a  installed.list
        grep $line apksinfo.txt

        exit 0
    fi
done
rm ttmp
}


installOne(){
adb shell pm list package > ttmp
ls|egrep '\.apk$' | while read line
do
packagename=`$AAPT dump badging $line 2> /dev/null|grep 'package: name'|cut -d "'" -f2`

if test ! -e "installed.list" ;then
    touch installed.list
fi

#grep $packagename ttmp || grep $packagename installed.list
grep $packagename ttmp installed.list

if test $? -eq 1 ; then
    #     adb uninstall  $packagename
    adb install -r $line
    echo $packagename $line |tee -a  installed.list

    grep $line apksinfo.txt

    exit 0
fi
done
rm ttmp
}


uninstallAll(){
# ### uninstall apks
adb shell pm list package > ttmp
ls|egrep '\.apk$' | while read line
do
packagename=`$AAPT dump badging $line 2> /dev/null|grep 'package: name'|cut -d "'" -f2`
grep $packagename ttmp
if test $? -eq 0 ; then
adb uninstall  $packagename
fi
done
rm ttmp
}



forcestop(){
# #### start stop and clean applicationlabel
ls|egrep '\.apk$' | while read line
do
packagename=`$AAPT dump badging $line 2> /dev/null|grep 'package: name'|cut -d "'" -f2`
# echo "adb shell monkey -p " $packagename " -c android.intent.category.LAUNCHER 1"
echo "adb shell am force-stop " $packagename
# echo "adb shell pm clear "  $packagename
done
}


pmclear(){
#### start stop and clean applicationlabel
ls|egrep '\.apk$' | while read line
do
packagename=`$AAPT dump badging $line 2> /dev/null|grep 'package: name'|cut -d "'" -f2`
# echo "adb shell monkey -p " $packagename " -c android.intent.category.LAUNCHER 1"
# echo "adb shell am force-stop " $packagename
echo "adb shell pm clear "  $packagename
done
}


unzip(){
ls |egrep '\.apk$'| while read line
do
DIRNAME=${line/.apk/}
# echo $line $DIRNAME
# mv $line ${DIRNAME}.apk
unzip $line -d $DIRNAME
# find $DIRNAME|egrep 'toy|zkfv'|grep so|xargs -n1 md5
echo '------'
done
}


case $1 in
    "getinfos")
        getInfos;
        ;;
    "uninstallall")
        uninstallAll;
        ;;
    "startone")
        startOne;
        ;;
    "installone")
        installOne;
        ;;
    "forcestop")
        forcestop;
        ;;
    "pmclear")
        pmclear;
        ;;
    "unzip")
        unzip;
        ;;
    *)
        echo "error"
esac




# getInfos;
# uninstallAll;
# startOne;
# installOne;
# forcestop;
# pmclear;

