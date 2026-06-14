rgs = {
  rg1 = {
    name       = "rg-dev-trs-012222"
    location   = "East US2"
    managed_by = "Terraform"
    tags = {
      env = "dev"
      project = "TruStage"
    }
    
  }
}
storage_accounts = {
  sa1 = {
    name                     = "stgdevtrs0122"
    resource_group_name      = "rg-dev-trs-012222"
    location                 = "East US2"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    tags = {
      env = "dev"
      project = "TruStage"
    }
  }
}
