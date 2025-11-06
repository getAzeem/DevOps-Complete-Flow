resource "azurerm_network_interface" "vm" {
  count               = var.replica_count
  name                = "${var.px}-${var.env}-nic-${count.index + 1}"
  location            = var.region
  resource_group_name = var.rg

  ip_configuration {
    name                          = "internal-ip"
    subnet_id                     = var.net_subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = merge(var.tags, {
    Name = "${var.px}-${var.env}-nic-${count.index + 1}"
  })
}

resource "azurerm_linux_virtual_machine" "main" {
  count               = var.replica_count
  name                = "${var.px}-${var.env}-vm-${count.index + 1}"
  location            = var.region
  resource_group_name = var.rg
  size                = var.inst_size
  admin_username      = var.admin_user
  network_interface_ids = [
    azurerm_network_interface.vm[count.index].id,
  ]

  admin_ssh_key {
    username   = var.admin_user
    public_key = var.ssh_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = merge(var.tags, {
    Name = "${var.px}-${var.env}-vm-${count.index + 1}"
  })
}
