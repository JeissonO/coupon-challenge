<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api_proxy_coupon"></a> [api\_proxy\_coupon](#module\_api\_proxy\_coupon) | ../../modules/application/apigateway/api-proxy |  |
| <a name="module_ecs_coupon_service"></a> [ecs\_coupon\_service](#module\_ecs\_coupon\_service) | ../../modules/application/ecs/service |  |
| <a name="module_parameters"></a> [parameters](#module\_parameters) | ../../parameters |  |
| <a name="module_vpc_link"></a> [vpc\_link](#module\_vpc\_link) | ../../modules/application/apigateway/vpc-link |  |

## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.resources](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->