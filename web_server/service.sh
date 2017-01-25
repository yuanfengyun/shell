#/bin/bash

base=/var/www

read request
path=`echo $request | cut -d' ' -f2`
file_path="${base}${path}"
echo $file_path > a.txt

len=`wc -c $file_path | cut -d' ' -f1`
echo -ne "HTTP/1.1 200 OK\r\n"
echo -ne "Content-Length:${len}\r\n"
echo -ne "Content-Type: text/html\r\n\r\n"
cat $file_path
