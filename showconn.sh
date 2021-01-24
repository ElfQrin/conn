#!/bin/bash

# Conn (showconn)
# r2021-01-24 fr2018-05-12
# by Valerio Capello - https://labs.geody.com/ - License: GPL v3.0

STARTTIME=$(date);
STARTTIMESEC=$(date +%s);

# Config

tsminon="\e[1;34m"; tsminof="\e[0m"; # Color for min value (on/off)
tsmaxon="\e[1;31m"; tsmaxof="\e[0m"; # Color for max value (on/off)
tsavgon="\e[0;33m"; tsavgof="\e[0m"; # Color for average value (on/off)
shwnohttpeconns=false; # Show NOT HTTPS/HTTP Estabilished Connections (excluding ports 443, 80)
shwcpuavld=true; # Show CPU Average Load
shwmem=true; # Show Memory Usage
shwusehr=true; # Show Memory Usage in Human Readable Format
maxtim=-1; # Quit after cycling given times ( -1 : Infinite )
maxsec=-1; # Quit after given seconds ( -1 : Infinite )
cls=1; # Clear Screen before showing any cycle (1: True, 0: False)


# Functions

apphdr() {
echo "Conn";
echo "by Valerio Capello - labs.geody.com - License: GPL v3.0";
}


# Get Parameters

if [ "$#" -eq 1 ]; then
if [ $1 -gt 0 ]; then maxtim=$1 ; fi
fi


# Main

cnti=0;
while :
do
(( ++cnti ))

fne=$( netstat -an );

conntot=$(printf "$fne\n" | awk '{print $6}' | grep 'ESTABLISHED' | wc -l);
conntottcp=$(printf "$fne\n" | awk '{print $1 " " $6}' | grep 'tcp' | grep 'ESTABLISHED' | wc -l);
conntotudp=$(printf "$fne\n" | awk '{print $1 " " $6}' | grep 'udp' | grep 'ESTABLISHED' | wc -l);
pt='22'; connsshpt="$pt"; connssh=$(printf "$fne\n" | awk '{print $4 " " $6}' | grep ":$pt " | grep 'ESTABLISHED' | wc -l);
pt='443'; connhtspt="$pt"; connhts=$(printf "$fne\n" | awk '{print $4 " " $6}' | grep ":$pt " | grep 'ESTABLISHED' | wc -l);
pt='80'; connhttpt="$pt"; connhtt=$(printf "$fne\n" | awk '{print $4 " " $6}' | grep ":$pt " | grep 'ESTABLISHED' | wc -l);
connotr=$(printf "$fne\n" | awk '{print $4 " " $6}' | grep 'ESTABLISHED' | grep -v ":22 " | grep -v ":443 " | grep -v ":80 " | wc -l);

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

if [ $maxtim -ne 1 ]; then
if [ $cls -eq 1 ]; then clear; fi
fi

if [ $cls -eq 1 ] || [ $cnti -eq 1 ]; then
apphdr; echo;
echo "Estabilished Connections"; echo;
fi

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

if ( $shwnohttpeconns ); then
echo; echo "NOT HTTPS/HTTP Estabilished Connections (excluding ports 443, 80): "; printf "$fne\n" | grep -v ":443 " | grep -v ":80 " | grep 'ESTABLISHED'
fi

if ( $shwcpuavld ); then
echo; echo -n "CPU average load (Cores: "; grep -c 'processor' /proc/cpuinfo  | tr -d '\n' ; echo -n "): "; uptime | awk -F'[a-z]:' '{print $2}' | xargs | awk '{print "1 m: "$1" 5 m: "$2" 15 m: "$3}';
fi

if ( $shwmem ); then
echo; 
if ( $shwusehr ); then
free -h | xargs | awk '{print "Memory: Size: "$8" Used: "$9" Free: "$10" Avail: "$13}';
swapon --show --noheadings --raw | xargs | awk '{print "Swap File: Dev: "$1" Total: "$3" Used: "$4}';
else
free;
fi
fi

if [ $cls -eq 0 ]; then echo; echo; fi

if [ $maxtim -ne 1 ]; then
read -s -t 1 -N 1 input
if [[ $input = 'q' ]] || [[ $input = 'Q' ]] || [[ $input = $'\e' ]]; then
echo;
break;
fi
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
