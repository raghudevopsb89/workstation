provider "azurerm" {
  features {}
}


resource "null_resource" "vm_manage" {

  depends_on = [null_resource.ip_manage]

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

resource "null_resource" "ip_manage" {

  depends_on = [azurerm_public_ip.workstation]

  provisioner "local-exec" {
    command = "az network nic ip-config update --resource-group denmark-east-rg --nic-name workstation409_z1 --name ipconfig1 --public-ip-address workstation-public-ip"
  }


  provisioner "local-exec" {
    when = "destroy"
    command = "az network nic ip-config update --resource-group denmark-east-rg --nic-name workstation409_z1 --name ipconfig1 --public-ip-address null"
  }

}

output "ip" {
  value = azurerm_public_ip.workstation.ip_address
}