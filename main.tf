provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "control_plane_template" {
  name          = var.control_node_template
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "worker_node_template" {
  name          = var.worker_node_template
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "control_plane_vm" {
  count            = var.control_node_count
  name             = "${var.control_node_prefix}${count.index}"
  folder           = var.vsphere_folder
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = var.control_node_cpu
  memory           = var.control_node_mem
  guest_id         = data.vsphere_virtual_machine.control_plane_template.guest_id
  scsi_type        = data.vsphere_virtual_machine.control_plane_template.scsi_type

  network_interface {
    network_id = data.vsphere_network.network.id
  }
  disk {
    label = "disk0"
    size  = var.control_node_disk
    thin_provisioned = true
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.control_plane_template.id
    customize {
      linux_options {
        host_name = "${var.control_node_prefix}${count.index}"
        domain = "jql"
      }
      network_interface {
        ipv4_address = "${join(".", slice(split(".", var.first_ip),0,3))}.${split(".", var.first_ip)[3]+count.index}"
        ipv4_netmask = 24
      }
      ipv4_gateway = "172.16.102.1"
    }
  }
}
resource "vsphere_virtual_machine" "worker_node_vm" {
  count            = var.worker_node_count
  name             = "${var.worker_node_prefix}${count.index}"
  folder           = var.vsphere_folder
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = var.worker_node_cpu
  memory           = var.worker_node_mem
  guest_id         = data.vsphere_virtual_machine.worker_node_template.guest_id
  scsi_type        = data.vsphere_virtual_machine.worker_node_template.scsi_type
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  disk {
    label = "disk0"
    size  = var.worker_node_disk
    thin_provisioned = true
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.worker_node_template.id
    customize {
      linux_options {
        host_name = "${var.worker_node_prefix}${count.index}"
        domain = "jql"
      }
      network_interface {
        ipv4_address = "${join(".", slice(split(".", var.first_ip),0,3))}.${split(".",var.first_ip)[3]+var.control_node_count+count.index}"
        ipv4_netmask = 24
      }
      ipv4_gateway = "172.16.102.1"
    }
  }
}

output "control_plane_ips" {
  value = vsphere_virtual_machine.control_plane_vm.*.default_ip_address
}
output "worker_node_ips" {
  value = vsphere_virtual_machine.worker_node_vm.*.default_ip_address
}
