terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.7.4"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = var.allow_tls_insecure
  pm_api_url = "https://${var.proxmox_host_endpoint}:${var.proxmox_api_port}/api2/json"
  pm_user = "${var.admin_user}@pam"
  pm_password = var.admin_password
}

module "masters" {
  count = var.config_masters.count
  source = "./vm_module"
  name = "${var.cluster_name}-master${count.index}"
  os = "${var.os_path}/${var.cluster_name}-master${count.index}.${var.os_format}"
  os_format = var.os_format
  vm_id = var.vms_start_id + count.index
  memory = var.config_masters.memory
  disks = var.config_masters.disks
  disk_size = var.config_masters.disk_size
  disk_storage_pool = var.config_masters.disk_storage_pool
  bios = var.config_masters.bios
  scsihw = var.config_masters.scsihw
  target_node = var.target_node
  user = var.admin_user
  host = var.proxmox_host_endpoint
  password = var.admin_password

}

module "workers" {
  count = var.config_workers.count
  source = "./vm_module"
  name = "${var.cluster_name}-worker${count.index}"
  os = "${var.os_path}/${var.cluster_name}-worker${count.index}.${var.os_format}"
  os_format = var.os_format
  vm_id = var.vms_start_id + var.config_masters.count + count.index
  memory = var.config_workers.memory
  disks = var.config_workers.disks
  disk_size = var.config_workers.disk_size
  disk_storage_pool = var.config_workers.disk_storage_pool
  bios = var.config_workers.bios
  scsihw = var.config_workers.scsihw
  target_node = var.target_node
  user = var.admin_user
  host = var.proxmox_host_endpoint
  password = var.admin_password
  depends_on = [
    module.masters
  ]
}

