#!/bin/bash

# Conn (showconn)
# r2018-08-17 fr2018-05-12
# by Valerio Capello - http://labs.geody.com/ - License: GPL v3.0

STARTTIME=$(date);
STARTTIMESEC=$(date +%s);

# Config
tsminon="\e[0;31m"; tsminof="\e[0m"; # Color for min value (on/off)
tsmaxon="\e[0;32m"; tsmaxof="\e[0m"; # Color for max value (on/off)
tsavgon="\e[0;33m"; tsavgof="\e[0m"; # Color for average value (on/off)
fne="/var/log/netstat-an.txt"; # Temp File Name
shwmem=1; # Show Memory Usage
maxtim=-1; # Quit after cycling given times ( -1 : Infinite )
maxsec=-1; # Quit after given seconds ( -1 : Infinite )


cnti=0;
while :
do
(( ++cnti ))

netstat -an > $fne

conntot="$(cat $fne | awk '{print $6}' | grep 'ESTABLISHED' | wc -l)";
conntottcp="$(cat $fne | awk '{print $1 " " $6}' | grep 'tcp' | grep 'ESTABLISHED' | wc -l)";
conntotudp="$(cat $fne | awk '{print $1 " " $6}' | grep 'udp' | grep 'ESTABLISHED' | wc -l)";
pt='22'; connsshpt="$pt"; connssh="$(cat $fne | awk '{print $4 " " $6}' | grep ":$pt " | grep 'ESTABLISHED' | wc -l)";
pt='443'; connhtspt="$pt"; connhts="$(cat $fne | awk '{print $4 " " $6}' | grep ":$pt " | grep 'ESTABLISHED' | wc -l)";
pt='80'; connhttpt="$pt"; connhtt="$(cat $fne | awk '{print $4 " " $6}' | grep ":$pt " | grep 'ESTABLISHED' | wc -l)";
connotr="$(cat $fne | awk '{print $4 " " $6}' | grep 'ESTABLISHED' | grep -v ":22 " | grep -v ":443 " | grep -v ":80 " | wc -l)";

if [ "$cnti" -eq 1 ]; then
conntotsm="$conntot"; conntotmx="$conntot"; conntotmn="$conntot"; conntotav="$conntot";
conntottcpsm="$conntottcp"; conntottcpmx="$conntottcp"; conntottcpmn="$conntottcp"; conntottcpav="$conntottcp";
conntotudpsm="$conntotudp"; conntotudpmx="$conntotudp"; conntotudpmn="$conntotudp"; conntotudpav="$conntotudp";
connsshsm="$connssh"; connsshmx="$connssh"; connsshmn="$connssh"; connsshav="$connssh";
connhtssm="$connhts"; connhtsmx="$connhts"; connhtsmn="$connhts"; connhtsav="$connhts";
connhttsm="$connhtt"; connhttmx="$connhtt"; connhttmn="$connhtt"; connhttav="$connhtt";
connotrsm="$connotr"; connotrmx="$connotr"; connotrmn="$connotr"; connotrav="$connotr";
else

if [ "$conntot" -gt "$conntotmx" ]; then
conntotmx=$conntot;
fi
if [ "$conntot" -lt "$conntotmn" ]; then
conntotmn=$conntot;
fi
conntotsm="$(( $conntotsm + $conntot ))";
conntotav="$(( $conntotsm / $cnti ))";

if [ "$conntottcp" -gt "$conntottcpmx" ]; then
conntottcpmx=$conntottcp;
fi
if [ "$conntottcp" -lt "$conntottcpmn" ]; then
conntottcpmn=$conntottcp;
fi
conntottcpsm="$(( $conntottcpsm + $conntottcp ))";
conntottcpav="$(( $conntottcpsm / $cnti ))";

if [ "$conntotudp" -gt "$conntotudpmx" ]; then
conntotudpmx=$conntotudp;
fi
if [ "$conntotudp" -lt "$conntotudpmn" ]; then
conntotudpmn=$conntotudp;
fi
conntotudpsm="$(( $conntotudpsm + $conntotudp ))";
conntotudpav="$(( $conntotudpsm / $cnti ))";

if [ "$connssh" -gt "$connsshmx" ]; then
connsshmx=$connssh;
fi
if [ "$connssh" -lt "$connsshmn" ]; then
connsshmn=$connssh;
fi
connsshsm="$(( $connsshsm + $connssh ))";
connsshav="$(( $connsshsm / $cnti ))";

if [ "$connhts" -gt "$connhtsmx" ]; then
connhtsmx=$connhts;
fi
if [ "$connhts" -lt "$connhtsmn" ]; then
connhtsmn=$connhts;
fi
connhtssm="$(( $connhtssm + $connhts ))";
connhtsav="$(( $connhtssm / $cnti ))";

if [ "$connhtt" -gt "$connhttmx" ]; then
connhttmx=$connhtt;
fi
if [ "$connhtt" -lt "$connhttmn" ]; then
connhttmn=$connhtt;
fi
connhttsm="$(( $connhttsm + $connhtt ))";
connhttav="$(( $connhttsm / $cnti ))";

if [ "$connotr" -gt "$connotrmx" ]; then
connotrmx=$connotr;
fi
if [ "$connotr" -lt "$connotrmn" ]; then
connotrmn=$connotr;
fi
connotrsm="$(( $connotrsm + $connotr ))";
connotrav="$(( $connotrsm / $cnti ))";

fi

clear

echo "Estabilished Connections"; echo;

CTIMESEC=$(date +%s)
echo "Start Time: $STARTTIME";
echo "Curr. Time: $(date)";
echo "Cycles: $cnti - Seconds elapsed: $(($CTIMESEC - $STARTTIMESEC))";
echo;
echo -n "Total: $conntot - "; echo -ne "$tsminon"; echo -n "Min: $conntotmn"; echo -ne "$tsminof"; echo -n " , "; echo -ne "$tsmaxon"; echo -n "Max: $conntotmx"; echo -ne "$tsmaxof"; echo -n " , "; echo -ne "$tsavgon"; echo -n "Avg: $conntotav"; echo -e "$tsavgof";
echo -n "Total TCP: $conntottcp - "; echo -ne "$tsminon"; echo -n "Min: $conntottcpmn"; echo -ne "$tsminof"; echo -n " , "; echo -ne "$tsmaxon"; echo -n "Max: $conntottcpmx"; echo -ne "$tsmaxof"; echo -n " , "; echo -ne "$tsavgon"; echo -n "Avg: $conntottcpav"; echo -e "$tsavgof";
echo -n "Total UDP: $conntotudp - "; echo -ne "$tsminon"; echo -n "Min: $conntotudpmn"; echo -ne "$tsminof"; echo -n " , "; echo -ne "$tsmaxon"; echo -n "Max: $conntotudpmx"; echo -ne "$tsmaxof"; echo -n " , "; echo -ne "$tsavgon"; echo -n "Avg: $conntotudpav"; echo -e "$tsavgof";
echo -n "SSH (port $connsshpt): $connssh - "; echo -ne "$tsminon"; echo -n "Min: $connsshmn"; echo -ne "$tsminof"; echo -n " , "; echo -ne "$tsmaxon"; echo -n "Max: $connsshmx"; echo -ne "$tsmaxof"; echo -n " , "; echo -ne "$tsavgon"; echo -n "Avg: $connsshav"; echo -e "$tsavgof";
echo -n "HTTPS (port $connhtspt): $connhts - "; echo -ne "$tsminon"; echo -n "Min: $connhtsmn"; echo -ne "$tsminof"; echo -n " , "; echo -ne "$tsmaxon"; echo -n "Max: $connhtsmx"; echo -ne "$tsmaxof"; echo -n " , "; echo -ne "$tsavgon"; echo -n "Avg: $connhtsav"; echo -e "$tsavgof";
echo -n "HTTP (port $connhttpt): $connhtt - "; echo -ne "$tsminon"; echo -n "Min: $connhttmn"; echo -ne "$tsminof"; echo -n " , "; echo -ne "$tsmaxon"; echo -n "Max: $connhttmx"; echo -ne "$tsmaxof"; echo -n " , "; echo -ne "$tsavgon"; echo -n "Avg: $connhttav"; echo -e "$tsavgof";
echo -n "Other connections: $connotr - "; echo -ne "$tsminon"; echo -n "Min: $connotrmn"; echo -ne "$tsminof"; echo -n " , "; echo -ne "$tsmaxon"; echo -n "Max: $connotrmx"; echo -ne "$tsmaxof"; echo -n " , "; echo -ne "$tsavgon"; echo -n "Avg: $connotrav"; echo -e "$tsavgof";

# echo; echo "NOT HTTPS/HTTP Estabilished Connections (excluding ports 443, 80): "; cat $fne | grep -v ":443 " | grep -v ":80 " | grep 'ESTABLISHED'

if [ "$shwmem" -eq 1 ]; then
echo; free;
fi

read -s -t 1 -N 1 input
if [[ $input = 'q' ]] || [[ $input = 'Q' ]] || [[ $input = $'\e' ]]; then
echo;
break;
fi

if [ $maxtim -gt -1 -a $cnti -ge $maxtim ]; then
echo;
break;
fi

if [ $maxsec -gt -1 -a $(($CTIMESEC - $STARTTIMESEC)) -ge $maxsec ]; then
echo;
break;
fi

done
