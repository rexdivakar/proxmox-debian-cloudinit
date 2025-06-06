#!/bin/bash
VMID=8000
STORAGE=local-lvm
set -x

rm -f debian-12-generic-amd64.qcow2
wget -q https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2
qemu-img resize debian-12-generic-amd64.qcow2 8G

qm destroy $VMID
qm create $VMID --name "debian-12-template" --ostype l26 \
     --memory 1024 --balloon 0 \
     --agent 1 \
     --bios ovmf --machine q35 --efidisk0 $STORAGE:0,pre-enrolled-keys=0 \
     --cpu x86-64-v2-AES --cores 1 --numa 1 \
     --vga serial0 --serial0 socket  \
     --net0 virtio,bridge=vmbr0,mtu=1

qm importdisk $VMID debian-12-generic-amd64.qcow2 $STORAGE
qm set $VMID --scsihw virtio-scsi-pci --virtio0 $STORAGE:vm-$VMID-disk-1,discard=on
qm set $VMID --boot order=virtio0
qm set $VMID --scsi1 $STORAGE:cloudinit

mkdir -p /var/lib/vz/snippets
cat << EOF > /var/lib/vz/snippets/debian-12.yaml
#cloud-config
runcmd:
    - apt-get update
    - apt-get install -y qemu-guest-agent htop
    - reboot
EOF

qm set $VMID --cicustom "vendor=local:snippets/debian-12.yaml"
qm set $VMID --tags debian-template,debian-12,cloudinit
qm set $VMID --ciuser $USER
qm set $VMID --sshkeys ~/.ssh/authorized_keys
qm set $VMID --ipconfig0 ip=dhcp
qm template $VMID
