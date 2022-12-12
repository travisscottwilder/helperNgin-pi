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

exe_two=false;
exe_three=false;

exe_nodeA=false;
exe_nodeB=false;
exe_nodeC=false;

exe_four=false;
exe_five=false;
exe_sixo=false;
exe_seven=false;

exe_11=false;
exe_12=false;
exe_13=false;
exe_14=false;
exe_15=false;
exe_16=false;
exe_17=false;
exe_18=false;
exe_19=false;

exe_actionDone="NA";

c9userPass="";
userToUse="";
askForOptions=true;

c9portToUse=9191;
log_marker="xxxxxxxxxx";





# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")







#
#	echos to the user and logs inside logs/runthis.log
#
log(){ echo $1 | tee -a "$SCRIPTPATH"/logs/runthis.log; }

#
# saves progress into logs/progress.log
#
save(){ echo $1 >> "$SCRIPTPATH"/logs/progress.log; }


#
#
#
#
#
#
freshInstallWithUtils() {
	log "";
	log "${blue}--- Fresh Install - updating System & Utils --------------------------------------------${resetColor}"


	sudo apt-get update -y | tee -a "$SCRIPTPATH"/logs/runthis.log;
	
	drawTimeElapsed
	
	sudo apt-get upgrade -y | tee -a "$SCRIPTPATH"/logs/runthis.log;
	
	drawTimeElapsed
	
	sudo apt-get clean | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo apt full-upgrade -y | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo apt-get clean | tee -a "$SCRIPTPATH"/logs/runthis.log;
	
	
	
	#install nano
	sudo apt-get install nano | tee -a "$SCRIPTPATH"/logs/runthis.log;
	
	
	#install bc common tools
	sudo apt-get install bc | tee -a "$SCRIPTPATH"/logs/runthis.log;
	
	drawTimeElapsed
	
	#INSTALL FIREWALL AND ALLOW OUR EXPECTED PORTS
	sudo apt install ufw -y | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo ufw allow 22 | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo ufw allow 80 | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo ufw allow 443 | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo ufw enable | tee -a "$SCRIPTPATH"/logs/runthis.log;
	
	drawTimeElapsed
	
	#install brute force auto ban software
	sudo apt install fail2ban -y | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo service fail2ban start | tee -a "$SCRIPTPATH"/logs/runthis.log;
	
	
	#install git
	sudo apt-get install git -y | tee -a "$SCRIPTPATH"/logs/runthis.log;
	

	log "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	drawTimeElapsed
	log "rebooting";
	log "rebooting";
	log "rebooting";
	sudo reboot now | tee -a "$SCRIPTPATH"/logs/runthis.log;
}





#
#
#
#
#
#
installNodeJS() {
	log "";
	log "${blue}--- Install NodeJS --------------------------------------------${resetColor}"

	sudo npm install -g rpio --save | tee -a "$SCRIPTPATH"/logs/runthis.log;

	sudo apt-get install -y nodejs | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo apt-get install -y python3-pip | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo pip3 install --upgrade setuptools | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo apt-get install -y npm | tee -a "$SCRIPTPATH"/logs/runthis.log;

	sudo npm install -g rpio --save | tee -a "$SCRIPTPATH"/logs/runthis.log;

	log "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	drawTimeElapsed
	
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
	log "";
	log "${blue}--- Install ARGO Case Fan Script --------------------------------------------${resetColor}"

	drawTimeElapsed
	
	curl https://download.argon40.com/argon1.sh | bash 
	argonone-config | tee -a "$SCRIPTPATH"/logs/runthis.log
	
	drawTimeElapsed

	log "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	drawTimeElapsed
}



#
#
#
#
#
#
installGPIOPythonLibs() {
	log "";
	log "${blue}--- Install GPIO Python Libs --------------------------------------------${resetColor}"

	sudo npm install -g rpio --save | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo npm install -g rpio | tee -a "$SCRIPTPATH"/logs/runthis.log;
	drawTimeElapsed
	
	log "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	
	drawTimeElapsed


	
}



#
#
#
#
#
#
installOLEDScreenPythonOne() {
	log "";
	log "${blue}--- Install OLED Screen Python Scripts & Libs ONE [A]--------------------------------------------${resetColor}"


	cd ~;
	sudo apt-get install -y python3-pip | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo pip3 install --upgrade adafruit-python-shell | tee -a "$SCRIPTPATH"/logs/runthis.log
	
	log "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	drawIntroScreen
	
	log "rebooting";
	log "rebooting";
	sudo reboot now | tee -a "$SCRIPTPATH"/logs/runthis.log;
}

#
#
#
#
#
#
installOLEDScreenPythonTwo() {
	log "";
	log "${blue}--- Install OLED Screen Python Scripts & Libs TWO [B]--------------------------------------------${resetColor}"


	cd ~;
	wget https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/raspi-blinka.py;
	sudo python3 raspi-blinka.py | tee -a "$SCRIPTPATH"/logs/runthis.log;
	
	sudo pip3 install --upgrade adafruit-circuitpython-ssd1306 | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo pip3 install --upgrade psutil | tee -a "$SCRIPTPATH"/logs/runthis.log;
	
	sudo apt-get install python3-pil | tee -a "$SCRIPTPATH"/logs/runthis.log;

	log "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	drawIntroScreen
	
	log "add an OLED script on boot: [NOTE- crontab is user specific, do you need root? [USE YOUR DEFAULT USER]]";
	log "crontab -e";
	log "@reboot python3 PATH_TO_SCRIPT/monitor.py &";
	
	log "rebooting";
	log "rebooting";
	log "rebooting";
	sudo reboot now | tee -a "$SCRIPTPATH"/logs/runthis.log;
}





#
#
#
#
installC9() {
	log "${blue}--- Install OLED Screen Python Scripts & Libs TWO [B]--------------------------------------------${resetColor}"
	
	sudo apt-get install -y python2 | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo npm install -g --save optimist | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo ufw allow ${c9portToUse} | tee -a "$SCRIPTPATH"/logs/runthis.log;
	
	cd ~;
	wget http://nodejs.org/dist/v0.10.28/node-v0.10.28-linux-arm-pi.tar.gz | tee -a "$SCRIPTPATH"/logs/runthis.log;
	cd /usr/local;

	tar -xzf ~/node-v0.10.28-linux-arm-pi.tar.gz --strip=1 | tee -a "$SCRIPTPATH"/logs/runthis.log;
	export NODE_PATH="/usr/local/lib/node_modules";
	
	
	cd ~;
	git clone https://github.com/c9/core.git c9sdk | tee -a "$SCRIPTPATH"/logs/runthis.log;
	cd c9sdk;
	sudo scripts/install-sdk.sh | tee -a "$SCRIPTPATH"/logs/runthis.log;

	
	
	log "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	drawIntroScreen
	
	log "";
	log "";
	log "add C9 to start on boot: [NOTE- crontab is user specific, do you need root? [USE ROOT]]";
	log "";
	
	log "sudo su;crontab -e;";
	log "@reboot node /usr/local/c9sdk/server.js -w / -l 0.0.0.0 -p $c9portToUse -a $userToUse:$c9userPass < /dev/null &";
	log "";
	log "";

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
	log "";
	log "";
	log "${green}";
	log "------------------------------------------------"
	log "------------------------------------------------"
	log "-----   ${magenta}Raspberry Pi INSTALLER HELPER${green}   -----"
	log "------------------------------------------------"
	log "------------------------------------------------${resetColor}"
	log ""
	log ""
}






#
#
#
drawOptionsMenu(){
	drawIntroScreen
	
	log "";
	
	log "${red} NOTE - This helper was created to be used on Raspberry pi OS lite 32bit. ${resetColor}"	
	log "${green}";
	
	log "------------------------------------------------"
	log "-----    ${blue}Available Options${green}    -----"
	log "------------------------------------------------"
	log ""
	log ""
	log ""
	log "${resetColor}-------------------";
	log "------ Multi Install ----------------------";
	log "-------------------";
	log ""
	log "${blue} 1 ${green} |${resetColor} Install All"
	log "${blue} 2 ${green} |${resetColor} Install Web Tools [NodeJS,Cloud9 IDE]"
	log "${blue} 3 ${green} |${resetColor} Install Pi GPIO Tools [Argo Fan,OLED Python Libs,Python GPIO Tools]"
	log ""
	log ""
	log ""
	log "${resetColor}-------------------";
	log "------ Individual Install ----------------------";
	log "-------------------";
	log ""
	log "${blue} 11 ${green} |${resetColor} System Update & Install Utils [nano,bc,ufw firewall,fail2ban auto ban,git]"
	log "";
	log "${blue} 12 ${green} |${resetColor} Install NodeJS & Utils"
	log "${blue} 13 ${green} |${resetColor} Cloud9 IDE"
	log "";
	log "${blue} 14 ${green} |${resetColor} Install Argo Case Fan Script"
	log "${blue} 15 ${green} |${resetColor} Install OLED Screen Python Libs"
	log "${blue} 16 ${green} |${resetColor} Install Pi GPIO Python Libs"
	log "";
	log "${resetColor}-------------------";
	log "------ OTHER ----------------------";
	log "-------------------";
	log "";
	log "${blue} 16 ${green} |${resetColor} Add new port to firewall"
	log "${blue} 17 ${green} |${resetColor} Mount external USB & automount it"
	
	log "";
	log "${resetColor}-------------------";
	log "------ ${blue} q ${green} |${red} Quit${resetColor} ------------------";
	log "-------------------";
	log "";


#	log "${blue} X ${green} |${resetColor}"
#	log "${blue} X ${green} |${resetColor}"
#	log "${blue} X ${green} |${resetColor}"
	
	
	
	
	while true; do
		read -p "${yellow}--- Select an option to continue --------------------------------------------${resetColor}" yn
		case $yn in
			"11") 
				exe_11=true;
				exe_actionDone="System Update & Install Utils [nano,bc,ufw firewall,fail2ban auto ban,git]";
				break;;
			"12") 
				exe_12=true;
				exe_actionDone="Install NodeJS & Utils";
				break;;
			"13") 
				exe_13=true;
				exe_actionDone="Cloud9 IDE";
				break;;
			"14") 
				exe_14=true;
				exe_actionDone="Install Argo Case Fan Script";
				break;;
			"15") 
				exe_15=true;
				exe_actionDone="Install OLED Screen Python Libs";
				break;;
			"16") 
				exe_16=true;
				exe_actionDone="Install Pi GPIO Python Libs";
				break;;
			
			
			
			"1") 
				exe_11=true;
				exe_12=true;
				exe_13=true;
				exe_14=true;
				exe_15=true;
				exe_16=true;
				exe_actionDone="Install All";
				break;;
			"2") 
				exe_12=true;
				exe_13=true;
				exe_actionDone="Install Web Tools [NodeJS,Cloud9 IDE]";
				break;;
			"3") 
				exe_14=true;
				exe_15=true;
				exe_16=true;
				exe_actionDone="Install Pi GPIO Tools [Argo Fan,OLED Python Libs,Python GPIO Tools]";
				break;;
			
			
			[qQquit]* ) exit;;

			* ) log "Please answer a number [1-7].";;
		esac
	done
	
}






#
#
#
#
drawSummary() {
	drawIntroScreen

	log "${green}------------------------------------------------"
	log "------------------------------------------------"
	log "-------------       ${red}SUMMARY${green}      -------------"
	log "------------------------------------------------"
	drawTimeElapsed
	log "------------------------------------------------${resetColor}"
	log ""
	log "${blue}";
	log "------------------------------------------------"
	log "";
	log "${red}Action Done             ${blue}|${resetColor} ${exe_actionDone}";
	log "";
	
	


	
	log "${blue}";
	log "------------------------------------------------${resetColor}"
	log "";
}







#
#
#
#
#
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
    
	log "${blue}------------------------------------------------${resetColor}"
	log "${red}------------------------------------------------${resetColor}"
	log "---------------- Time Lapsed ${min}m & ${secs}s ---------------"
	log "${red}------------------------------------------------${resetColor}"
	log "${blue}------------------------------------------------${resetColor}"
}





#
#	NOTE THE MARKER IS HARD CODED IDK HOW TO USE A VARIABLE
#
loadConfig() {
	CONTENT=$(tac "$SCRIPTPATH/logs/progress.log" | awk '!flag; /xxxxxxxxxx/{flag = 1};' | tac);


	for line in ${CONTENT//;/ }
	do
		if [ "$line" != "xxxxxxxxxx"]; then

			IFS=', ' read -r -a configVar <<< "$line"

			echo "variable ${configVar[0]} with value ${configVar[1]}"
		fi
	done


}



#
# DEBUG
#
# sudo rm runthis.sh;sudo curl https://raw.githubusercontent.com/travisscottwilder/pi-installer/main/runthis.sh > runthis.sh;sudo chmod +x runthis.sh;sudo ./runthis.sh
#
###########################################
########################################################################
########################################################################
######################################################################## START LOGIC #####
########################################################################
########################################################################
###########################################


#check if there is progress to load
loadConfig;

save $log_marker; #start marker



if [ "$askForOptions" == true ]; then
	drawOptionsMenu;

	#save settings picked
	save "exe_11=$exe_11;";
	save "exe_12=$exe_12;";
	save "exe_13=$exe_13;";
	save "exe_14=$exe_14;";
	save "exe_15=$exe_15;";
	save "exe_16=$exe_16;";
fi



log "";
log "";


if [ "$exe_six" = true ]; then
	while true; do
		read -p "${yellow}--- What mode of the OLED install would you like to do? [a/b/c] --------------------------------------------${resetColor}" yn
		case $yn in
			[aA]* )  exe_nodeA=true;
				break;;
			[bB]* ) exe_nodeB=true;
				break;;
			[cC]* ) exe_nodeC=true;
				break;;
			* ) log "Please answer [y/n].";;
		esac
	done
fi


if [ "$exe_13" = true ]; then
	log "";
	log "";
	log "${yellow}--- Enter in the name of the user to create for C9 --------------------------------------------${resetColor}"
	log "";
	read userToUse
	
	log "";
	log "";
	log "${yellow}--- Enter in the password for ${red}C9${yellow} user [$userToUse] about to be created in order to access IDE --------------------------------------------${resetColor}"
	read c9userPass
fi







if [ "$exe_11" = true ]; then
	freshInstallWithUtils
fi


if [ "$exe_12" = true ]; then
	installNodeJS
fi



if [ "$exe_13" = true ]; then
	installC9
fi


if [ "$exe_14" = true ]; then
	installARGOFanScript
fi


if [ "$exe_15" = true ]; then
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


if [ "$exe_16" = true ]; then
	installGPIOPythonLibs
fi




drawSummary

save $log_marker; #end markers