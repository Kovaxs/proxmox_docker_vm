resource "proxmox_virtual_environment_file" "docker_cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.node_name

  source_raw {
    data = templatefile("${path.module}/user_data.yml", {
      ci_user        = var.ci_user
      ssh_public_key = var.ssh_public_key
      hostname       = var.vm_name
      lan_cidr       = var.lan_cidr
    })

    file_name = "docker-cloud-init.yml"
  }
}

resource "proxmox_virtual_environment_vm" "docker" {
  name        = var.vm_name
  description = "Managed by Terraform - Docker host"
  node_name   = var.node_name
  vm_id       = var.vm_id
  tags        = ["docker", "ubuntu"]

  started = true
  on_boot = true

  agent {
    enabled = true
  }

  clone {
    vm_id = var.template_vm_id
    full  = true
  }

  cpu {
    cores = var.cores
    type  = "host"
  }

  memory {
    dedicated = var.memory_mb
  }

  disk {
    datastore_id = var.disk_datastore
    interface    = "scsi0"
    size         = var.disk_size
  }

  network_device {
    bridge      = var.network_bridge
    model       = "virtio"
    mac_address = var.mac_address
  }

  initialization {
    datastore_id = var.disk_datastore
    interface    = "ide0"

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.docker_cloud_config.id
  }
}
