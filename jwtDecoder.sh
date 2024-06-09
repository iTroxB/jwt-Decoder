#!/bin/bash
# Author: iTrox

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

###################################################
#################### FUNCTIONS ####################
###################################################

# Bye Ctrl+C
function ctrl_c(){
    echo -e "\n\n ${red}[!] Exit...${end}\n"
    tput cnorm && exit 1
}
trap ctrl_c INT

# Banner
print_banner() {
    echo;
    echo -e " ${yellow}        ___       ________   ____                      __ ${end}"
    echo -e " ${yellow}       / / |     / /_  __/  / __ \\___  _________  ____/ /__  _____ ${end}"
	echo -e " ${yellow}  __  / /| | /| / / / /    / / / / _ \\/ ___/ __ \\/ __  / _ \\/ ___/ ${end}"
	echo -e " ${yellow} / /_/ / | |/ |/ / / /    / /_/ /  __/ /__/ /_/ / /_/ /  __/ / ${end}"
	echo -e " ${yellow} \____/  |__/|__/ /_/    /_____/\\___/\\___/\\____/\\__,_/\\___/_/ ${end}\n\n"
	echo -e "  ${turquoise}JSON Web Token decoder ${end}"
	echo -e "  ${turquoise}Version 1.0${end}"
    echo -e "  ${blue}Made by iTrox${end}\n"
	echo -e "  ${turquoise}jwtDecoder [-h] or [--help] to view help menu${end}\n"
}

# Help menu
help_menu() {
    echo -e " ${yellow}Usage: $0 -t <token> \n${end}"
	echo -e " ${yellow}Menu options:${end}"
    echo -e " 	${turquoise}-t <token>${end}, ${gray}JWT token to decode${end}"
    echo -e " 	${turquoise}-h${end}, ${gray}Show help menu${end}\n"
}

# URL-safe base64 decode
url_safe_base64_decode() {
    local input=$1
    local padding=$(( (4 - ${#input} % 4) % 4 ))
    input="${input}$(printf '=%.0s' $(seq 1 $padding))"
    echo "$input" | base64 --decode 2>/dev/null
}

# Main function
main() {
    # REDIRECT: HELP MENU
    if [[ "$1" = "-h" || "$1" = "--help" ]]; then
        help_menu
        exit 0
    fi

    while getopts ":t:h" opt; do
        case ${opt} in
            t )
                token=$OPTARG
            ;;
            h )
                help_menu
                exit 0
            ;;
            \? )
                echo -e "\n ${gray}Invalid option:${end} -$OPTARG\n" 1>&2
                exit 1
            ;;
            : )
                echo -e "\n ${gray}Option requires an argument:${end} -$OPTARG\n" 1>&2
                exit 1
                ;;
        esac
    done
    shift $((OPTIND -1))

    if [ -z "$token" ]; then
        echo -e "\n ${red}[!] Error:${end} ${gray}JWT token is required${end}\n" 1>&2
        exit 1
    fi

    IFS='.' read -r header payload signature <<< "$token"

    header_decoded=$(url_safe_base64_decode "$header")
    payload_decoded=$(url_safe_base64_decode "$payload")

    echo -e "\n${gray}--------------------------------------------------${end}"
    echo -e "${red}Header:${end}"
    echo -e "$header_decoded" | jq .
    echo -e "${gray}--------------------------------------------------${end}"
    echo -e "${blue}Payload:${end}"
    echo -e "$payload_decoded" | jq .
    echo -e "${gray}--------------------------------------------------${end}"
    echo -e "${yellow}Signature:${end}"
    echo -e "$signature"
    echo -e "${gray}--------------------------------------------------${end}\n"
}


####################################################
#################### RUN SCRIPT ####################
####################################################
clear
print_banner
main "$@"
