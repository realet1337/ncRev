# ncRev
A quick and easy script to create reverse shells using netcat. Made for lazy people like me :) Also consider adding it to your bashrc for ultimate corner-cutting.

# Options
i : The ip address of the machine that the remote host will connect to. Default: 127.0.0.1 .  
p : The port used. Default: 1337.  
s : The shell used. Default: sh.  
m : The data flow. Default: 1.  
		1: pipe --> shell --> netcat --> pipe  
		2: pipe --> netcat --> shell --> pipe  
c : The command used to create the pipe. Default: fifo.  
		nod: mknod PIPENAME p  
		fifo: mkfifo PIPENAME  
n : The name of the pipe that will be created on the remote host. Default: f.  
h : Display the help page.

# Tips
You should change the pipename to avoid conflicting with other people who use the reverse shell from pentestmonkey: http://pentestmonkey.net/cheat-sheet/shells/reverse-shell-cheat-sheet.

Also, change the ip (duh).
