locals {
  docker_ipv4_addresses = [
    for address in flatten(proxmox_virtual_environment_vm.docker.ipv4_addresses) : address
    if !can(regex("^(127\\.|169\\.254\\.|0\\.)", address))
  ]
}

output "docker_vm_id" {
  description = "Proxmox VM ID."
  value       = proxmox_virtual_environment_vm.docker.vm_id
}

output "docker_vm_name" {
  description = "VM name in Proxmox."
  value       = proxmox_virtual_environment_vm.docker.name
}

output "docker_ipv4_address" {
  description = "First usable IPv4 address reported by the guest agent. Null until the agent reports one."
  value       = try(local.docker_ipv4_addresses[0], null)
}

output "ansible_inventory_line" {
  description = "Inventory entry for the Ansible Docker setup."
  value       = "docker ansible_host=${try(local.docker_ipv4_addresses[0], "<vm-ip>")} ansible_user=${var.ci_user}"
}
