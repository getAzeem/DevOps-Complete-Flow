resource "azurerm_virtual_network" "main" {
  name                = "${var.project_name}-${var.environment}-vnet"
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-vnet"
  })
}

resource "azurerm_subnet" "private" {
  name                 = "${var.project_name}-${var.environment}-private-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_subnet_cidr]
}

resource "azurerm_subnet" "public" {
  name                 = "${var.project_name}-${var.environment}-public-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.public_subnet_cidr]
}

resource "azurerm_network_security_group" "vm_nsg" {
  name                = "${var.project_name}-${var.environment}-private-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-SSH-From-Bastion"
    name                = "${var.px}-${var.env}-vnet"
    address_space       = var.net_space
    location            = var.region
    resource_group_name = var.rg
    tags = merge(var.tags, {
      Name = "${var.px}-${var.env}-vnet"
    })
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    name                 = "${var.px}-${var.env}-private-subnet"
    resource_group_name  = var.rg
    address_prefixes     = [var.priv_subnet]
    source_address_prefix      = var.public_subnet_cidr
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 120
    direction                  = "Inbound"
    name                 = "${var.px}-${var.env}-public-subnet"
    resource_group_name  = var.rg
    address_prefixes     = [var.pub_subnet]
    destination_port_range     = "443"
    source_address_prefix      = var.public_subnet_cidr
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-SSH-From-Internet"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "Internet"
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

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-private-vm-nsg"
  })
}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}

resource "azurerm_public_ip" "nat" {
  name                = "${var.project_name}-${var.environment}-nat-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-nat-pip"
  })
}

resource "azurerm_nat_gateway" "main" {
  name                = "${var.project_name}-${var.environment}-nat-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-nat-gateway"
  })
}

resource "azurerm_nat_gateway_public_ip_association" "main" {
  nat_gateway_id       = azurerm_nat_gateway.main.id
  public_ip_address_id = azurerm_public_ip.nat.id
}

resource "azurerm_subnet_nat_gateway_association" "private" {
  subnet_id      = azurerm_subnet.private.id
  nat_gateway_id = azurerm_nat_gateway.main.id
}
    name                = "${var.px}-${var.env}-private-nsg"
    location            = var.region
    resource_group_name = var.rg
      source_address_prefix      = var.pub_subnet
      source_address_prefix      = var.pub_subnet
      source_address_prefix      = var.pub_subnet
    location            = var.region
    resource_group_name = var.rg
    tags = merge(var.tags, {
      Name = "${var.px}-${var.env}-private-vm-nsg"
    })
