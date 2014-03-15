import getpass 
import sys 
import telnetlib 
import string 
import re 

counter = 0 

def getInfo(): 
	HOST = "127.0.0.1" 

	tn = telnetlib.Telnet(HOST , 7505) 

	tn.read_until("info") 
	tn.write("status" + "\n") 
	string = tn.read_until("END") 
	tn.write("exit" + "\n") 
	return string 

# parse the output 
regex = re.compile("[a-zA-Z0-9]*\,[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}").match 
lines = string.split(getInfo(),"\n") 

# regex matching for each line, set the total number of occurrences 
for line in lines: 
	if regex(line): 
		counter += 1 

print counter