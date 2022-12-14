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
c9portToUse=9191;
log_marker="xxxxxBREAKxxxxx"; #NOTE also hard coded in a couple commands below
lastProgress='NA';
userSelectedOption=false;

usbMountName=false;
usbMountType=false;
usbMountUUID=false; #this is actually PARTUUID
usbMountFolder=false;


SCRIPT=$(readlink -f "$0") # Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPTPATH=$(dirname "$SCRIPT") # Absolute path this script is in, thus /home/user/bin

highestLevelCompleted=0;
highestSubLvlCompleted=0;






function check_online(){ netcat -z -w 5 8.8.8.8 53 && echo 1 || echo 0; }
function check_onlineTwo(){ netcat -z -w 5 raspbian.raspberrypi.org 80 && echo 1 || echo 0; }


#
#	echos to the user and logs inside logs/runthis.log
#
log(){ echo $1 | tee -a "$SCRIPTPATH"/logs/runthis.log; }

#
# saves progress into logs/progress.log
#
save(){ echo $1 >> "$SCRIPTPATH"/logs/progress.log; }




#if this is ran from a cron then we want to sleep and make sure we have internet
if [ -t 1 ] ; then 
	log "Live mode";
else
	
	log "Crontab mode";

	sleep 24;

	# Initial check to see if we are online
	IS_ONLINE=check_online
	# How many times we should check if we're online - this prevents infinite looping
	MAX_CHECKS=5
	# Initial starting value for checks
	CHECKS=0

	log "Checking internet 1";

	# Loop while we're not online.
	while [ $IS_ONLINE -eq 0 ]; do
		# We're offline. Sleep for a bit, then check again

		log "No internet from google, lets sleep";

		sleep 10;
		IS_ONLINE=check_online

		CHECKS=$[ $CHECKS + 1 ]
		if [ $CHECKS -gt $MAX_CHECKS ]; then
			log "MAX CHECKS 1.";
			break
		fi
	done

	sleep 1;
	log "Checking internet 2";

	# Initial check to see if we are online
	IS_ONLINE=check_onlineTwo
	#reset checks
	CHECKS=0;
	# Loop while we're not online.
	while [ $IS_ONLINE -eq 0 ]; do
		# We're offline. Sleep for a bit, then check again

		log "No internet from raspbian.raspberrypi.org, lets sleep";

		sleep 10;
		IS_ONLINE=check_onlineTwo;

		CHECKS=$[ $CHECKS + 1 ]
		if [ $CHECKS -gt $MAX_CHECKS ]; then
			log "MAX CHECKS 2.";
			break
		fi
	done

	#final sleep of 5 before we leave
	sleep 5;

	if [ $IS_ONLINE -eq 0 ]; then
		# We never were able to get online. Kill script.
		exit 1
	fi

fi




















#
#	primarily updates and upgrades the system as well as installs comvience of life items like bc, firewall, & autoban
#
# installs ufw and whitelists ports: 22,80,443
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
	
	#install usbmount to auto mount usbs that get plugged in || /etc/usbmount/usbmount.conf
	sudo apt-get install -y usbmount | tee -a "$SCRIPTPATH"/logs/runthis.log;
	
	
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
	log "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	drawTimeElapsed
	log "rebooting";
	log "rebooting";
	log "rebooting";
	log "";
	
	save "xprogressx=11.done;";
	sudo reboot now | tee -a "$SCRIPTPATH"/logs/runthis.log;
}





#
#	installs nodejs and the rpio modules for GPIO logic
#
installNodeJS() {
	log "";
	log "${blue}--- Install NodeJS --------------------------------------------${resetColor}"

	sudo apt-get install -y nodejs | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo apt-get install -y python3-pip | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo pip3 install --upgrade setuptools | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo apt-get install -y npm | tee -a "$SCRIPTPATH"/logs/runthis.log;

	sudo npm install -g rpio --save | tee -a "$SCRIPTPATH"/logs/runthis.log;

	log "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	log "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	log "";
	drawTimeElapsed
	log "";
	
}



#
# installs argon bash script and runs it for the fan script
#
installARGOFanScript() {
	log "";
	log "${blue}--- Install ARGO Case Fan Script --------------------------------------------${resetColor}"

	drawTimeElapsed
	
	curl https://download.argon40.com/argon1.sh | bash 
	
	drawTimeElapsed

	log "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	log "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	drawTimeElapsed
	log "";
}



#
# install python libraries for GPIO interation 
#
installGPIOPythonLibs() {
	log "";
	log "${blue}--- Install GPIO Python Libs --------------------------------------------${resetColor}"

	sudo npm install -g rpio --save | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo npm install -g rpio | tee -a "$SCRIPTPATH"/logs/runthis.log;
	drawTimeElapsed
	
	log "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	log "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	log "";
	drawTimeElapsed
	log "";

	
}



#
# Installs Python libraries for OLED screen interaction -> this is step 1 (A) out of 2
#
installOLEDScreenPythonOne() {
	log "";
	log "${blue}--- Install OLED Screen Python Scripts & Libs ONE [A]--------------------------------------------${resetColor}"


	sudo mkdir /fonts;
	sudo cp "$SCRIPTPATH"/lib/fonts/* /fonts/;
	sudo chown 777 /fonts -Rf;

	cd ~;
	sudo apt-get install -y python3-pip | tee -a "$SCRIPTPATH"/logs/runthis.log;
	sudo pip3 install --upgrade adafruit-python-shell | tee -a "$SCRIPTPATH"/logs/runthis.log
	
	log "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	log "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	drawIntroScreen
	
	log "rebooting";
	log "rebooting";
	log "";
	save "xprogressx=15.3;";
	
	#sudo reboot now | tee -a "$SCRIPTPATH"/logs/runthis.log;
	
	installOLEDScreenPythonTwo;
}



#
# Installs Python libraries for OLED screen interaction -> this is step 2 (B) out of 2
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
	log "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	drawIntroScreen
	
	log "rebooting";
	log "rebooting";
	log "rebooting";
	log "";
	save "xprogressx=15.6;";
	
	save "xprogressx=15.done;";
	sudo reboot now | tee -a "$SCRIPTPATH"/logs/runthis.log;
}





#
# installs cloud9 web IDE on the port specified. Also adds the server.js script to run on boot for the root user in the crontab
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


	log "";
	log "running c9 node server so it works right now";
	log "";

	#load node server now
	node /usr/local/c9sdk/server.js -w / -l 0.0.0.0 -p $c9portToUse -a $userToUse:$c9userPass > stdout.txt 2> stderr.txt &
	

	log "";
	log "setting c9 to set on boot";
	log "";

	#remove from cron (just incase it is already there, and then add it [so we don't double add])
	crontab -u root -l | grep -v 'node /usr/local/c9sdk/server.js'  | crontab -u root -
	(crontab -u root -l ; echo "@reboot /usr/local/bin/node /usr/local/c9sdk/server.js -w / -l 0.0.0.0 -p $c9portToUse -a $userToUse:$c9userPass >> $SCRIPTPATH/logs/c9server.log 2>&1") | crontab -u root -
	

	log "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	log "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
	drawIntroScreen
	
	log "";
}





#
# Splash intro screen used between functions as a break up
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
#
addSelfToCron(){ 
	#update system to wait for network before booting, since we will need internet before this script can run
	sudo raspi-config nonint do_boot_wait 0;

	#to attempt to avoid double adding we will remove before we add
	removeSelfFromCron;

	(crontab -u root -l ; echo "@reboot cd $SCRIPTPATH && ./runthis.sh") | crontab -u root - 
}

#
# removes this script from the cronjob of the root user
#
removeSelfFromCron(){ 
	crontab -u root -l | grep -v "cd $SCRIPTPATH && ./runthis.sh"  | crontab -u root - 
}



#
# Main function logic to start everything off, this asks for input and sets what functions should run
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
	log "${blue} 3 ${green} |${resetColor} Install Pi GPIO Tools [Argon Case,OLED Python Libs,Python GPIO Tools]"
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
	log "${blue} 14 ${green} |${resetColor} Install Argon Case Utils [case fan script & auto mount usb]"
	log "${blue} 15 ${green} |${resetColor} Install OLED Screen Python Libs"
	log "${blue} 16 ${green} |${resetColor} Install Pi GPIO Python Libs"
	log "";
	log "${resetColor}-------------------";
	log "------ OTHER ${white}---------------";
	log "-------------------";
	log "";
	log "${blue} 17 ${green} |${resetColor} Add new port to firewall"
	log "${blue} 18 ${green} |${resetColor} Mount external USB & automount it"
	log "${blue} 19 ${green} |${resetColor} Add script to start on boot"
	
	log "";
	log "${resetColor}-------------------";
	log "${blue} q ${green} |${red} Quit ${white}-----------";
	log "-------------------";
	log "";	
	
	
	
	while true; do
		read -p "${yellow}--- Select an option to continue --------------------------------------------${resetColor}" yn
		userSelectedOption=$yn;
		log "user selected: $yn"
		
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
				exe_18=true;
				exe_actionDone="Install Argo Case Fan Script,mount external hard drive & add it to automount on boot";
				break;;
			"15") 
				exe_15=true;
				exe_actionDone="Install OLED Screen Python Libs";
				addSelfToCron
				break;;
			"16") 
				exe_16=true;
				exe_actionDone="Install Pi GPIO Python Libs";
				break;;
			"17") 
				exe_17=true;
				exe_actionDone="Add new port to firewall";
				break;;
			"18") 
				exe_18=true;
				exe_actionDone="mount external hard drive & add it to automount on boot";
				break;;
			"19") 
				exe_19=true;
				exe_actionDone="Add script to start on boot";
				break;;
			
			
			
			"1") 
				exe_11=true;
				exe_12=true;
				exe_13=true;
				exe_14=true;
				exe_15=true;
				exe_16=true;
				exe_18=true;
				exe_actionDone="Install All";
				addSelfToCron
				
				usbMountFolder="/mnt/data";
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
				exe_18=true;
				exe_actionDone="Install Pi GPIO Tools [Argon Case,OLED Python Libs,Python GPIO Tools]";
				addSelfToCron
				
				usbMountFolder="/mnt/data";
				break;;
			
			
			[qQquit]* ) exit;;

			* ) log "Please answer a number from the menu presented. || Detected input [$yn]";;
		esac
	done
	

	save "userSelectedOption=$userSelectedOption;";
}






#
# end of script summary message
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
# calculates how much time has elapsed and then prints it out
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
#	loads the current progress from SCRIPT_DIR/logs/progress.log so the system can resume progress
#
#	NOTE THE MARKER of "xxxxxBREAKxxxxx" IS HARD CODED IDK HOW TO USE A VARIABLE
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

				#debug log
				log "";log "CHECKING CONFIG TDUb -> $lastLvl | $lvl | $subLvl |=| $highestLevelCompleted | $highestSubLvlCompleted";log "";

				#see if our highest level completed has changed
				if (( $lvl > highestLevelCompleted )); then
					highestLevelCompleted=$lvl;
				fi


				#calculate our sub level which might need resettings if it was previously set as done, or might need setting as done
				if (($lastLvl != 0 && $lvl > $lastLvl)); then
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
					"usbMountName") usbMountName="${configVar[1]}" ;;
					"usbMountType") usbMountType="${configVar[1]}" ;;
					"usbMountUUID") usbMountUUID="${configVar[1]}" ;;
					"usbMountFolder") usbMountFolder="${configVar[1]}" ;;

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
# asks and whitelists a new port through ufw firewall
#
addNewPortToFireWall(){
	while true; do
		read -p "${yellow}--- Please enter in your port or [q] to quit --------------------------------------------${resetColor}" yn
		case $yn in
			[qQquit]* ) return;;
			
			*)	sudo ufw allow $yn | tee -a "$SCRIPTPATH"/logs/runthis.log;
				log "port $yn added to ufw firewall";
			;;
		esac;
	done;
}



#
# configure new mount point for a USB & add it to auto start via /etc/fstab
#
configureNmountUSB(){

	if [ $usbMountName != false ]; then
		
		sudo mkdir $usbMountFolder;
		sudo mount /dev/$usbMountName $usbMountFolder;
		sudo chmod 775 $usbMountFolder;
		sudo chmod 775 $usbMountFolder -Rf;
		
		log "Created $usbMountFolder and mounted /dev/$usbMountName";
		
		valueToEcho=false;
		
		case $usbMountType in
			"q") log "ok, nevermind" ;;
			"Q") log "ok, nevermind" ;;
			"quit") log "ok, nevermind" ;;
			
			"vfat") valueToEcho="PARTUUID=$usbMountUUID $usbMountFolder vfat defauls,auto,users,rw,nofail,umask=000 0 0" ;;
			"ntfs") valueToEcho="PARTUUID=$usbMountUUID $usbMountFolder ntfs defauls,auto,users,rw,nofail,umask=000 0 0" ;;
			"exfat") valueToEcho="PARTUUID=$usbMountUUID $usbMountFolder exfat defauls,auto,users,rw,nofail 0 0" ;;
			"ext4") valueToEcho="PARTUUID=$usbMountUUID $usbMountFolder ext4 defauls,auto,users,rw,nofail 0 0" ;;
			
			
			*) log "unknown file type: $usbMountType drive not added to auto mount" ;;
		esac
		
		if [ "$valueToEcho" != false ]; then
			
			echo $valueToEcho >> /etc/fstab;
			log "Added to /etc/fstab -> $valueToEcho";
		fi
		
	else
		log "Do not have a USB to mount";
	fi
	
}




#
# configures and sets a script to run on boot via the crontab. System asks what the script is and type of execution
#
runScriptOnBoot(){
	
	log "";
	log "${resetColor} -- ADDING TO CRONTAB --";
	log "";
	log "${yellow}-------------------------------------${resetColor}"
	log "${yellow}-------------------------------------${resetColor}"
	log "${blue}------------------ EXAMPLES -------------------${resetColor}" 
	log "";
	log "${green}${SCRIPTPATH}/OLED/SSD1306/128x32/stats.py${resetColor}"
	log "";
	log "${green}${SCRIPTPATH}/OLED/SSD1306/128x64/stats.py${resetColor}"
	log "${green}${SCRIPTPATH}/OLED/SSD1306/128x64/psutilstats.py${resetColor}"
	log "";
	log "${green}/usr/local/c9sdk/server.js -w / -l 0.0.0.0 -p 9191 -a user:pass${resetColor}"
	log "";
	log "${yellow}-------------------------------------${resetColor}"
	log "${yellow}-------------------------------------${resetColor}"
	log ""
	log "";
	log "${yellow}---What script would you like ran? (also add any params) ----------------------${resetColor}"
	log ""
	log "${blue} NOTE - please use the full path starting at system root dir ${resetColor}";
	log ""
	read bootScript
	
	log "";
	log "";
	log "GOT IT - using script & params: $bootScript";
	log "";
	
	log "${yellow}-------------------------------------${resetColor}"
	log "${yellow}-------------------------------------${resetColor}"
	log "${blue}------------------ EXAMPLES -------------------${resetColor}" 
	log "${green}root"
	
	#print out all "normal" users (ignores system users)
	eval getent passwd {$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)..$(awk '/^UID_MAX/ {print $2}' /etc/login.defs)} | cut -d: -f1;

	log "${yellow}-------------------------------------${resetColor}"
	log "${yellow}-------------------------------------${resetColor}"
	log ""
	log "";
	log "${yellow}--- Under what user's crontab should this script be added to? ----------------------${resetColor}"
	log ""
	log ""
	read bootUser

	log "";
	log "";
	log "SAWWEEEEEET - Will use the crontab for user: $bootUser";
	log "";
	
	log "${yellow}-------------------------------------${resetColor}"
	log "${yellow}-------------------------------------${resetColor}"
	log "${blue}------------------ EXAMPLES -------------------${resetColor}" 
	log "${green}python${resetColor}"
	log "${green}python3${resetColor}"
	log "${green}node${resetColor}"
	log "${green}sh${resetColor}"
	log "${green}bash${resetColor}"
	log "${yellow}-------------------------------------${resetColor}"
	log "${yellow}-------------------------------------${resetColor}"
	log "";
	log "";
	log "${yellow}--- How should we execute this script? ----------------------${resetColor}"
	log ""
	log ""
	read bootHow;

	bootHowPath='';

	case $bootHow in
		
		"python") bootHowPath="/bin/python2" ;;
		"python3") bootHowPath="/bin/python3" ;;
		"node") bootHowPath="/usr/local/bin/node" ;;
		"sh") bootHowPath="/bin/sh" ;;
		"bash") bootHowPath="/bin/bash" ;;
		*) bootHowPath="$bootHow" ;; #unknown so use whatever they passed in
	esac
	
	#figure out the command for the script, via
	
	
	bootScriptPath=$(dirname "$bootScript");
	bootScriptFile=$(basename "$bootScript");
	logFile="${SCRIPTPATH}/logs/cron_${bootUser}_${bootScriptFile}.log";
	
	
	touch $logFile; #make sure log file exists
	sudo chmod 777 $logFile;
	cronTxt="@reboot cd ${bootScriptPath} && ${bootHowPath} $bootScriptFile >> ${logFile} 2>&1";
	
	
	#REMOVE FROM CRONTAB [we do this as an attempt to not duplicate entries if it already exists]
	crontab -u $bootUser -l | grep -v "$cronTxt"  | crontab -u $bootUser - 
	
	#add to crontab
	(crontab -u $bootUser -l ; echo "$cronTxt") | crontab -u $bootUser - 

	log "";
	log "";
	log "Created new crontab: $cronTxt | on user: $bootUser";
	log "";
}
















###########################################
########################################################################
########################################################################
######################################################################## START LOGIC #####
########################################################################
########################################################################
###########################################


#check if there is progress to load
loadConfig;


#is this an initial run?
if (( $highestLevelCompleted == 0 )); then
	save $log_marker; #start marker >> reset the progress if we are selecting a new one

	#remove from CRON just incase
	removeSelfFromCron

	#if this was ran from a cron then do nothing
	
	if [ -t 1 ] ; then 
		log "Live mode 2";
	else
		save $log_marker;
		#this is being ran in a cron go ahead and exit this
		exit;
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
		
		log "user for C9: $userToUse"
		
		log "";
		log "";
		log "${yellow}--- Enter in the password for ${red}C9${yellow} user [$userToUse] about to be created in order to access IDE --------------------------------------------${resetColor}"
		read c9userPass

		save "userToUse=$userToUse;";
		save "c9userPass=$c9userPass;";
	fi



	if [ "$exe_18" = true ]; then
		
		lsblk
		
		log "";
		log "";
		log "${yellow}--- Enter in the name of the USB device to auto mount. Use the size as reference --------------------------------------------${resetColor}"
		log "";
		log "";
		log "${yellow}--- Expecting a name like sda2 --------------------------------------------${resetColor}"
		log "";
		read usbMountName
		
		log ""
		log "PERFECT!";
		log "";
		log "";
		
		blkid
		
		log "";
		log "";
		log "${yellow}--- Now what is the file type for drive ${usbMountName}? Look under 'type' --------------------------------------------${resetColor}"
		log "";
		log "";
		log "${yellow}--- Expecting a name like ext4 --------------------------------------------${resetColor}"
		log "";
		read usbMountType
		
		log "";
		log "PERFECT!";
		log "";
		log "";
		
		
		blkid
		
		log "";
		log "";
		log "${yellow}--- Now what is the PARTUUID of ${usbMountName}? --------------------------------------------${resetColor}"
		log "";
		log "";
		log "${yellow}--- Expecting a name like ddbefb06-02 --------------------------------------------${resetColor}"
		log "";
		read usbMountUUID
		
		
		if [ "$usbMountFolder" == false ]; then
			log "";
			log "";
			log "${yellow}--- What folder are we mounting this USB to?  --------------------------------------------${resetColor}"
			log "";
			read usbMountFolder
		
		fi
		
		
		
		log "Planning to mount: $usbMountName to $usbMountFolder of type [$usbMountType] and UUID [$usbMountUUID]"
		
		
		save "usbMountName=$usbMountName;";
		save "usbMountType=$usbMountType;";
		save "usbMountUUID=$usbMountUUID;";
		save "usbMountFolder=$usbMountFolder;";
	fi


#ELSE no this is presuming progress
else
	addSelfToCron;
	log "";
	log "--------";
	log "loaded from config resuming progress with current progress already done of: $highestLevelCompleted | SUBlvl: $highestSubLvlCompleted";
	log "--------";
	log "";
fi







#GOGOGOGOGOGOGO
#GOGOGOGOGOGOGO



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
		log "PYTHON OLED yes 2 this is going to happen: [$highestSubLvlCompleted]";
		if (( $highestSubLvlCompleted < 3 )); then
			log ".......... yup it is going to do python 1"
			save "xprogressx=15.0;";
			installOLEDScreenPythonOne
		elif (( $highestSubLvlCompleted < 6 )); then
			log "what? trying to do python 2 my guy";
			installOLEDScreenPythonTwo
		else
			log "DONEEEEEEEEEEEEEE";
			save "xprogressx=15.done;";
		fi
	fi
fi


if (( $highestLevelCompleted < 16 || highestLevelCompleted == 0)); then
	if [ "$exe_16" = true ]; then
		save "xprogressx=16.0;";
		installGPIOPythonLibs;
		save "xprogressx=16.done;";
	fi
fi


if (( $highestLevelCompleted < 17 || highestLevelCompleted == 0)); then
	if [ "$exe_17" = true ]; then
		save "xprogressx=17.0;";
		addNewPortToFireWall;
		save "xprogressx=17.done;";
	fi
fi


if (( $highestLevelCompleted < 18 || highestLevelCompleted == 0)); then
	if [ "$exe_18" = true ]; then
		save "xprogressx=18.0;";
		configureNmountUSB;
		save "xprogressx=18.done;";
	fi
fi


if (( $highestLevelCompleted < 19 || highestLevelCompleted == 0)); then
	if [ "$exe_19" = true ]; then
		save "xprogressx=19.0;";
		runScriptOnBoot;
		save "xprogressx=19.done;";
	fi
fi



drawSummary;

save "Done >> end of file";
log "Done >> end of file";
save "$log_marker";
removeSelfFromCron;
