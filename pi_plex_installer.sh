#!/bin/bash
# https://tynick.com/blog/09-22-2019/plex-media-server-on-raspberry-pi-4/

# set full path of samba credentials file here.
CREDS_FILE='/home/pi/.smbcredentials'

# get the IP of the Raspberry Pi and remove the trailing space
PI_IP=$(hostname -I | sed 's/[[:blank:]]//')

# gather info from user
read -p "(Example: 192.168.1.186) Enter the IP of your NAS: " NAS_IP
read -p "(Example: /Media/Music) Enter the directory of your NAS share: " NAS_DIR
read -p "(Example: tynick)  Enter the username that has access to that NAS share: " NAS_USER
read -p "(Example: fj893kds92) Enter the password for that user: " NAS_PW

# update package list
sudo apt update -y
# install packages
sudo apt install apt-transport-https -y


# make the credentials file
touch "${CREDS_FILE}"

# populate credentials file
sudo echo -e "username="${NAS_USER}"\npassword="${NAS_PW}"" > "${CREDS_FILE}"

# append line to /etc/fstab
sudo echo "//"${NAS_IP}""${NAS_DIR}" /mnt/Media/ cifs credentials="${CREDS_FILE}" 0 0" | sudo tee -a /etc/fstab

# download plex apt PGP key
curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -

# add plex media server repo to apt sources
echo 'deb https://downloads.plex.tv/repo/deb public main' | sudo tee /etc/apt/sources.list.d/plexmediaserver.list

# update package list again
sudo apt update

# install plex media server
sudo apt install plexmediaserver

# start PMS and enable it to start on boot
sudo systemctl start plexmediaserver
sudo systemctl enable plexmediaserver

echo -e "\n##################\nIf everything went right, you should now be able to point your browser to http://"${PI_IP}":32400/web/index.html and get started with Plex Media Server!\n##################\n"
