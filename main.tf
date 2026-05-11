provider "azurerm" {
  features {}
}


resource "null_resource" "vm_manage" {

  provisioner "local-exec" {
    #when = "create" # This line is optional as it's the default
    command = "az vm start --resource-group denmark-east-rg --name workstation"
  }


  provisioner "local-exec" {
    when = "destroy"
    command = "az vm stop --resource-group denmark-east-rg --name workstation ; az vm deallocate --resource-group denmark-east-rg --name workstation"
  }

}

resource "azurerm_public_ip" "workstation" {
  name                = "workstation-public-ip"
  location            = "Denmark East"
  resource_group_name = "denmark-east-rg"
  allocation_method   = "Static"
}


resource "azurerm_network_interface" "workstation" {
  name                = "workstation409_z1"
  location            = "Denmark East"
  resource_group_name = "denmark-east-rg"

  ip_configuration {
    name                          = "ipconfig1" # Must match your existing config name
    subnet_id                     = "/subscriptions/3f2e42e1-ca06-4a99-8c56-be8d8ba306db/resourceGroups/denmark-east-rg/providers/Microsoft.Network/virtualNetworks/workstation-vnet/subnets/default"
    private_ip_address_allocation = "Static"   # Keep your existing IP settings
    private_ip_address            = "10.1.0.4" # Your existing private IP

    # ADD THIS LINE TO ATTACH THE PUBLIC IP
    public_ip_address_id          = azurerm_public_ip.workstation.id
  }
}

