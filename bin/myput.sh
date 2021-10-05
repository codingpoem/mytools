FILE=$1
# sftp zdn@10.251.0.35 << EOF
lftp -u zdn,66666 sftp://10.251.0.35:22 << EOF
cd tmp
put $FILE
EOF