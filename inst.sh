#!/bin/bash 
#
#	if you get special character error:
#		NOTEPAD++: 	Edit --> EOL Conversion --> UNIX/OSX Format
#		LINUX:		sed -i -e 's/\r$//' scriptname.sh
#

STARTTIME=$(date +%s);

red=$'\e[01;31m'
green=$'\e[01;32m'
yellow=$'\e[01;33m'
blue=$'\e[01;34m'
magenta=$'\e[01;35m'
resetColor=$'\e[0m'

exe_twoFresh=false;
exe_threeInstallNode=false;
exe_nodeA=false;
exe_nodeB=false;
exe_nodeC=false;
exe_fourArgo=false;
exe_fiveGPIOpython=false;
exe_sixoLED=false;
exe_sevenC9=false;

exe_actionDone="NA";

c9userPass="";
userToUse="";
c9portToUse=9191;




#
#
#
#
#
#
freshInstall() {
	echo "";
	echo "${blue}--- Fresh Install - updating System --------------------------------------------${resetColor}"

	sudo apt-get update -y;
	sudo apt-get install bc;
	
	drawTimeElapsed
	
	sudo apt-get upgrade -y;
	
	drawTimeElapsed
	
	sudo apt-get clean;
	sudo apt full-upgrade -y;
	sudo apt-get clean;
	
	drawTimeElapsed
	
	#INSTALL FIREWALL AND ALLOW OUR EXPECTED PORTS
	sudo apt install ufw -y;
	sudo ufw allow 22; sudo ufw allow 80;sudo ufw allow 443;
	sudo ufw enable;
	
	drawTimeElapsed
	
	#install brute force auto ban software
	sudo apt install fail2ban -y;
	sudo service fail2ban start;
	
	sudo apt-get install git -y;
	
	
	echo "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	
	sudo shutdown -h now;
}





#
#
#
#
#
#
installNodeJS() {
	echo "";
	echo "${blue}--- Install NodeJS --------------------------------------------${resetColor}"

	
	#sudo apt remove node -y;sudo apt remove nodejs -y;sudo apt remove npm -y;
	#cd ~;curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -;
	
	
	#sudo npm install pip3 -y;
	#sudo npm install;sudo npm install rpio --save;


	sudo apt-get install -y nodejs;
	sudo apt-get install -y python3-pip;
	sudo pip3 install --upgrade setuptools;
	sudo apt-get install -y npm;


	echo "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	
	
	#sudo mkdir WebServer;
	#cd /mnt/SDB/WebServer;npm install;npm install rpio --save;
	
	#FIX YARN:
	#sudo apt remove cmdtest
	#sudo apt remove yarn
	#curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	#echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	#sudo apt-get update
	#sudo apt-get install yarn -y
}



#
#
#
#
#
#
installARGOFanScript() {
	echo "";
	echo "${blue}--- Install ARGO Case Fan Script --------------------------------------------${resetColor}"

	
	
	drawTimeElapsed
	
	curl https://download.argon40.com/argon1.sh | bash 
	argonone-config
	
	drawTimeElapsed
	
	
	echo "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
}



#
#
#
#
#
#
installGPIOPythonLibs() {
	echo "";
	echo "${blue}--- Install GPIO Python Libs --------------------------------------------${resetColor}"

	sudo npm install rpio --save;
	sudo npm install rpio;
	drawTimeElapsed
	
	echo "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	
	drawTimeElapsed
	
	#ACCESS GPIO PINS
	#ACCESS GPIO PINS
	#ACCESS GPIO PINS

	#enable i2c and SPI interfaces
	#sudo raspi-config
	#	-> Interface Options -> enable I2C and SPI

	#confirm interfaces on are on -> will return something like "XXX_bcm24323"
	#lsmod | grep i2c_
	#lsmod | grep spi_
	
	
	
	
	
	#NODE EXAMPLE
	#git clone https://github.com/tutRPi/Raspberry-Pi-Simple-Web-GPIO-GUI;cd Raspberry-Pi-Simple-Web-GPIO-GUI;npm install;sudo npm start;
	#	-> then go to the node project in the web browser 
	#		-> WEBSITE.com/Raspberry-Pi-Simple-Web-GPIO-GUI

	#npm install rpio --save;
	#npm install rpio;
	#https://github.com/jperkin/node-rpio/blob/master/examples/blink.js
	
	
	#import the GPIO and time package
	#import RPi.GPIO as GPIO
	#import time
	#GPIO.setmode(GPIO.BOARD)
	#GPIO.setup(7, GPIO.OUT)
	# loop through 50 times, on/off for 1 second
	#for i in range(50):
	#	GPIO.output(7,True)
	#	time.sleep(1)
	#	GPIO.output(7,False)
	#	time.sleep(1)
	#GPIO.cleanup()	
	
}



#
#
#
#
#
#
installOLEDScreenPythonOne() {
	echo "";
	echo "${blue}--- Install OLED Screen Python Scripts & Libs ONE [A]--------------------------------------------${resetColor}"


	cd ~;
	sudo apt-get install -y python3-pip;
	sudo pip3 install --upgrade adafruit-python-shell
	
	
	echo "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	drawIntroScreen
	
	sudo reboot
}

#
#
#
#
#
#
installOLEDScreenPythonTwo() {
	echo "";
	echo "${blue}--- Install OLED Screen Python Scripts & Libs TWO [B]--------------------------------------------${resetColor}"


	cd ~;
	wget https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/raspi-blinka.py;
	sudo python3 raspi-blinka.py
	
	sudo pip3 install -adafruit-circuitpython-ssd1306
	sudo pip3 install -psutil
	
	
	echo "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	drawIntroScreen
	
	sudo reboot;
}

#
#
#
#
#
#
installOLEDScreenPythonThree() {
	echo "";
	echo "${blue}--- Install OLED Screen Python Scripts & Libs THREE [C] --------------------------------------------${resetColor}"


	cd ~;
	sudo apt-get install python3-pil;
	
	git clone https://github.com/mklements/OLED_Stats.git;
	
	cd OLED_Stats;
	cp PixelOperator.ttf ~/PixelOperator.ttf
	cp stats.py ~/stats.py
	
	cp psutilstats.py ~/psutilstats.py
	cp lineawesome-webfont.ttf ~/lineawesome-webfont.ttf
	cp monitor.py ~/monitor.py
	
	python3 /home/tdub/monitor.py;
	
	
	echo "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"

}





#
#
#
#
installC9() {
	
	
	sudo apt-get install -y python2;
	sudo npm install -g --save optimist
	sudo ufw allow ${c9portToUse};
	
	cd ~;wget http://nodejs.org/dist/v0.10.28/node-v0.10.28-linux-arm-pi.tar.gz;
	cd /usr/local

	tar -xzf ~/node-v0.10.28-linux-arm-pi.tar.gz --strip=1
	export NODE_PATH="/usr/local/lib/node_modules"
	
	
	
	git clone https://github.com/c9/core.git c9sdk;
	cd c9sdk;
	sudo scripts/install-sdk.sh;
	#ln -s /usr/local/c9sdk/server.js /home/tdub/launchc9.js;
	
	forever start /usr/local/c9sdk/server.js -w / -l 0.0.0.0 -p $c9portToUse -a $userToUse:$c9userPass
	
	#echo "sudo /home/tdub/launchc9.js -w / -l 0.0.0.0 -p 9191 -a :;"
  	
  return;
  
	#sudo yum update -y;
	#sudo yum -y install epel-release npm;
	#drawTimeElapsed
	#sudo yum -y groupinstall 'Development Tools';
	#sudo yum -y install make nodejs git gcc glibc-static ncurses-devel;
	#drawTimeElapsed
	
	#cd /home/$userToUse;
	
	
	#npm install forever -g;
	#drawTimeElapsed
	#npm i forever -g;
	
	#chmod 777 /var/www -R;

	#su -c 'git clone https://github.com/c9/core.git c9sdk;cd c9sdk; pwd;scripts/install-sdk.sh;' $userToUse
	#drawTimeElapsed
	#su -c "forever start /home/$userToUse/c9sdk/server.js -w /var/www -l 0.0.0.0 -p $c9portToUse -a $userToUse:$c9userPass;" $userToUse

	# node start /home/USER/c9sdk/server.js -w /var/www -l 0.0.0.0 -p 9191 -a username:passwordhere;
	#-> forever stop /home/USER/c9sdk/server.js;
	
}



#get access to your SSD that is actually a usb (ARGON METAL CASE)
#find "SDA" device:
#lsblk
#create directory and mount above SDA identified to newly created folder
#cd /mnt/;sudo mkdir SDB;sudo mount /dev/sdaXXXX /mnt/SDB;sudo chmod 777 /mnt/SDB -Rf;




#
#
#
drawIntroScreen(){
	#clear
	echo "";
	echo "";
	echo "${green}";
	echo "------------------------------------------------"
	echo "------------------------------------------------"
	echo "-----   ${magenta}Raspberry Pi INSTALLER HELPER${green}   -----"
	echo "------------------------------------------------"
	echo "------------------------------------------------${resetColor}"
	echo ""
	echo ""
}






#
#
#
drawOptionsMenu(){
	drawIntroScreen
	
	echo "${green}";
	
	echo "------------------------------------------------"
	echo "-----    ${blue}Available Options${green}    -----"
	echo "------------------------------------------------"
	echo ""
	echo "${blue} 1 ${green} |${resetColor} Full Install"
	echo ""
	echo "${blue} 2 ${green} |${resetColor} Fresh Install Cleanup & misc Utils"
	echo "${blue} 3 ${green} |${resetColor} Install NodeJS & Utils"
	echo "${blue} 4 ${green} |${resetColor} Install Argo Case Fan Script"
	echo "${blue} 5 ${green} |${resetColor} GPIO Python Libs"
	echo "${blue} 6 ${green} |${resetColor} OLED Screen Python Libs"
	echo "${blue} 7 ${green} |${resetColor} Cloud9 IDE"
	echo "${blue} 8 ${green} |${resetColor} Add new port to firewall"
	echo "${blue} 9 ${green} |${resetColor} Mount external USB & automount it"
	echo "";
	echo "${blue} q ${green} |${red} Quit${resetColor}"
	
	
	
	
	while true; do
		read -p "${yellow}--- Select an option to continue [2-9] --------------------------------------------${resetColor}" yn
		case $yn in

			[2]* ) 
				exe_twoFresh=true;
				exe_actionDone="2) Cleaned up & misc Utils";
				break;;
			[3]* ) 
				exe_threeInstallNode=true;
				exe_actionDone="3) Installed NodeJS";
				break;;
			[4]* ) 
				exe_fourArgo=true;
				exe_actionDone="4) Installed ARGO metal case fan script";
				break;;
			[5]* ) 
				exe_fiveGPIOpython=true;
				exe_actionDone="5) Installed GPIO Python Library";
				break;;
			[6]* ) 
				exe_sixoLED=true;
				exe_actionDone="6) Installed OLED";
				break;;
			[7]* ) 
				exe_sevenC9=true;
				exe_actionDone="7) Created C9 IDE";
				break;;
			[qQquit]* ) exit;;
			
			
			* ) echo "Please answer a number [1-7].";;
		esac
	done
	
}






#
#
#
#
drawSummary() {
	drawIntroScreen

	echo "${green}------------------------------------------------"
	echo "------------------------------------------------"
	echo "-------------       ${red}SUMMARY${green}      -------------"
	echo "------------------------------------------------"
	drawTimeElapsed
	echo "------------------------------------------------${resetColor}"
	echo ""
	echo "${blue}";
	echo "------------------------------------------------"
	echo "";
	echo "${red}Action Done             ${blue}|${resetColor} ${exe_actionDone}";
	echo "";
	
	


	
	echo "${blue}";
	echo "------------------------------------------------${resetColor}"
	echo "";
}








drawTimeElapsed(){
	
	secondsLasped="$(($(date +%s) - ${STARTTIME}))";
	
	if [[ -z ${secondsLasped} || ${secondsLasped} -lt 60 ]] ;then
            min=0 ; secs="${secondsLasped}"
        else
            time_mins=$(echo "scale=2; ${secondsLasped}/60" | bc)
            min=$(echo ${time_mins} | cut -d'.' -f1)
            secs="0.$(echo ${time_mins} | cut -d'.' -f2)"
            secs=$(echo ${secs}*60|bc|awk '{print int($secondsLasped+0.5)}')
        fi
    
	echo "${blue}------------------------------------------------${resetColor}"
	echo "${red}------------------------------------------------${resetColor}"
	echo "---------------- Time Lapsed ${min}m & ${secs}s ---------------"
	echo "${red}------------------------------------------------${resetColor}"
	echo "${blue}------------------------------------------------${resetColor}"
}







###########################################
########################################################################
########################################################################
######################################################################## START LOGIC #####
########################################################################
########################################################################
###########################################






drawIntroScreen;



echo "${red} NOTE - This helper was created to be used on Raspberry pi OS lite 32bit. ${resetColor}"
echo "";

while true; do
	read -p "${yellow}--- Would you like to continue? [y/n] --------------------------------------------${resetColor}" yn
	case $yn in
		[Yy]* )  
			break;;
		[Nn]* ) exit;;
		* ) echo "Please answer [y/n].";;
	esac
done






drawOptionsMenu;





echo "";
echo "";


if [ "$exe_sixoLED" = true ]; then
	while true; do
		read -p "${yellow}--- What mode of the OLED install would you like to do?? [a/b/c] --------------------------------------------${resetColor}" yn
		case $yn in
			[aA]* )  exe_nodeA=true;
				break;;
			[bB]* ) exe_nodeB=true;
				break;;
			[cC]* ) exe_nodeC=true;
				break;;
			* ) echo "Please answer [y/n].";;
		esac
	done
fi


if [ "$exe_sevenC9" = true ]; then
	echo "";
	echo "";
	echo "${yellow}--- Enter in the name of the user to create for C9 --------------------------------------------${resetColor}"
	echo "";
	read userToUse
	
	echo "";
	echo "";
	echo "${yellow}--- Enter in the password for ${red}C9${yellow} user [$userToUse] about to be created in order to access IDE --------------------------------------------${resetColor}"
	read c9userPass
fi








if [ "$exe_twoFresh" = true ]; then
	freshInstall
fi

if [ "$exe_threeInstallNode" = true ]; then
	installNodeJS
fi


if [ "$exe_fourArgo" = true ]; then
	installARGOFanScript
fi

if [ "$exe_fiveGPIOpython" = true ]; then
	installGPIOPythonLibs
fi


if [ "$exe_sixoLED" = true ]; then
	if [ "$exe_nodeA" = true ]; then
		installOLEDScreenPythonOne
	fi
	if [ "$exe_nodeB" = true ]; then
		installOLEDScreenPythonTwo
	fi
	if [ "$exe_nodeC" = true ]; then
		installOLEDScreenPythonThree
	fi
fi

if [ "$exe_sixMYSQLUSER" = true ]; then
	#install mysql user
	installMysqlUser
fi

if [ "$exe_sevenC9" = true ]; then
	installC9
fi



drawSummary
