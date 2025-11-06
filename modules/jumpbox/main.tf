resource "azurerm_public_ip" "bastion" {
  name                = "${var.px}-${var.env}-bastion-pip"
  location            = var.region
  resource_group_name = var.rg
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = merge(var.tags, {
    Name = "${var.px}-${var.env}-bastion-pip"
  })
}

resource "azurerm_network_interface" "bastion" {
  name                = "${var.px}-${var.env}-bastion-nic"
  location            = var.region
  resource_group_name = var.rg

  ip_configuration {
    name                          = "internal"
  subnet_id                     = var.jumpbox_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bastion.id
  }

  tags = merge(var.tags, {
    Name = "${var.px}-${var.env}-bastion-nic"
  })
}

resource "azurerm_network_security_group" "bastion" {
  name                = "${var.px}-${var.env}-bastion-nsg"
  location            = var.region
  resource_group_name = var.rg

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
  source_address_prefix      = var.ssh_allow_cidr
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = merge(var.tags, {
    Name = "${var.px}-${var.env}-bastion-nsg"
  })
}

resource "azurerm_network_interface_security_group_association" "bastion" {
  network_interface_id      = azurerm_network_interface.bastion.id
  network_security_group_id = azurerm_network_security_group.bastion.id
}

resource "azurerm_linux_virtual_machine" "bastion" {
  name                = "${var.px}-${var.env}-bastion-vm"
  location            = var.region
  resource_group_name = var.rg
  size                = var.jumpbox_size
  admin_username      = var.admin_user

  network_interface_ids = [
    azurerm_network_interface.bastion.id,
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
    Name = "${var.px}-${var.env}-bastion-vm"
    Role = "Bastion"
  })
}
