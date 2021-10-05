#!/bin/sh
#批量下载hash


if [ ! $# -eq 2 ]; then
	echo "error:argv1:hash.txt, argv2:downloadDIR"
	exit
fi



while read line 
do

hash=$line
OUTDIR=$2
link=http://sample.antiy/download/${hash}


echo "wget $link -P ${OUTDIR}"
wget -nc $link -P ${OUTDIR}		#下载

mv ${OUTDIR}/${line} ${OUTDIR}/${line}.apk	#文件名称加.apk后缀


done < $1