#!/bin/bash

color_cyan='\033[1;36m'
color_reset='\033[0m'

start() {
    clear
    echo -e "${color_cyan}==============================================="
    echo "                Multi-Tools Panel"
    echo "==============================================="
    echo "1 - Check internet connection"
    echo "2 - Clean temporary files"
    echo "3 - Save a file to a USB drive"
    echo "4 - Generate a random password"
    echo "5 - Compress a folder"
    echo "6 - Show CPU / RAM usage"
    echo "7 - Quick restart / shutdown"
    echo "0 - Exit tool"
    echo "==============================================="
    echo -e "${color_reset}"
    read -p "Please choose an option : " choiceinput
    echo ""

    case "$choiceinput" in
        1) choice1 ;;
        2) choice2 ;;
        3) choice3 ;;
        4) choice4 ;;
        5) choice5 ;;
        6) choice6 ;;
        7) choice7 ;;
        0) exit 0 ;;
        *) start ;;
    esac
}

choice1() {
    clear
    echo "A ping test will be performed. Press any key to continue."
    read -n 1 -s -r
    clear
    ping -c 1 www.google.com > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        internetOK
    else
        internetKO
    fi
}

internetOK() {
    fi
}

internetOK() {
    clear
    echo "Internet connection: OK"
    sleep 3
    start
}

internetKO() {
    clear
    echo "No internet connection detected. Please check your network."
    sleep 5
    start
}

choice2() {
    clear
    echo "Cleaning temporary files..."
    rm -rf /tmp/* 2>/dev/null
    rm -rf ~/.local/share/Trash/* 2>/dev/null
    echo "Cleaning completed!"
    read -n 1 -s -r
    start
}

choice3() {
    clear
    USB_NAME="USBDrive"
    read -p "Enter the full path of the file to save: " FILE_SOURCE

    if [ ! -f "$FILE_SOURCE" ]; then
        echo "File not found."
        read -n 1 -s -r
        start
    fi

    USB_DRIVE=$(lsblk -o NAME,LABEL,MOUNTPOINT | grep "$USB_NAME" | awk '{print $NF}')

    if [ -z "$USB_DRIVE" ]; then
        echo "USB drive \"$USB_NAME\" not detected."
        read -n 1 -s -r
        start
    fi

    echo "USB drive detected on $USB_DRIVE"
    echo "Copying file..."
    cp "$FILE_SOURCE" "$USB_DRIVE/"

    if [ $? -eq 0 ]; then
        echo "File successfully saved!"
    else
        echo "Error during file copy."
    fi

    read -n 1 -s -r
    start
}

choice4() {
    clear
    read -p "Enter password length (default 12): " length
    if [ -z "$length" ]; then
        length=12
    fi

    chars='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*'

    password=$(LC_ALL=C tr -dc "$chars" < /dev/urandom | head -c "$length")

    clear
    echo "Generated password:"
    echo "$password"
    read -n 1 -s -r
    start
}

choice5() {
    clear
    read -p "Enter the folder path to compress: " folder
    if [ ! -d "$folder" ]; then
        echo "Folder not found."
        read -n 1 -s -r
        start
    fi

    read -p "Enter output ZIP name (without .zip): " zipname

    zip -r "${zipname}.zip" "$folder" > /dev/null 2>&1

    clear
    echo "Compression completed: ${zipname}.zip"
    read -n 1 -s -r
    start
}

choice6() {
    clear
    echo "CPU and RAM usage:"
    echo "====================="
    echo "CPU Load:"
    top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4 "%"}'
    echo ""
    echo "Memory:"
    free -h | grep -v Swap
    read -n 1 -s -r
    start
}

choice7() {
    clear
    echo "1 - Restart computer"
    echo "2 - Shutdown computer"
    echo "0 - Cancel"
    read -p "Choose an option: " powerChoice

    case "$powerChoice" in
        1) reboot ;;
        2) poweroff ;;
    esac
    start
}

start
