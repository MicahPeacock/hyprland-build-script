#!/bin/bash
REALNAME=""
USERNAME=""
PASSWORD=""

useradd -m -G wheel,audio,video,input,storage,power -s /bin/bash -c "$REALNAME" $USERNAME
echo "$USERNAME:$PASSWORD" | chpasswd

mkdir -p /home/$USERNAME
chown $USERNAME:$USERNAME /home/$USERNAME
chmod 700 /home/$USERNAME
