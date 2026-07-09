# hostmgr

`hostmgr` is a collection of bash scripts designed to streamline the management of hosting environments, with a primary focus on the Pterodactyl gaming panel and local QEMU-based virtual machines. It provides menu-driven interfaces for installation, configuration, and maintenance tasks.

## Quick Start
To launch the main hosting manager for Pterodactyl and related services, run the following command:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/WL2SAA/hostmgr/refs/heads/main/hostmgr.sh)
```

To launch the standalone QEMU VPS manager, run:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/WL2SAA/hostmgr/refs/heads/main/vps.sh)
```

## Features

*   **Pterodactyl Management:** Automates the installation, updating, user creation, and uninstallation of the Pterodactyl Panel and Wings.
*   **VPS Management:** A comprehensive QEMU-based VM manager to create, run, and manage local Linux virtual machines (Ubuntu, Debian, Fedora, etc.) with cloud-init support.
*   **Panel Customization:** Install the Blueprint framework and associated themes/extensions to enhance the Pterodactyl Panel.
*   **Networking Tools:** Easily set up Cloudflare Tunnels for secure public access and Tailscale for private networking.
*   **Database Setup:** Quickly create new MySQL/MariaDB users and enable remote access.
*   **System Utilities:** View system information and manage services through a simple, unified interface.

## Scripts Overview

This repository contains several standalone and interconnected scripts, accessible through the two main entry points mentioned in the Quick Start.

### Primary Scripts

*   **`hostmgr.sh`**: The central management script for hosting services. It provides a text-based user interface (TUI) to access all functionalities related to Pterodactyl, networking, and database setup.
*   **`vps.sh`**: A comprehensive QEMU-based virtual machine manager. It allows you to create, start, stop, delete, edit, and resize local Linux VMs for development or testing, using cloud-init for automated user and network configuration.

### Component Scripts (Launched by `hostmgr.sh`)

*   **`panel2.sh`**: Handles the full lifecycle of the Pterodactyl Panel, including installation, administrative user creation, updates, and uninstallation.
*   **`wing2.sh`**: Manages the installation and configuration of Pterodactyl Wings. This includes setting up Docker, system services, and an interactive prompt to auto-configure the daemon with your panel's details.
*   **`uninstall2.sh`**: A dedicated utility to safely and completely remove the Pterodactyl Panel, Wings, or both, ensuring that services, files, and database entries are cleanly purged.
*   **`Blueprint2.sh`**: An installer for the Blueprint framework, which extends the Pterodactyl Panel with custom themes and extensions.
*   **`cloudflare.sh`**: A utility to install and configure the Cloudflare Tunnel service (`cloudflared`) to expose your panel securely without opening ports on your firewall.
*   **`Tailscale.sh`**: An installer and uninstaller for Tailscale, a zero-config VPN for creating secure networks between your devices.
