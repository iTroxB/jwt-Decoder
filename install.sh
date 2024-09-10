#!/bin/bash


######################################################
#################### COLOURS EDIT ####################
######################################################
green="\e[0;32m\033[1m"
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
turquoise="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"

sudo chmod +x /opt/jwt-Decoder/jwtDecoder.sh
echo -e "\n${blue}➤${end} ${gray}Execution permissions assigned to jwtDecoder.sh...${end}"
sudo ln -s /opt/jwt-Decoder/jwtDecoder.sh /usr/bin/jwtDecoder
echo -e "\n${blue}➤${end} ${gray}Symbolic link created for jwtDecoder.sh...${end}"

sudo go build -o /opt/jwt-Decoder/go/jwtBruteForce /opt/jwt-Decoder/go/main.go
echo -e "\n${blue}➤${end} ${gray}main.go file compiled into jwtBruteForce file...${end}"
sudo ln -s /opt/jwt-Decoder/go/jwtBruteForce /usr/bin/jwtBruteForce
echo -e "\n${blue}➤${end} ${gray}Symbolic link created for jwtBruteForce...${end}\n"

echo -e "\n${green}[✔]${end} ${gray}Installation and compilation completed...${end}\n"
