package main

deny[msg] {
    resource_change := input.resource_changes[_]
    resource_change.provider_name != "registry.terraform.io/hashicorp/aws"
    resource_change.provider_name != "registry.terraform.io/hashicorp/random"
    resource_change.provider_name != "registry.terraform.io/hashicorp/azurerm"

    msg := sprintf("Provider is not allowed: %s", [resource_change.provider_name])
}
