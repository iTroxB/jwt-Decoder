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
    echo -e "  ${turquoise}Version 3.0${end}"
    echo -e "  ${blue}Made by iTrox${end}\n"
    echo -e "  ${turquoise}jwtDecoder [-h] or [--help] to view help menu${end}\n"
}

# Help menu
help_menu() {
    echo -e " \n${yellow}Usage: $0 -t <token> [-w <wordlist>] \n${end}"
    echo -e " ${yellow}Menu options:${end}"
    echo -e "    ${turquoise}-t <token>${end}, ${gray}JWT token to decode${end}"
    echo -e "    ${turquoise}-w <wordlist>${end}, ${gray}Wordlist file for brute force attack${end}"
    echo -e "    ${turquoise}-h${end}, ${gray}Show help menu${end}\n"
}

# REDIRECT: HELP MENU
if [[ "$1" = "-h" || "$1" = "--help" ]]; then
    help_menu
    exit 0
fi

# URL-safe base64 decode
url_safe_base64_decode() {
    local input=$1
    local padding=$(( (4 - ${#input} % 4) % 4 ))
    input="${input}$(printf '=%.0s' $(seq 1 $padding))"
    echo "$input" | base64 --decode 2>/dev/null
}

# Check token base64 encoded
is_base64() {
    echo "$1" | grep -Eq '^([A-Za-z0-9+/=]{4})*$'
}

# Decode base64 encoded
decode_if_base64() {
    if is_base64 "$1"; then
        echo "$1" | base64 --decode
    else
        echo "$1"
    fi
}

# Brute force JWT signature
brute_force_jwt() {
    local header=$1
    local payload=$2
    local signature=$3
    local wordlist=$4

    if [ ! -f "$wordlist" ]; then
        echo -e "\n ${red}[!] Error:${end} ${gray}Dictionary file not found${end}\n" 1>&2
        exit 1
    fi

    echo -e "\n${blue}➤ Starting brute force attack...${end}"

    while read -r secret; do
        generated_signature=$(echo -n "$header.$payload" | openssl dgst -sha256 -hmac "$secret" -binary | base64 | tr '+/' '-_' | tr -d '=')
        if [ "$generated_signature" == "$signature" ]; then
            echo -e "\n${green}[+] Secret found:${end} ${red}$secret${end}\n"
            return 0
        fi
    done < "$wordlist"

    echo -e "\n${red}[-] Secret not found in wordlist${end}\n"
}

# Main function
main() {
    local dictionary=""

    while getopts ":t:w:h" opt; do
        case ${opt} in
            t )
                token=$OPTARG
            ;;
            w )
                wordlist=$OPTARG
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

    # Decode the token if it is base64 encoded
    if is_base64 "$token"; then
        echo -e "\n${blue}➤ JWT token encoded in Base64. Decoding...${end}"
        decoded_token=$(decode_if_base64 "$token")
        sleep 1
    else
        echo -e "\n${blue}➤ Regular JWT token${end}"
        decoded_token="$token"
    fi

    IFS='.' read -r header payload signature <<< "$decoded_token"

    header_decoded=$(url_safe_base64_decode "$header")
    payload_decoded=$(url_safe_base64_decode "$payload")

    echo -e "\n${gray}--------------------------------------------------${end}"
    echo -e "${red}Header:${end}"
    echo -e "$header_decoded" | jq .
    echo -e "${gray}--------------------------------------------------${end}"
    echo -e "${purple}Payload:${end}"
    echo -e "$payload_decoded" | jq .
    echo -e "${gray}--------------------------------------------------${end}"
    echo -e "${yellow}Signature:${end}"
    echo -e "$signature"
    echo -e "${gray}--------------------------------------------------${end}"

    if [ -n "$wordlist" ]; then
        brute_force_jwt "$header" "$payload" "$signature" "$wordlist"
    fi
}

####################################################
#################### RUN SCRIPT ####################
####################################################
print_banner
main "$@"
