#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'

# Font
BOLD='\033[1m'
UNDERLINE='\033[4m'
bold='\033[17m'

# Reset
NC='\033[0m'




#echo "------------------------------------------"
#echo -e  "${BOLD}${RED}Select Options ${NC}"
#echo "------------------------------------------"

echo -e "${CYAN}${BOLD}"
figlet "UNIX  UPDATE"
echo -e "${NC}"

options () {
#echo -e "  ${BOLD}\033[7m 1 \033[0m \t Driver Packages Update"
echo -e ${BOLD}${YELLOW}[1]${NC}'  Driver Packages Update '
echo ' '
echo -e ${BOLD}${YELLOW}[2]${NC} ' Software Installed '
echo ' '
echo -e ${BOLD}${YELLOW}[3]${NC} '  Network Config ' 
echo ' '
echo -e ${BOLD}${YELLOW}[4]${NC} ' Exit '

}

  while true ; do
      options 
      echo ' '
      read -p 'Enter Your Option:' opt
      case $opt in
   #     echo -e "$(PURPLE) System Updating start${NC}"  
      1) echo "Updating repositories..."
        sudo apt update && sudo apt upgrade -y

      echo " Detecting and installing Hardware Drivers (Display & WiFi)..."
      sudo ubuntu-drivers autoinstall

       echo " Installing Audio drivers and Media Codecs..."
       sudo apt install alsa-utils pipewire pipewire-audio-client-libraries ubuntu-restricted-extras -y

       echo " Installing General Linux Firmware..."
      sudo apt install linux-firmware -y

      echo " Installing Wine Package "
      sudo apt install wine -y 
      sudo apt install winetricks -y && winetricks allfonts
      
      echo "Time Setup"
      sudo timedatectl set-timezone Asia/Kolkata
      echo "Mp3,mp4 support"
      sudo apt install ubuntu-restricted-extras -y
      echo " Installing Editor "
      sudo apt install vim -y 
      sudo apt install nano -y
      sudo apt install git - y
      sudo apt update
      echo -e ${BOLD}${PURPLE}${UNDERLINE}" System rebooting"${NC}
      sudo reboot 
      ;;
      2)
     echo "Installing Brave Browser"
      curl -fsS https://dl.brave.com/install.sh | sh
  while true; do
      read -p  "$(echo -e "${RED} If you want Installed Chrome(y/n):${NC}")" confirmation
#      read -p "$(echo -e "${CYAN}Install Chrome (${GREEN}y/n${CYAN}): ${NC}")" confirmation

      if [ -z "$confirmation" ]; then
        echo -e "${UNDERLINE}Select (y/n) dont leave blank:${NC}"
      
      elif [[ "$confirmation" == "y" || "confirmation" == "Y" ]]; then
        echo "Installing Chrome Browser"
break
      elif [[ "$confirmation" == 'n'|| "$confirmation" == 'N' ]]; then 
        echo " Chrome Browser Skipped "
break
      else
        echo " Invalid Option"

      fi
    done 

    echo " Installed VLC Media "
    sudo apt install vlc
    sudo apt install vlc-plugin-access-extra libbluray-bdj libdvd-pkg

    while true; do
      read -p  "$(echo -e "${RED} If you want Install HP-printer driver & scanner(y/n):${NC}")" yeno
      if [ -z "$yeno"]; then
        echo " Choose (y/n) dont leave blank"
      elif [[ "$yeno" == 'y'  || "$yeno" == 'Y' ]]; then
        echo "Installing HPLIP and Scanner utilities..."
        sudo apt install hplip hplip-gui simple-scan sane sane-utils -y
        echo " starting HP setup"
        sudo hp-setup -i
break
      elif [[ "$yeno" == 'n'  || "$yeno" == 'N' ]]; then
        echo " Hp printer Driver-Scanner skipped"
break
      else 
        echo " Inavlid option choose(y/n)"
      fi
    done

    while true; do
           read -p  "$(echo -e "${RED} If you want enable Firewall (y/n):${NC}")" confirm
      if [ -z "$confirm" ]; then
        echo " Choose one of the option (y/n) dont leave blank"
      elif [[ "$confirm"  == 'y' || "$confirm" == 'Y' ]]; then 
        sudo  ufw enable 
break
      elif 
        [[ "$confirm" == 'n'  || "$confirm" == 'N' ]]; then
        echo " Firewall Ignored"
break
      else
          echo " Invalid option " 

  fi
done
;;
# Function: Subnet mask 
3)
  mask_to_cidr() {
    local mask=$1
    local x=${mask//255/8}
    x=${x//248/5}
    x=${x//252/6}
    x=${x//254/7}
    x=${x//240/4}
    x=${x//224/3}
    x=${x//192/2}
    x=${x//128/1}
    x=${x//0/0}
    IFS=.
    local sum=0
    for i in $x; do ((sum+=i)); done
    echo $sum
}

echo -e "${CYAN}--- Network Config with Custom Subnet Mask ---${NC}"

# User Input
read -p "Enter Static IP: " user_ip
read -p "Enter Subnet Mask (e.g., 255.255.255.0): " user_mask
read -p "Enter Gateway: (e.g. 192.168.1.1) " user_gw 
read -p "Enter DNS: " user_dns

# Calculate CIDR
CIDR=$(mask_to_cidr $user_mask)
echo -e "${YELLOW}Detected CIDR: /$CIDR${NC}"

# OS Detection 
if [ -d "/etc/netplan" ]; then
    INTERFACE=$(ip -o link show | awk -F': ' '{print $2}' | grep -v lo | head -n 1)
    
    sudo bash -c "cat <<EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    $INTERFACE:
      dhcp4: no
      addresses: [$user_ip/$CIDR]
      routes:
        - to: default
          via: $user_gw
      nameservers:
        addresses: [$user_dns, 8.8.4.4]
EOF"
    sudo netplan apply

elif command -v nmcli &> /dev/null; then
    CON_NAME=$(nmcli -t -f NAME connection show --active | head -n 1)
    sudo nmcli connection modify "$CON_NAME" ipv4.addresses "$user_ip/$CIDR" ipv4.gateway "$user_gw" ipv4.dns "$user_dns" ipv4.method manual
    sudo nmcli connection up "$CON_NAME"
fi

echo -e "${GREEN}Network Updated with /$CIDR mask!${NC}"

;;
  4) echo -e ${bold}${PURPLE} Have Fun... ${NC}${bold}${PURPLE} !!! ${NC}
    exit 
    
esac
done

 
