variable "proxmox_api_url" {
  type = string
}

variable "allow_tls_insecure" {
  type = bool
}

variable "iso_path" {
  type = string
  description = "The absolute path to the iso folder in the Proxmox."
}

variable "admin_user" {
  type = string
}

variable "admin_password" {
  type = string
  sensitive = true
}

variable "cluster_name" {
  type = string 
}

variable "target_node" {
  type = string
  description = "The proxmox node to create the VMs on"
}

variable "vms_start_id" {
  type = number
}

variable "config_workers" {
  type = object({
    count = number
    memory = number
    disks = number
    disk_size = string
    disk_storage_pool = string
  })
}

variable "config_masters" {
  type = object({
    count = number
    memory = number
    disks = number
    disk_size = string
    disk_storage_pool = string
  })
  validation {
    condition = contains([0,1,3,5], var.config_masters.count)
    error_message = "The number of masters can only be 0, 1, 3 or 5."
  }
}



