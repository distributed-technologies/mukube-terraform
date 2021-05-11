terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.6.8"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = var.allow_tls_insecure
  pm_api_url = var.proxmox_api_url
  pm_user = var.admin_user
  pm_password = var.admin_password
}

module "masters" {
  count = var.config_masters.count
  source = "./vm_module"
  name = "${var.cluster_name}-master${count.index}"
  iso = "${var.iso_path}/${var.cluster_name}/master${count.index}.iso"
  memory = 32000
  disks = var.config_masters.disks
  disk_size = var.config_masters.disk_size
  disk_storage_pool = var.disk_storage_pool
  target_node = var.target_node
}

module "workers" {
  count = var.config_workers.count
  source = "./vm_module"
  name = "${var.cluster_name}-worker${count.index}"
  iso = "${var.iso_path}/${var.cluster_name}/worker${count.index}.iso"
  memory = 15000
  disks = var.config_workers.disks
  disk_size = var.config_workers.disk_size
  disk_storage_pool = var.disk_storage_pool
  target_node = var.target_node
  depends_on = [
    module.masters
  ]
}

