variable "pve_api_url" {
  type        = string
  description = "Proxmox API base URL, for example https://192.168.5.144:8006."
}

variable "pve_api_user" {
  type        = string
  description = "Proxmox API user in user@realm form."
}

variable "pve_api_password" {
  type        = string
  description = "Proxmox API password. Supply it through TF_VAR_pve_api_password."
  sensitive   = true
}

variable "pve_ssh_username" {
  type        = string
  description = "Proxmox node SSH user used for snippet uploads. The SSH agent must hold this user's key."
  default     = "root"
}

variable "node_name" {
  type        = string
  description = "Proxmox node on which to create the VM."
  default     = "prox"
}

variable "vm_name" {
  type        = string
  description = "VM name in Proxmox and guest hostname."
  default     = "docker"
}

variable "vm_id" {
  type        = number
  description = "Unique VM ID in the Proxmox cluster."
  default     = 823
}

variable "template_vm_id" {
  type        = number
  description = "Ubuntu cloud-image template to clone."
  default     = 9005
}

variable "network_bridge" {
  type        = string
  description = "Proxmox bridge for the VM network interface."
  default     = "vmbr0"
}

variable "mac_address" {
  type        = string
  description = "Unique, stable MAC address for the VM network interface."
  default     = "bc:24:11:08:10:0d"
}

variable "disk_datastore" {
  type        = string
  description = "Storage for the system disk and cloud-init drive."
  default     = "local-lvm"
}

variable "disk_size" {
  type        = number
  description = "System disk size in GB."
  default     = 50
}

variable "cores" {
  type        = number
  description = "Number of virtual CPU cores."
  default     = 4
}

variable "memory_mb" {
  type        = number
  description = "Dedicated memory in MB. 16384 MB is 16 GB."
  default     = 16384
}

variable "lan_cidr" {
  type        = string
  description = "LAN CIDR allowed to connect to SSH."
  default     = "192.168.5.0/24"
}

variable "ci_user" {
  type        = string
  description = "Cloud-init sudo user used by Ansible."
  default     = "kovaxs"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for the cloud-init user."
}
