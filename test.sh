#!/bin/sh


#准备脚本环境
if test `uname` == "Linux" ;then
    AAPT="/home/zdn/Android/Sdk/build-tools/30.0.3/aapt"
fi

if test `uname` == "Darwin" ;then
    AAPT="/Users/zdn/Library/Android/sdk/build-tools/28.0.3/aapt"
    MD5="md5"
fi





# while getopts ":s:b:c:" opt
# do
#     case $opt in
#     s)
#         echo "参数a的值$OPTARG"

#     ;;
#     b)
#         echo "参数b的值$OPTARG"
#     ;;
#     c)
#         echo "参数c的值$OPTARG"
#     ;;
#     ?)
#         echo "未知参数"
#         exit 1
#     ;;
#     esac
# done



# getInfos();
# uninstallAll();

echo "hello"
# ### uninstall apks
adb shell pm list package > ttmp
ls|grep '.apk' | while read line
do
packagename=`$AAPT dump badging $line 2> /dev/null|grep 'package: name'|cut -d "'" -f2`
grep $packagename ttmp
if test $? -eq 0 ; then
adb uninstall  $packagename
fi
done
rm ttmp



getInfos(){
    ## aapt get packagename
    ls|grep '.apk' | while read line
do
    # echo $line
    #$AAPT dump badging $line \; 2>/dev/null|grep 'package: name'|cut -d "'" -f2
    packagename=`$AAPT dump badging $line 2> /dev/null|grep 'package: name'|cut -d "'" -f2`
    applicationlabel=`$AAPT dump badging $line 2> /dev/null|grep 'application-label-zh-CN'|cut -d "'" -f2`
    if test -z $applicationlabel ; then
        applicationlabel=`$AAPT dump badging $line 2> /dev/null|grep 'application: label='|cut -d "'" -f2`
    fi
    md5=`$MD5 $line|cut -d "=" -f2`
    # echo $line $packagename $applicationlabel $md5
    printf "%-10s\t%-10s\t%-30s\t%-20s\n"  $md5 "$line" "$packagename" "$applicationlabel"
    # echo $applicationlabel
    # echo $md5
    # echo $packagename
    # echo $line
    # printf "|%-50s|\n"  $applicationlabel
    # echo "|$applicationlabel|"
    # printf "|%-50s|\n"  $md5
    # printf "|%-50s|\n"  $packagename
    # printf "|%-50s|\n"  $line
    # done
}


startone(){
    adb shell pm list package > ttmp
    ls|grep '.apk' | while read line
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
ls|grep '.apk' | while read line
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
echo "hello"
# ### uninstall apks
adb shell pm list package > ttmp
ls|grep '.apk' | while read line
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
ls|grep '.apk' | while read line
do
packagename=`$AAPT dump badging $line 2> /dev/null|grep 'package: name'|cut -d "'" -f2`
# echo "adb shell monkey -p " $packagename " -c android.intent.category.LAUNCHER 1"
echo "adb shell am force-stop " $packagename
# echo "adb shell pm clear "  $packagename
done
}


pmclear(){
#### start stop and clean applicationlabel
ls|grep '.apk' | while read line
do
packagename=`$AAPT dump badging $line 2> /dev/null|grep 'package: name'|cut -d "'" -f2`
# echo "adb shell monkey -p " $packagename " -c android.intent.category.LAUNCHER 1"
# echo "adb shell am force-stop " $packagename
echo "adb shell pm clear "  $packagename
done
}
