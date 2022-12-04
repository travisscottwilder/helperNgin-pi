#!/bin/bash 
#
#	if you get special character error:
#		NOTEPAD++: 	Edit --> EOL Conversion --> UNIX/OSX Format
#		LINUX:		sed -i -e 's/\r$//' scriptname.sh
#

STARTTIME=$(date +%s)

red=$'\e[01;31m'
green=$'\e[01;32m'
yellow=$'\e[01;33m'
blue=$'\e[01;34m'
magenta=$'\e[01;35m'
resetColor=$'\e[0m'

exe_twoFresh=false;
exe_threeInstallNode=false;
exe_fourArgo=false;
exe_fiveGPIOpython=false;
exe_sixoLED=false;
exe_sevenC9=false;

exe_actionDone="NA";

vhosts_added="";

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

	rootfs-expand;
	
	drawTimeElapsed
	
	drawTimeElapsed
	
	
	echo "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
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

	
	
	drawTimeElapsed
	
	drawTimeElapsed
	
	
	echo "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
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

	
	drawTimeElapsed
	
	drawTimeElapsed
	
	
	echo "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
}



#
#
#
#
#
#
installOLEDScreenPython() {
	echo "";
	echo "${blue}--- Install OLED Screen Python Scripts & Libs --------------------------------------------${resetColor}"


	
	drawTimeElapsed
	
	drawTimeElapsed
	
	
	echo "${blue}----------------------------------------------------------------------------------------------------------${resetColor}"
}





#
#
#
#
installC9() {
	
  
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






#
#
#
drawIntroScreen(){
	clear
	echo "";
	echo "";
	echo "${green}";
	echo "------------------------------------------------"
	echo "------------------------------------------------"
	echo "-----   ${magenta}DEV OPS WEB SERVER INSTALLER HELPER${green}   -----"
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
	echo "";
	echo "${blue} q ${green} |${red} Quit${resetColor}"
	
	
	
	
	while true; do
		read -p "${yellow}--- Select an option to continue [1-9] --------------------------------------------${resetColor}" yn
		case $yn in
			[1]* )  
				exe_twoFresh=true;
        exe_threeInstallNode=true;
        exe_fourArgo=true;
        exe_fiveGPIOpython=true;
        exe_sixoLED=true;
        exe_sevenC9=true;
				exe_actionDone="1) Full Install";
				break;;
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



if [ "$exe_twoFresh" = true ]; then
	freshInstall
fi

if [ "$exe_threePHP" = true ]; then
	installReposApachePhp
fi


if [ "$exe_sevenSSHUSER" = true ]; then
	#new ssh user
	creationSSHUser
fi

if [ "$exe_eightC9" = true ]; then
	#install c9 ide
	createInstallC9
fi


if [ "$exe_fiveMYSQL" = true ]; then
	#install mysql + security
	installMySQL
fi

if [ "$exe_sixMYSQLUSER" = true ]; then
	#install mysql user
	installMysqlUser
fi

if [ "$exe_fourVHOST" = true ]; then
	createAllVhostDomains
fi



drawSummary
