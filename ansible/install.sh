#!/bin/bash
set -euo pipefail
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
DISTRO=$(grep -Po "^NAME=\"?\K[a-zA-Z\s]+" /etc/os-release)
echo "[+] Checking for Ansible command"
if ! command -v ansible >/dev/null; then
  # Get the name of the distro
  # Do the right thing to install Ansible
  if [[ "${DISTRO}" == "Arch Linux" ]]; then
    echo "[+] Installing Ansible"
    sudo pacman -Sy --quiet --noprogressbar --noconfirm ansible
  elif [[ "${DISTRO}" == "Ubuntu" ]]; then
    export DEBIAN_NONINTERACTIVE=true
    echo "[+] Updating package index"
    sudo apt-get update 2>&1 | tee -a "${SCRIPT_DIR}/setup.log" > /dev/null
    echo "[+] Installing Ansible"
    sudo apt-get install -y ansible 2>&1
  elif [[ "${DISTRO}" == "CentOS"* || "${DISTRO}" == "Oracle"* ]]; then
    echo "[+] Installing Ansible"
    sudo dnf -y install centos-release-ansible29
    sudo dnf -y install ansible
  else
    echo "[+] Installing Ansible"
    sudo dnf -y install ansible
  fi
fi

# Fetch Ansible Galaxy dependencies
echo "[+] Downloading Ansible role dependencies"
ansible-galaxy install -r "${SCRIPT_DIR}/requirements.yml"
ansible-galaxy collection install community.general

DIR="$(dirname $0)"

HOST=$1
shift

export ANSIBLE_HOST_KEY_CHECKING=False

# bootstrap
# ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook bootstrap.yml -i hosts -k -K

case "$HOST" in
    "local")
        ansible-playbook -i localhost, -c local "$DIR"/main.yml --diff $@
         ;;
    *)
        ansible-playbook -i $HOST "$DIR"/main.yml --diff $@
        ;;
esac
