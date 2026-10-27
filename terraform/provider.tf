terraform {
  required_version = ">= 1.6.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.71.0"
    }
  }
}

provider "proxmox" {
  endpoint = var.pve_api_url
  username = var.pve_api_user
  password = var.pve_api_password
  insecure = true

  ssh {
    agent    = true
    username = var.pve_ssh_username
  }
}
