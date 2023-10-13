#!/bin/bash 

#cd /src

touch log-loop.txt
touch ossl.txt
touch dump.txt
touch dump-all.pcap

tcpdump -i any not icmp6 -ttttt -vvv -w /src/dump-all.pcap &


for (( i=1; i<=500000; i++ ))
do
#echo "$i"

touch /src/$i.pcap

#tttt 	Print a timestamp in default format proceeded by date on #each dump line.
#tcpdump -w port 44330 /src/$i.pcap < log-loop.txt
# &=proc in background, vvv viele infos

#-c 25 Einschraenkung von 16 auf 25 Pakete erhoeht

tcpdump -i any not icmp6 -ttttt -vvv -c 25 -w /src/$i.pcap < dump.txt &

# wenn ping genutzt werden soll w-1 nur 1x ausführen
# ping -w 1 192.168.178.59 >> ping.txt

#neu
sleep 0.05

#$!  contain the(PID) of the last job that was backgrounded
# write PID in file
touch tcpdump.pid
echo $! > /src/tcpdump.pid

# IP-Adresse anstelle localhost
openssl s_client -connect 192.168.178.59:44331 < ossl.txt


# interrupt tcpdump for this PID


sleep 0.05

if [ -f /src/tcpdump.pido ]
then
        kill `cat /src/tcpdump.pid`
        #echo tcpdump `cat /src/tcpdump.pid` killed.
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
