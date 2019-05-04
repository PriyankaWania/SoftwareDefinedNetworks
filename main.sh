#!/bin/bash

for i in {1..2000} #iterating over 2000 loops
do

sudo ovs-ofctl dump-flows s1 > jax1 #dump-flows - used to print all the flow entries of the particular switch to the console. In our case, dumps it in a csv file.
grep "nw_src" jax1 > jax2.csv #Collects all the source IP addresses and dumps it into a csv file.
awk -F "," '{split($4,a,"="); print a[2]","}' jax2.csv > jaxpackets.csv
awk -F "," '{split($5,d,"="); print d[2]","}' jax2.csv > jaxbytes.csv
awk -F "," '{split($14,b,"="); print b[2]","}' jax2.csv > jaxipsrc.csv
awk -F "," '{split($15,c,"="); print c[2]","}' jax2.csv > jaxipdst.csv
echo $i
python CollectE.py
sudo ovs-ofctl del-flows s1 #Flow entries are deleted from that switch
python Inspect.py
FILE="/home/priyanka/your-idea/Result.txt"
if test -f $FILE; then
r=$(awk '{print $0;}' Result.txt)
if [ $r -eq 1 ]; then
#echo "MITIGATE"
python mitigate.py
fi
fi
sleep 3
done
