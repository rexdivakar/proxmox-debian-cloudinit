# 🚀 Debian 12 Cloud-Init Template for Proxmox

This project provides a Bash script to create a **Debian 12 (Bookworm)** cloud-init-ready VM template on a **Proxmox VE** node. The resulting template can be used to quickly spin up cloud-init-configured VMs with custom SSH access and user provisioning.

---

## 📋 Features

- 🔽 Downloads the latest official Debian 12 cloud image (QCOW2)
- 📦 Resizes the image to 8GB
- ⚙️ Creates and configures a Proxmox VM with cloud-init support
- 🧠 Enables QEMU guest agent
- 🔐 Injects your SSH public key
- 🛠 Installs essential packages (`qemu-guest-agent`, `htop`)
- 🌩 Sets the VM as a reusable Proxmox **template**

---

## 🧰 Requirements

- Proxmox VE (tested on PVE 7+)
- Shell access to the Proxmox host
- Internet access to download the Debian cloud image
- A valid `~/.ssh/authorized_keys` file

---

## 📜 Usage

1. **Clone the repo or copy the script**

2. **Run the script on your Proxmox host**

```bash
chmod +x create-debian12-template.sh
./create-debian12-template.sh
