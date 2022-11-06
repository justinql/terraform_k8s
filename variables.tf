variable "first_ip" {
  type = string
  default = "192.168.1.100"
  description = "First ip to assign to k8s vms, they will increment after"
}
variable "vsphere_server" {
  type = string
  default = "vcenter"
}

variable "vsphere_user" {
  type = string
  default = "administrator@vsphere.local"
}

variable "vsphere_password" {
  type = string
  sensitive = true
}

variable "vsphere_datacenter" {
  type = string
}

variable "vsphere_folder" {
  type = string
  description = "(Optional) The path to the virtual machine folder in which to place the virtual machine, relative to the datacenter path (/<datacenter-name>/vm). For example, /dc-01/vm/foo"
}

variable "vsphere_cluster" {
  type = string
}

variable "vsphere_resource_pool" {
  type = string
}

variable "vsphere_network" {
  type = string
  default = "VM Network"
}
variable "vsphere_datastore" {
  type = string
  default = "datastore0"
}
variable "control_node_prefix" {
  type = string
  default = "control-node-"
  description = "Prefix name of controle node."
}
variable "control_node_template" {
  type = string
  description = "Template to use to create control plane vm."
}
variable "control_node_count" {
  type = number
  default = 1
  description = "Number of control plane nodes. Must be odd number"
}
variable "control_node_cpu" {
  type = number
  default = 2
  description = "Count of CPUs to assign to control plane node. Minimum 2"
}
variable "control_node_mem" {
  type = number
  default = 2048
  description = "Amount of memory to assign to contol plane node in MB. Minimum 2048"
}
variable "control_node_disk" {
  type = number
  default = 64
  description = "Size of OS disk of control plane node in GB"
}
variable "worker_node_prefix" {
  type = string
  default = "worker-node-"
}
variable "worker_node_template" {
  type = string
  description = "Template to use to create worker vm."
}
variable "worker_node_count" {
  type = number
  default = 1
  description = "Number of worker nodes"
}
variable "worker_node_cpu" {
  type = number
  default = 2
  description = "Count of CPUs to assign to worker node. Minimum 2"
}
variable "worker_node_mem" {
  type = number
  default = 2048
  description = "Amount of memory to assign to worker node in MB. Minimum 2048"
}
variable "worker_node_disk" {
  type = number
  default = 64
  description = "Size of OS disk of worker node in GB"
}
