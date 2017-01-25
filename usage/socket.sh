#/bin/bash
ip=$1
port=$2

ip=${ip:=127.0.0.1}
port=${port:=8000}

exec 5<>/dev/tcp/$ip/$port

read -t5 d <&5

echo "list" >&5

echo "list begin----------------------"
while read -t3 line <&5 ; do
    echo $line
done

echo "list end----------------------"


