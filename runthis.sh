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
log_marker="xxxxxBREAKxxxxx"; #NOTE also hard coded in a couple commands below
lastProgress='NA';
userSelectedOption=false;



# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")

highestLevelCompleted=0;
highestSubLvlCompleted=0;





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
	
	#install bc common tools
	sudo apt-get install bc | tee -a "$SCRIPTPATH"/logs/runthis.log;

	drawTimeElapsed
	
	sudo apt-get upgrade -y | tee -a "$SCRIPTPATH"/logs/runthis.log;
	
	drawTimeElapsed
	
	sudo apt-get clean | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo apt full-upgrade -y | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo apt-get clean | tee -a "$SCRIPTPATH"/logs/runthis.log;
	
	
	
	#install nano
	sudo apt-get install nano | tee -a "$SCRIPTPATH"/logs/runthis.log;
	
	
	
	
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
	save "xprogressx=11.done;";
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
	save "xprogressx=15.3;";
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
	sudo rm raspi-blinka.py;
	#wget https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/raspi-blinka.py;
	wget https://raw.githubusercontent.com/travisscottwilder/helperNgin-pi/main/lib/raspi-blinka.py;
	sudo python3 raspi-blinka.py | tee -a "$SCRIPTPATH"/logs/runthis.log;
	
	sudo rm raspi-blinka.py;

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
	save "xprogressx=15.6;";
	sudo reboot now | tee -a "$SCRIPTPATH"/logs/runthis.log;
}





#
#
#
#
installC9() {
	log "${blue}--- Install Cloud 9 web IDE --------------------------------------------${resetColor}"
	
	sudo apt-get install -y python2 | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo npm install -g --save optimist | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo ufw allow ${c9portToUse} | tee -a "$SCRIPTPATH"/logs/runthis.log;
	
	cd ~;
	wget http://nodejs.org/dist/v0.10.28/node-v0.10.28-linux-arm-pi.tar.gz | tee -a "$SCRIPTPATH"/logs/runthis.log;
	cd /usr/local;

	tar -xzf ~/node-v0.10.28-linux-arm-pi.tar.gz --strip=1 | tee -a "$SCRIPTPATH"/logs/runthis.log;
	export NODE_PATH="/usr/local/lib/node_modules";


	git clone https://github.com/c9/core.git c9sdk | tee -a "$SCRIPTPATH"/logs/runthis.log;
	cd c9sdk;
	sudo scripts/install-sdk.sh | tee -a "$SCRIPTPATH"/logs/runthis.log;

	#load node server now
	node /usr/local/c9sdk/server.js -w / -l 0.0.0.0 -p $c9portToUse -a $userToUse:$c9userPass


	#remove from cron (just incase it is already there, and then add it [so we don't double add])
	crontab -u root -l | grep -v 'node /usr/local/c9sdk/server.js'  | crontab -u root -
	(crontab -u root -l ; echo "@reboot /usr/local/bin/node /usr/local/c9sdk/server.js -w / -l 0.0.0.0 -p $c9portToUse -a $userToUse:$c9userPass >> $SCRIPTPATH/logs/c9server.log 2>&1") | crontab -u root -
	

	log "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	drawIntroScreen
	
	log "";
	log "";
	log "add C9 to start on boot: [NOTE- crontab is user specific, do you need root? [USE ROOT]]";
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
# adds this script to the cronjob for root user
addSelfToCron(){ 
	#update system to wait for network before booting, since we will need internet before this script can run
	raspi-config nonint do_boot_wait 0

	(crontab -u root -l ; echo "@reboot cd $SCRIPTPATH && ./runthis.sh") | crontab -u root - 
}

#
# removes this script from the cronjob of the root user
removeSelfFromCron(){ 
	crontab -u root -l | grep -v "cd $SCRIPTPATH && ./runthis.sh"  | crontab -u root - 
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
	log "------ Multi Install ${white}---------------";
	log "-------------------";
	log ""
	log "${blue} 1 ${green} |${resetColor} Install All"
	log "${blue} 2 ${green} |${resetColor} Install Web Tools [NodeJS,Cloud9 IDE]"
	log "${blue} 3 ${green} |${resetColor} Install Pi GPIO Tools [Argo Fan,OLED Python Libs,Python GPIO Tools]"
	log ""
	log ""
	log ""
	log "${resetColor}-------------------";
	log "------ Individual Install ${white}---------------";
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
	log "------ OTHER ${white}---------------";
	log "-------------------";
	log "";
	log "${blue} 16 ${green} |${resetColor} Add new port to firewall"
	log "${blue} 17 ${green} |${resetColor} Mount external USB & automount it"
	
	log "";
	log "${resetColor}-------------------";
	log "${blue} q ${green} |${red} Quit ${white}-----------";
	log "-------------------";
	log "";	
	
	
	
	while true; do
		read -p "${yellow}--- Select an option to continue --------------------------------------------${resetColor}" yn
		userSelectedOption=$yn;
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
				addSelfToCron
				break;;
			
			
			
			"1") 
				exe_11=true;
				exe_12=true;
				exe_13=true;
				exe_14=true;
				exe_15=true;
				exe_16=true;
				exe_actionDone="Install All";
				addSelfToCron
				break;;
			"2") 
				exe_12=true;
				exe_13=true;
				exe_actionDone="Install Web Tools [NodeJS,Cloud9 IDE]";
				addSelfToCron
				break;;
			"3") 
				exe_14=true;
				exe_15=true;
				exe_16=true;
				exe_actionDone="Install Pi GPIO Tools [Argo Fan,OLED Python Libs,Python GPIO Tools]";
				addSelfToCron
				break;;
			
			
			[qQquit]* ) exit;;

			* ) log "Please answer a number [1-7]. || Detected input [$yn]";;
		esac
	done
	

	save "userSelectedOption=$userSelectedOption;";
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
	CONTENT=$(tac "$SCRIPTPATH/logs/progress.log" | awk '!flag; /xxxxxBREAKxxxxx/{flag = 1};' | tac);

	lastLvl=0;

	for line in ${CONTENT//;/ }
	do

		if [ "$line" != "xxxxxBREAKxxxxx" ]; then
			IFS='=' read -r -a configVar <<< "$line"

			if [ "${configVar[0]}" == "xprogressx" ]; then
				IFS='.' read -r -a progressSplit <<< "${configVar[1]}"
				lvl=${progressSplit[0]}
				subLvl=${progressSplit[1]}

				#log "CHECKING CONFIG TDUb -> $lastLvl | $lvl | $subLvl |=| $highestLevelCompleted | $highestSubLvlCompleted";

				#see if our highest level compelted has changed
				if (( $lvl > highestLevelCompleted )); then
					highestLevelCompleted=$lvl;
				fi


				#calculate our sub level which might need resettings if it was previously set as done, or might need setting as done
				if (( $lvl > $lastLvl )); then
					subLvl=0;
					highestSubLvlCompleted=0;
				else
					
					#log "CHECKING $subLvl and $highestSubLvlCompleted"
					
					if [ "$subLvl" == 'done' ]; then
						highestSubLvlCompleted=$subLvl;
					else
						if (( $subLvl > highestSubLvlCompleted )); then
							highestSubLvlCompleted=$subLvl;
						fi
					fi
				fi


				lastLvl=$lvl;
			else
				#log "setting ${configVar[0]}"

				case ${configVar[0]} in
					"exe_11") exe_11="${configVar[1]}" ;;
					"exe_12") exe_12="${configVar[1]}" ;;
					"exe_13") exe_13="${configVar[1]}" ;;
					"exe_14") exe_14="${configVar[1]}" ;;
					"exe_15") exe_15="${configVar[1]}" ;;
					"exe_16") exe_16="${configVar[1]}" ;;

					"userSelectedOption") userSelectedOption="${configVar[1]}" ;;
					"userToUse") userToUse="${configVar[1]}" ;;
					"c9userPass") c9userPass="${configVar[1]}" ;;

					* ) log "did not find ${configVar[0]}" ;;
				esac
			fi
		fi
	done

	#log "config loading -> highest sub level: $highestSubLvlCompleted || $highestLevelCompleted"

	#If your sub level is not done then we failed the install and need to try again, lets subtract one to the highest complete to force it to run again
	if [ $highestSubLvlCompleted != 'done' ]; then
		if (( $highestLevelCompleted > 0)); then
			highestLevelCompleted=$((highestLevelCompleted-1));
		fi
	fi

}



#
# DEBUG
#
# cd ~;sudo chmod 777 helperNgin-pi;sudo chown tdub:tdub;cd helperNgin-pi;sudo rm runthis.sh;sudo curl https://raw.githubusercontent.com/travisscottwilder/pi-installer/main/runthis.sh > runthis.sh;sudo chmod +x runthis.sh;sudo ./runthis.sh
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

#log "highest level about to use is: $highestLevelCompleted"

if (( $highestLevelCompleted == 0 )); then
	save $log_marker; #start marker >> reset the progress if we are selecting a new one

	#remove from CRON just incase
	removeSelfFromCron

	#if this was ran from a cron then do nothing
	
	if [ -t 1 ] ; then 
		log "Live mode";
	else
		save $log_marker;
		#this is being ran in a cron go ahead and exit this
		exit;;
	fi





	#start main script
	drawOptionsMenu;

	#save settings picked
	save "exe_11=$exe_11;";
	save "exe_12=$exe_12;";
	save "exe_13=$exe_13;";
	save "exe_14=$exe_14;";
	save "exe_15=$exe_15;";
	save "exe_16=$exe_16;";


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

		save "userToUse=$userToUse;";
		save "c9userPass=$c9userPass;";
	fi

else
	addSelfToCron;
	log "loaded from config resuming progress with current progress already done of: $highestLevelCompleted";
fi


log "";
log "";


if (( $highestLevelCompleted < 11 || highestLevelCompleted == 0)); then
	if [ "$exe_11" = true ]; then
		save "xprogressx=11.0;";
		freshInstallWithUtils;
		save "xprogressx=11.done;";
	fi
fi


if (( $highestLevelCompleted < 12 || highestLevelCompleted == 0)); then
	if [ "$exe_12" = true ]; then
		save "xprogressx=12.0;";
		installNodeJS;
		save "xprogressx=12.done;";
	fi
fi


if (( $highestLevelCompleted < 13 || highestLevelCompleted == 0)); then
	if [ "$exe_13" = true ]; then
		save "xprogressx=13.0;";
		installC9;
		save "xprogressx=13.done;";
	fi
fi


if (( $highestLevelCompleted < 14 || highestLevelCompleted == 0)); then
	if [ "$exe_14" = true ]; then
		save "xprogressx=14.0";
		installARGOFanScript;
		save "xprogressx=14.done";
	fi
fi


if (( $highestLevelCompleted < 15 || highestLevelCompleted == 0)); then
	if [ "$exe_15" = true ]; then
		if (( $highestSubLvlCompleted < 3 )); then
			save "xprogressx=15.0;";
			installOLEDScreenPythonOne
		elif (( $highestSubLvlCompleted < 6 )); then
			installOLEDScreenPythonTwo
		else
			save "xprogressx=15.done;";
		fi
	fi
fi


if (( $highestLevelCompleted < 16 || highestLevelCompleted == 0)); then
	if [ "$exe_16" = true ]; then
		save "xprogressx=16.0";
		installGPIOPythonLibs;
		save "xprogressx=16.done;";
	fi
fi




drawSummary;

save "Done >> end of file";
log "Done >> end of file";
save "$log_marker";
removeSelfFromCron;