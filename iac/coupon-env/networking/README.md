<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.7.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_nat_gateway"></a> [nat\_gateway](#module\_nat\_gateway) | ../../modules/network/vpc/nat-gateway |  |
| <a name="module_parameters"></a> [parameters](#module\_parameters) | ../../parameters |  |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../../modules/network/vpc |  |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_route_table_id"></a> [private\_route\_table\_id](#output\_private\_route\_table\_id) | Identificador de la Route Table Privada |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | Lista de identificadores de las subnets privadas |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | Lista de identificadores de las subnets publicas |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | Identificador de la VPC |
<!-- END_TF_DOCS -->