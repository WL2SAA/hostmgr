#!/bin/bash

# Run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi
# Rainbow colors function
rainbow_text() {
    local text="$1"
    local colors=('\033[31m' '\033[33m' '\033[32m' '\033[36m' '\033[34m' '\033[35m')
    local color_index=0
    for (( i=0; i<${#text}; i++ )); do
        echo -ne "${colors[color_index]}${text:$i:1}"
        color_index=$(( (color_index + 1) % ${#colors[@]} ))
    done
    echo -e '\033[0m'
    }

# Rainbow banner
rainbow_banner() {
   echo -e  
   echo -e ██╗░░██╗░█████╗░░██████╗████████╗███╗░░░███╗░██████╗ ░██████╗░       
   echo -e ██║░░██║██╔══██╗██╔════╝╚══██╔══╝████╗░████║██╔════╝░██╔══██
   echo -e ███████║██║░░██║╚█████╗░░░░██║░░░██╔████╔██║██║░░██╗░██████╔╝
   echo -e ██╔══██║██║░░██║░╚═══██╗░░░██║░░░██║╚██╔╝██║██║░░╚██╗██╔══██╗
   echo -e ██║░░██║╚█████╔╝██████╔╝░░░██║░░░██║░╚═╝░██║╚██████╔╝██║░░██║
   echo -e ╚═╝░░╚═╝░╚════╝░╚═╗════╝░░░░╚═╝░░░╚═╝░░░░░╚═╝░╚════╝╚═╝░░╚═╝
}

while true; do
    clear
    
    rainbow_banner

    echo
    echo "=================================="
    echo "         SERVER TOOLKIT"
    echo "=================================="
    echo -e " SSH FIX"
    echo -e " CLOUDFLARE INSTALLER"
    echo -e " TAILSCALE INSTALL & UP"
    echo -e " SSHX INSTALLER"
    echo -e " SYSTEM UPDATER"
    echo -e " FASTFETCH INSTALLER"
    echo -e " PTERODACTYL INSTALLER"
    echo -e " PUFFER PANEL INSTALLER"
    echo -e " RDP WINDOWS 10"
    echo -e " PROXMOX INSTALL"
    echo -e " REVIACTYL THEME"
    echo -e " VPS ISSUE FIXER"
    echo -e " SYSTEM INFORMATION"
    echo -e " EXIT"
    echo "=================================="
    echo

    read -rp "Select an option: " choice

    case $choice in

        1)
            echo "Fixing SSH..."

            passwd

            sed -i \
                -e 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' \
                -e 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' \
                /etc/ssh/sshd_config

            systemctl restart ssh 2>/dev/null || systemctl restart sshd

            echo "SSH access enabled."
            ;;

        2)
            echo "Installing Cloudflared..."

            ARCH=$(dpkg --print-architecture)

            wget -q -O /tmp/cloudflared.deb \
            "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${ARCH}.deb"

            dpkg -i /tmp/cloudflared.deb

            read -rp "Enter Cloudflare Tunnel Token: " TOKEN

            cat > /etc/systemd/system/cloudflared.service << EOF
[Unit]
Description=Cloudflare Tunnel
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
Restart=always
RestartSec=5s
ExecStart=$(command -v cloudflared) tunnel --protocol http2 run --token ${TOKEN}

[Install]
WantedBy=multi-user.target
EOF

            systemctl daemon-reload
            systemctl enable --now cloudflared

            echo "Cloudflared installed and started."
            ;;

        3)
            echo "Installing Tailscale..."

            curl -fsSL https://tailscale.com/install.sh | sh

            echo
            echo "Starting Tailscale..."
            tailscale up
            ;;

        4)
            echo "Installing SSHX..."

            curl -sSf https://sshx.io/get | sh

            echo
            echo "SSHX installed."
            echo "Run: sshx"
            ;;

        5)
            echo "Updating system..."

            apt update
            apt upgrade -y
            apt autoremove -y

            echo "System updated."
            ;;

        6)
            echo "Installing Fastfetch..."

            # Download and install Fastfetch from latest release
            wget -qO /tmp/fastfetch.tar.gz https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.tar.gz
            tar xf /tmp/fastfetch.tar.gz --strip-components=3 -C /usr/local/bin fastfetch-linux-amd64/usr/bin/fastfetch

            echo
            echo "Fastfetch installed successfully!"
            fastfetch
            ;;

        7)
            echo "Running Pterodactyl Installer..."

            bash <(curl -s https://pterodactyl-installer.se)

            ;;

        8)
            echo "Installing Puffer Panel..."

            # Clone the repository
            git clone https://github.com/foxytouxxx/pufferpanel-install.git /tmp/pufferpanel-install
            cd /tmp/pufferpanel-install

            # Make the script executable and run it
            chmod +x pufferpanel.sh
            
            # Run the installer with predefined credentials
            bash pufferpanel.sh --email foxytoux@gmail.com --name foxytoux --password Fox21200 --admin

            # Clean up
            cd ~
            rm -rf /tmp/pufferpanel-install

            echo
            echo "========================================="
            echo "Puffer Panel Installation Complete!"
            echo "========================================="
            echo "Login Details:"
            echo "Email:    foxytoux@gmail.com"
            echo "Name:     foxytoux"
            echo "Password: Fox21200"
            echo "Role:     Admin"
            echo "========================================="
            echo
            ;;

        9)
            echo "Installing Docker..."
            apt update
            apt install -y docker.io
            systemctl start docker
            systemctl enable docker

            echo "Running Windows 10 RDP Container..."
            docker run -d \
              --name atyro-cloud-pc \
              --restart unless-stopped \
              --device /dev/kvm:/dev/kvm \
              --cap-add NET_ADMIN \
              -p 6080:6080 \
              -p 5900:5900 \
              -p 3389:3389 \
              -e VNC_PASSWORD=admin123 \
              -e RAM=2048 \
              -e CPU=1 \
              -e DISK=50G \
              -v atyro_data:/data \
              -v atyro_iso:/iso \
              hopingboyz/win10-ultra-lite

            echo
            echo "========================================="
            echo "Windows 10 RDP Container Started!"
            echo "========================================="
            echo "Access Details:"
            echo "VNC:        http://$(curl -s ifconfig.me):6080"
            echo "RDP:        $(curl -s ifconfig.me):3389"
            echo "VNC Password: admin123"
            echo "========================================="
            echo
            ;;

        10)
            echo "Installing Docker..."
            apt update
            apt install -y docker.io
            systemctl start docker
            systemctl enable docker

            echo "Running Proxmox Container..."
            docker run -d \
              --name proxmox-vm \
              --privileged \
              --device /dev/kvm \
              -p 6080:6080 \
              -p 2026:2222 \
              -p 8006:8006 \
              -e RAM=25600 \
              -e CPU=6 \
              -e DISK=256 \
              -e ROOT_PASS=root123 \
              -e VNC_PASS=admin123 \
              -v proxmox_data:/vm \
              hopingboyz/atyro-proxmox8

            echo
            echo "========================================="
            echo "Proxmox Container Started!"
            echo "========================================="
            echo "Access Details:"
            echo "VNC:        http://$(curl -s ifconfig.me):6080"
            echo "Proxmox:    https://$(curl -s ifconfig.me):8006"
            echo "SSH:        ssh root@$(curl -s ifconfig.me) -p 2026"
            echo ""
            echo "Default Credentials:"
            echo "Root Password: root123"
            echo "VNC Password:  admin123"
            echo ""
            echo "IMPORTANT: Access VNC at http://$(curl -s ifconfig.me):6080 to continue installation"
            echo "========================================="
            echo
            ;;

        11)
            echo "Installing Reviactyl Theme for Pterodactyl..."

            # Check if Pterodactyl directory exists
            if [ ! -d "/var/www/pterodactyl" ]; then
                echo "Pterodactyl not found in /var/www/pterodactyl"
                echo "Please install Pterodactyl first (Option 7)"
                read -rp "Press Enter to continue..."
                continue
            fi

            cd /var/www/pterodactyl
            
            # Remove existing files
            rm -rf *
            
            # Download Reviactyl panel
            curl -Lo panel.tar.gz https://github.com/reviactyl/panel/releases/latest/download/panel.tar.gz
            
            # Extract
            tar -xzvf panel.tar.gz
            
            # Set permissions
            chmod -R 755 storage/* bootstrap/cache/
            
            # Install dependencies
            COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --optimize-autoloader
            
            # Run migrations
            php artisan migrate --seed --force
            
            # Set ownership
            chown -R www-data:www-data /var/www/pterodactyl/*
            
            # Restart queue worker
            sudo systemctl restart pteroq.service

            echo
            echo "========================================="
            echo "Reviactyl Theme Installed Successfully!"
            echo "========================================="
            echo "Your Pterodactyl panel now has the Reviactyl theme!"
            echo "========================================="
            echo
            ;;

        12)
            echo "========================================="
            echo "VPS Issue Fixer - HTTP/2 Protocol Fix"
            echo "========================================="
            echo

            # Backup current sysctl.conf
            cp /etc/sysctl.conf /etc/sysctl.conf.backup

            # Fix HTTP/2 and network issues
            echo "Applying network optimizations for Qyro VPS..."

            # Disable IPv6 if causing issues
            echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
            echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf

            # Increase buffer sizes for better HTTP/2 performance
            echo "net.core.rmem_max = 134217728" >> /etc/sysctl.conf
            echo "net.core.wmem_max = 134217728" >> /etc/sysctl.conf
            echo "net.ipv4.tcp_rmem = 4096 87380 134217728" >> /etc/sysctl.conf
            echo "net.ipv4.tcp_wmem = 4096 65536 134217728" >> /etc/sysctl.conf

            # Optimize TCP settings for HTTP/2
            echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
            echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
            echo "net.ipv4.tcp_notsent_lowat = 16384" >> /etc/sysctl.conf
            echo "net.ipv4.tcp_mtu_probing = 1" >> /etc/sysctl.conf

            # Increase connection tracking
            echo "net.netfilter.nf_conntrack_max = 655360" >> /etc/sysctl.conf
            echo "net.ipv4.tcp_max_syn_backlog = 8192" >> /etc/sysctl.conf
            echo "net.core.somaxconn = 8192" >> /etc/sysctl.conf

            # Apply sysctl settings
            sysctl -p

            # Fix APT sources for Qyro
            echo "Fixing APT sources..."
            apt update --fix-missing

            # Install missing dependencies
            echo "Installing required dependencies..."
            apt install -y ca-certificates curl gnupg lsb-release

            # Fix Cloudflare DNS if needed
            echo "Setting up Cloudflare DNS..."
            echo "nameserver 1.1.1.1" > /etc/resolv.conf
            echo "nameserver 1.0.0.1" >> /etc/resolv.conf

            # Restart networking
            echo "Restarting networking..."
            systemctl restart systemd-resolved 2>/dev/null || systemctl restart networking

            # Fix Nginx if installed
            if command -v nginx &> /dev/null; then
                echo "Fixing Nginx HTTP/2 settings..."
                # Enable HTTP/2 in Nginx
                sed -i 's/http2 on;/http2 on;/g' /etc/nginx/nginx.conf
                sed -i 's/listen 443 ssl;/listen 443 ssl http2;/g' /etc/nginx/sites-available/*
                nginx -t && systemctl restart nginx
            fi

            # Fix Apache if installed
            if command -v apache2 &> /dev/null; then
                echo "Fixing Apache HTTP/2 settings..."
                a2enmod http2
                systemctl restart apache2
            fi

            # Fix Docker if installed
            if command -v docker &> /dev/null; then
                echo "Fixing Docker network issues..."
                systemctl restart docker
            fi

            echo
            echo "========================================="
            echo"VPS Issues Fixed Successfully!"
            echo "========================================="
            echo "Applied fixes:"
            echo "âœ“ Disabled IPv6 (if causing issues)"
            echo "âœ“ Increased network buffer sizes"
            echo "âœ“ Optimized TCP settings for HTTP/2"
            echo "âœ“ Enabled BBR congestion control"
            echo "âœ“ Fixed APT sources"
            echo "âœ“ Set Cloudflare DNS (1.1.1.1)"
            echo "âœ“ Fixed Nginx/Apache HTTP/2 if installed"
            echo "âœ“ Restarted networking services"
            echo "========================================="
            echo "Note: System reboot recommended for all changes to take effect"
            echo
            read -rp "Would you like to reboot now? (y/n): " reboot_choice
            if [[ $reboot_choice == "y" || $reboot_choice == "Y" ]]; then
                echo "Rebooting system in 5 seconds..."
                sleep 5
                reboot
            fi
            ;;

        13)
            clear
            echo "========================================="
            echo"         SYSTEM INFORMATION"
            echo "========================================="
            echo

            # Hostname
            echo -e "HOSTNAME"
            echo -e "$(hostname)"

            # RAM Usage
            echo -e "RAM"
            total_ram=$(free -h | awk '/^Mem:/ {print $2}')
            used_ram=$(free -h | awk '/^Mem:/ {print $3}')
            free_ram=$(free -h | awk '/^Mem:/ {print $4}')
            echo -e "Total: $total_ram"
            echo -e "Used:  $used_ram"
            echo -e "\033[36m  Free:  $free_ram\033[0m"

            # CPU Information
            
            
            echo -e "CPU"
            cpu_model=$(lscpu | grep "Model name" | awk -F': ' '{print $2}' | head -1)
            cpu_cores=$(nproc)
            cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
            echo -e "Model: $cpu_model"
            echo -e "Cores: $cpu_cores"
            echo -e "Usage: ${cpu_usage}"

            # Disk Usage
            echo -e"DISK"
            disk_total=$(df -h / | awk 'NR==2 {print $2}')
            disk_used=$(df -h / | awk 'NR==2 {print $3}')
            disk_free=$(df -h / | awk 'NR==2 {print $4}')
            disk_usage_percent=$(df -h / | awk 'NR==2 {print $5}')
            echo -e "Total: $disk_total"
            echo -e "Used:  $disk_used"
            echo -e "Free:  $disk_free"
            echo -e "Usage: $disk_usage_percent"

            # Uptime
            echo -e "UPTIME"
            uptime_info=$(uptime -p | sed 's/up //')
            load_average=$(uptime | awk -F'load average:' '{print $2}')
            echo -e "Time: $uptime_info"
            echo -e "Load: $load_average"

            # Public IPv4
            echo -e "PUBLIC IPv4"
            public_ipv4=$(curl -s4 ifconfig.me 2>/dev/null || curl -s4 icanhazip.com 2>/dev/null || echo "Not available")
            echo -e "$public_ipv4"

            # Public IPv6
            echo -e "PUBLIC IPv6"
            public_ipv6=$(curl -s6 ifconfig.me 2>/dev/null || curl -s6 icanhazip.com 2>/dev/null || echo "Not available")
            echo -e "$public_ipv6"

            # Private IPv4
            echo -e "PRIVATE IPv4"
            private_ipv4=$(hostname -I | awk '{print $1}')
            echo -e "$private_ipv4"

            # Private IPv6
            echo -e "PRIVATE IPv6"
            private_ipv6=$(hostname -I | awk '{print $2}')
            if [[ -z "$private_ipv6" ]]; then
                private_ipv6="Not available"
            fi
            echo -e "$private_ipv6"

            # Operating System
            echo -e "OPERATING SYSTEM"
            os_info=$(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)
            kernel=$(uname -r)
            echo -e "OS: $os_info"
            echo -e "Kernel: $kernel"

            echo
            echo "========================================="
            echo "     END OF SYSTEM INFORMATION"
            echo "========================================="
            echo
            ;;

        0)
            echo "Goodbye!"
            exit 0
            ;;

        *)
            echo "Invalid option."
            ;;
    esac

    echo
    read -rp "Press Enter to continue..."
done
tinue..."
done
          echo   "     END OF SYSTEM INFORMATION"
            echo "========================================="
            echo
            ;;

        0)
            echo "Goodbye!"
            exit 0
            ;;

        *)
            echo "Invalid option."
            ;;
    esac

    echo
    read -rp "Press Enter to continue..."
done
