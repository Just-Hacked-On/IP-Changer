#!/bin/bash

# Logging setup
LOG_FILE="/var/log/ip_changer.log"
log() {
    echo "$(date): $1" >> "$LOG_FILE"
    echo -e "\033[32m$1\033[0m"  # Green output for status/logs
}

# Check if root is needed
check_root() {
    if [[ "$UID" -ne 0 ]] && { ! command -v curl &> /dev/null || ! command -v tor &> /dev/null; }; then
        log "Script must be run as root to install packages."
        exit 1
    fi
}

# Install required packages
install_packages() {
    local distro
    distro=$(awk -F= '/^NAME/{print $2}' /etc/os-release 2>/dev/null | tr -d '"')

    log "Detected distribution: $distro"
    if command -v dnf &> /dev/null; then
        dnf install -y curl tor
    elif command -v apt-get &> /dev/null; then
        apt-get update
        apt-get install -y curl tor
    elif command -v pacman &> /dev/null; then
        pacman -S --noconfirm curl tor
    else
        log "Unsupported distribution: $distro. Please install curl and tor manually."
        exit 1
    fi
    log "Packages installed successfully."
}

# Check dependencies
check_dependencies() {
    if ! command -v curl &> /dev/null || ! command -v tor &> /dev/null; then
        log "Installing curl and tor"
        install_packages
    fi
}

# Start Tor service
start_tor() {
    if ! systemctl --quiet is-active tor.service; then
        log "Starting tor service"
        systemctl start tor.service
        if ! systemctl --quiet is-active tor.service; then
            log "Failed to start tor service. Check configuration."
            exit 1
        fi
    fi
}

# Get current IP
get_ip() {
    local url get_ip ip
    url="https://checkip.amazonaws.com"
    TOR_PORT=${TOR_PORT:-9050}
    get_ip=$(curl -s -x socks5h://127.0.0.1:"$TOR_PORT" "$url" 2>/dev/null)
    if [ -z "$get_ip" ]; then
        log "Failed to fetch IP. Check Tor or network."
        exit 1
    fi
    ip=$(echo "$get_ip" | grep -oP '((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)')
    if [ -z "$ip" ]; then
        log "Invalid IP address received."
        exit 1
    fi
    echo "$ip"
}

# Change IP
change_ip() {
    log "Reloading Tor service..."
    systemctl reload tor.service
    sleep 2  # Wait for Tor to establish new circuit
    ip=$(get_ip)
    log "New IP acquired."
    echo -e "\033[31mNew IP address: $ip\033[0m"  # RED output
}

# Main logic
check_root
check_dependencies
start_tor

clear
cat << "EOF"
 ______ _______          ______  __    __  ______  __    __  ______  ________ _______  
|      |       \        /      \|  \  |  \/      \|  \  |  \/      \|        |       \ 
 \$$$$$| $$$$$$$\      |  $$$$$$| $$  | $|  $$$$$$| $$\ | $|  $$$$$$| $$$$$$$| $$$$$$$\
  | $$ | $$__/ $$______| $$   \$| $$__| $| $$__| $| $$$\| $| $$ __\$| $$__   | $$__| $$
  | $$ | $$    $|      | $$     | $$    $| $$    $| $$$$\ $| $$|    | $$  \  | $$    $$
  | $$ | $$$$$$$ \$$$$$| $$   __| $$$$$$$| $$$$$$$| $$\$$ $| $$ \$$$| $$$$$  | $$$$$$$\
 _| $$_| $$            | $$__/  | $$  | $| $$  | $| $$ \$$$| $$__| $| $$_____| $$  | $$
|   $$ | $$             \$$    $| $$  | $| $$  | $| $$  \$$$\$$    $| $$     | $$  | $$
 \$$$$$$\$$              \$$$$$$ \$$   \$$\$$   \$$\$$   \$$ \$$$$$$ \$$$$$$$$\$$   \$$
                                                                                       
                                                                                       
                                                                                        
                                                          
EOF

echo -e "\033[31m                By Just Hacked On - Offensive Security \033[0m"

while true; do
    read -rp $'\033[32mEnter time interval in seconds (0 for infinite): \033[0m' interval
    read -rp $'\033[32mEnter number of times to change IP (0 for infinite): \033[0m' times

    if ! [[ "$interval" =~ ^[0-9]+$ ]] || ! [[ "$times" =~ ^[0-9]+$ ]]; then
        log "Interval aur times sirf numbers hone chahiye."
        continue
    fi

    if [ "$interval" -ne 0 ] && [ "$interval" -lt 5 ]; then
        log "Interval kam se kam 5 seconds hona chahiye."
        continue
    fi

    if [ "$interval" -eq 0 ] || [ "$times" -eq 0 ]; then
        log "Starting infinite IP changes..."
        while true; do
            change_ip
            interval=$(shuf -i 10-20 -n 1)
            sleep "$interval"
            read -t 1 -n 1 -rp $'\033[32mPress q to quit, any key to continue: \033[0m' choice
            if [ "$choice" = "q" ]; then
                log "Exiting..."
                exit 0
            fi
        done
    else
        for ((i=0; i<times; i++)); do
            change_ip
            sleep "$interval"
        done
    fi

    read -rp $'\033[32mPress q to quit, any key to continue: \033[0m' choice
    if [ "$choice" = "q" ]; then
        log "Exiting..."
        exit 0
    fi
done
