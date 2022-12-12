# helperNgin-pi

use this on a fresh install to add to a fresh install then use `sudo ./~/helperNgin-pi/runme.sh` to run


	cd ~;curl https://raw.githubusercontent.com/travisscottwilder/pi-installer/main/deploy-helperNgine-pi.sh > deploy-helperNgine-pi.sh;sudo chmod +x deploy-helperNgine-pi.sh;sudo ./deploy-helperNgine-pi.sh;sudo rm deploy-helperNgine-pi.sh;




.

.



-----------------

--------------

.
.



IF YOU WANT TO INIT GIT REPO AND EDIT



1) move github ssh [id_rsa] into .ssh folder of user (/root/ or /home/pi/)

2) to init for github: `ssh-add ~/.ssh/id_rsa`


-----------------

--------------


github generate ssh key `https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent`
	
`ssh-keygen -t ed25519 -C "your_email@example.com"`


