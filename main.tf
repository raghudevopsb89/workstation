provider "azurerm" {
  features {}
}


resource "null_resource" "vm_manage" {

  provisioner "local-exec" {
    when = "create" # This line is optional as it's the default
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



