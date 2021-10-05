### argv1 : apktool工具生成的目录

KEY_FILE=/Users/zdn/work/mytools/bin/android.keystore
KEY_PW=hello123
PROJECT_DIR=$1

java -jar /Users/zdn/work/reverseTools/apktool/apktool_2.5.0.jar b ${PROJECT_DIR}
# java -jar /Users/zdn/work/reverseTools/apktool/apktool_2.5.0.jar b com.cleandroid.server.ctsthor

REPACKED_APK=`ls ${PROJECT_DIR}/dist/*apk`
SIGNED_APK="aaa.apk"

jarsigner -keystore ${KEY_FILE} -signedjar ${SIGNED_APK} ${REPACKED_APK} androidtest <<EOF
${KEY_PW}
EOF
#adb install -r -g aaa.apk
