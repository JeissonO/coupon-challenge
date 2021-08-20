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
| <a name="module_api_proxy_balances"></a> [api\_proxy\_balances](#module\_api\_proxy\_balances) | ../../modules/application/apigateway/api-proxy |  |
| <a name="module_ecs_balances_service"></a> [ecs\_balances\_service](#module\_ecs\_balances\_service) | ../../modules/application/ecs/service |  |
| <a name="module_loggroups_log_sexporter"></a> [loggroups\_log\_sexporter](#module\_loggroups\_log\_sexporter) | ../../modules/custom/logs-exporter |  |
| <a name="module_parameters"></a> [parameters](#module\_parameters) | ../../parameters |  |
| <a name="module_s3_poc_audit_logs"></a> [s3\_poc\_audit\_logs](#module\_s3\_poc\_audit\_logs) | ../../modules/storage/s3/logs |  |
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