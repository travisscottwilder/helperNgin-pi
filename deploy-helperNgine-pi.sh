#!/bin/bash 
#
#	if you get special character error:
#		NOTEPAD++: 	Edit --> EOL Conversion --> UNIX/OSX Format
#		LINUX:		sed -i -e 's/\r$//' scriptname.sh
#



#small upgrade of the system
sudo apt-get update -y;
sudo apt-get clean;
sudo apt-get install git -y;

echo "one";

#clone the actual repository that has all the files
git clone https://github.com/travisscottwilder/helperNgin-pi.git

echo "two";

#cd into that folder and run the actual pi helper
cd helperNgin-pi;
sudo chmod +x runthis.sh;sudo ./runthis.sh;

