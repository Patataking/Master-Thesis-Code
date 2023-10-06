#!/bin/bash 

touch log-loop.txt
touch ossl.txt
touch dump.txt
touch dump-all.pcap

# Start package capture
tcpdump -i any not icmp6 -ttttt -vvv -w /src/dump-all.pcap &

for (( i=1; i<=500000; i++ ))
do

touch /src/$i.pcap
tcpdump -i any not icmp6 -ttttt -vvv -c 16 -w /src/$i.pcap < dump.txt &

#$!  contain the(PID) of the last job that was backgrounded
# write PID in file
touch tcpdump.pid
echo $! > /src/tcpdump.pid

openssl s_client -connect localhost:44330 < ossl.txt

# Interrupt tcpdump for this PID
sleep 0.05

if [ -f /src/tcpdump.pido ]
then
        kill `cat /src/tcpdump.pid`
        rm -f /src/tcpdump.pid
else
        echo tcpdump not running.
fi

done > log-loop.txt

if [ -f /src/log-loop.txt ]
then       
        rm -f /src/log-loop.txt
fi
if [ -f /src/ossl.txt ]
then       
        rm -f /src/ossl.txt
fi
if [ -f /src/ossl.txt ]
then       
        rm -f /src/dump.txt
fi

if [ -f /src/tcpdump.pid]
then       
        rm -f /src/tcpdump.pid
fi

exit 0