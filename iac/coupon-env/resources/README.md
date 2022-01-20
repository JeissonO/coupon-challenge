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
| <a name="module_cognito_user_pool"></a> [cognito\_user\_pool](#module\_cognito\_user\_pool) | ../../modules/application/cognito |  |
| <a name="module_dns_namespace"></a> [dns\_namespace](#module\_dns\_namespace) | ../../modules/network/route_53 |  |
| <a name="module_ecr_coupon"></a> [ecr\_coupon](#module\_ecr\_coupon) | ../../modules/application/ecr |  |
| <a name="module_ecs"></a> [ecs](#module\_ecs) | ../../modules/application/ecs |  |
| <a name="module_internal_nlb"></a> [internal\_nlb](#module\_internal\_nlb) | ../../modules/application/nlb |  |
| <a name="module_parameters"></a> [parameters](#module\_parameters) | ../../parameters |  |
| <a name="module_sg_ecs"></a> [sg\_ecs](#module\_sg\_ecs) | ../../modules/network/security_groups |  |

## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cognito_user_pool_arn"></a> [cognito\_user\_pool\_arn](#output\_cognito\_user\_pool\_arn) | arn de cognito user pool |
| <a name="output_cognito_user_pool_endpoint"></a> [cognito\_user\_pool\_endpoint](#output\_cognito\_user\_pool\_endpoint) | Cognito endpoint |
| <a name="output_cognito_user_pool_id"></a> [cognito\_user\_pool\_id](#output\_cognito\_user\_pool\_id) | ID del user pool creado |
| <a name="output_dns_namespace_id"></a> [dns\_namespace\_id](#output\_dns\_namespace\_id) | DNS privado generado para uso de Service Discovery con Route53 |
| <a name="output_ecr_coupon"></a> [ecr\_coupon](#output\_ecr\_coupon) | url del repositorio del servicio creado |
| <a name="output_ecs_cluster_id"></a> [ecs\_cluster\_id](#output\_ecs\_cluster\_id) | Identificador del cluster de ECS generado |
| <a name="output_ecs_cluster_name"></a> [ecs\_cluster\_name](#output\_ecs\_cluster\_name) | nombre del cluster de ECS generado |
| <a name="output_int_nlb_arn"></a> [int\_nlb\_arn](#output\_int\_nlb\_arn) | ARN del balanceador NLB interno |
| <a name="output_int_nlb_dns_name"></a> [int\_nlb\_dns\_name](#output\_int\_nlb\_dns\_name) | DNS del balanceador NLB interno |
| <a name="output_sg_ecs_id"></a> [sg\_ecs\_id](#output\_sg\_ecs\_id) | Identificador del security group asociado al cluster de ECS |
<!-- END_TF_DOCS -->
