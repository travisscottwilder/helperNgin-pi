#!/bin/bash 
#
#
# The primary purpose of this middle man script is because git does not come installed by default, so this script:
#
#   installs updates
#   installs git
#   clones this full repo into same dir this script is saved to
#   makes runthis.sh executable and then runs it
#
#



# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")



#small upgrade of the system
sudo apt-get update -y;
sudo apt-get install git -y;


#clone the actual repository that has all the files
cd $SCRIPTPATH;
git clone https://github.com/travisscottwilder/helperNgin-pi.git;


#remove itself
sudo rm "$SCRIPT";


#cd into that folder and run the actual pi helper
cd helperNgin-pi;
sudo chmod +x runthis.sh;sudo ./runthis.sh;

