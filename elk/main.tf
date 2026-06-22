provider "azurerm" {
  features {}
}


resource "null_resource" "elk_vm_manage" {

  depends_on = [null_resource.elk_ip_manage]

  provisioner "local-exec" {
    #when = "create" # This line is optional as it's the default
    command = "az vm start --resource-group denmark-east-rg --name elk"
  }


  provisioner "local-exec" {
    when    = "destroy"
    command = "az vm stop --resource-group denmark-east-rg --name elk ; az vm deallocate --resource-group denmark-east-rg --name elk"
  }

}

resource "azurerm_public_ip" "elk" {
  name                = "elk-public-ip"
  location            = "Denmark East"
  resource_group_name = "denmark-east-rg"
  allocation_method   = "Static"
}

resource "null_resource" "elk_ip_manage" {

  depends_on = [azurerm_public_ip.elk]

  provisioner "local-exec" {
    command = "az network nic ip-config update --resource-group denmark-east-rg --nic-name elk637_z1 --name ipconfig1 --public-ip-address elk-public-ip"
  }


  provisioner "local-exec" {
    when    = "destroy"
    command = "az network nic ip-config update --resource-group denmark-east-rg --nic-name elk637_z1 --name ipconfig1 --public-ip-address null"
  }

}

output "ip" {
  value = azurerm_public_ip.elk.ip_address
}
