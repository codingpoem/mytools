
cmd=$1
ttime=$2

while true
do

echo '\n-------' `date` '---------'
echo $cmd|sh
sleep $ttime
done