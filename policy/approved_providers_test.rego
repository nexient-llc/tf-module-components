package main

test_deny_unknown_providers {
    count(deny) != 0 with input as { "resource_changes": [{ "provider_name": "unknown" }]}
}

test_allow_approved_providers {
    count(deny) == 0 with input as { "resource_changes": [{ "provider_name": "registry.terraform.io/hashicorp/random" }]}
}
