# Proxmox Docker VM

This directory is a generic Docker-host project. Terraform creates one Ubuntu VM. Cloud-init prepares secure remote access and the QEMU guest agent. Ansible installs Docker Engine, Buildx, and Docker Compose from Docker's official Ubuntu repository.

No application, application container, or application service is deployed. Apart from host prerequisites, the Ansible playbook installs only Docker components.

The VM has these defaults:

- Name `docker`.
- 4 virtual CPU cores.
- 16384 MB of dedicated memory (16 GB).
- A 50 GB system disk.
- DHCP on `vmbr0`.
- VM ID `823`, cloned from Ubuntu template `9005`.

Only SSH is opened by the cloud-init firewall. Docker service ports can be opened later when needed.

## Authentication

Terraform uses the Proxmox API password from SecretSpec. SecretSpec resolves `pass://proxmox/root` into `TF_VAR_pve_api_password`.

Ansible does not use a Proxmox API key or password. It uses SSH as `ansible_user`. The private SSH key must correspond to `ssh_public_key` in `terraform.tfvars`. SSH can use a key from the agent or a default key file. Set `ansible_private_key_file` in `inventory.ini` only when a specific private-key path is needed. Never commit the private key.

## Requirements

Install Terraform 1.6 or newer, Ansible, `just`, SecretSpec, and `pass` on the workstation. The Proxmox password must exist at `pass://proxmox/root`. The SSH agent must contain a key that can log in to the Proxmox node as root. The cloud-init SSH key must belong to the VM user.

## 1. Configure Terraform

```sh
cd infra/terraform
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`. Set the Proxmox API URL, SSH public key, and values that match the homelab. Confirm that the VM ID and MAC address are unique. Do not put the Proxmox password in this file.

Check secret resolution without printing the password:

```sh
just check
```

## 2. Create the VM

```sh
just init
just fmt
just validate
just plan
```

Review the saved plan. Then apply that plan:

```sh
just apply
just output
```

Wait until `docker_ipv4_address` contains an address. Cloud-init and the guest agent can take several minutes.

Changing `user_data.yml` uploads a new snippet but does not change an existing guest. Recreate the VM to apply cloud-init changes.

## 3. Install Docker

Copy the Ansible inventory template:

```sh
cd ../ansible
cp inventory.ini.example inventory.ini
```

Replace `ansible_host` with `docker_ipv4_address` from Terraform. Keep `ansible_user` consistent with `ci_user`. Change the `docker_users` list in `group_vars/docker.yml` if the remote user has another name. Test SSH once to accept and verify the host key:

```sh
ssh kovaxs@<vm-ip>
```

Run the Docker playbook:

```sh
ansible-playbook docker.yml --syntax-check
ansible-playbook docker.yml
```

The playbook adds the configured users to the `docker` group. Start a new SSH session after the first successful run. Docker group membership grants root-equivalent access to the host.

Verify the installation:

```sh
ssh kovaxs@<vm-ip>
docker info
docker compose version
```

## Local files and secrets

`terraform.tfvars`, Terraform state, saved plans, provider caches, and `inventory.ini` are ignored. Do not commit them. The `.terraform.lock.hcl` file is intended for version control.
