<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.eni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_network_interface.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.ingress_any](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ami.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enabled"></a> [enabled](#input\_enabled) | use low cost resources | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | environment were the resources going to be created | `any` | n/a | yes |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | AMI for NAT instance | `string` | `""` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Instence types for NAT Instance. This is used in the mixed instances policy | `list(any)` | <pre>[<br>  "t2.micro",<br>  "t3a.nano"<br>]</pre> | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | key pair for NAT instance. you can put a variable to use a key pair | `string` | `""` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | Entity or organization owner of the resource | `any` | n/a | yes |
| <a name="input_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#input\_private\_subnet\_cidrs) | private subnets CIDRS blocks | `list(string)` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | list of private subnets id's | `list(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Name of the project owner of the resource | `any` | n/a | yes |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | list of public subnets id's | `list(string)` | n/a | yes |
| <a name="input_resource"></a> [resource](#input\_resource) | name of the resources or group o resources | `any` | n/a | yes |
| <a name="input_route_table_id"></a> [route\_table\_id](#input\_route\_table\_id) | private route table id (privada) | `any` | n/a | yes |
| <a name="input_use_spot_instance"></a> [use\_spot\_instance](#input\_use\_spot\_instance) | use spot or on-demand EC2 instance | `bool` | `true` | no |
| <a name="input_user_data_runcmd"></a> [user\_data\_runcmd](#input\_user\_data\_runcmd) | runcmd additional for cloud-init | `list(any)` | `[]` | no |
| <a name="input_user_data_write_files"></a> [user\_data\_write\_files](#input\_user\_data\_write\_files) | write\_files additional for cloud-init | `list(any)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | vpc id where the resource will be created | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eni_id"></a> [eni\_id](#output\_eni\_id) | ID de la interfaz de red ENI de la NAT instance |
| <a name="output_eni_private_ip"></a> [eni\_private\_ip](#output\_eni\_private\_ip) | IP privada de la interfaz de red  ENI de la NAT instance |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | Nombre del IAM role de la NAT instance |
| <a name="output_sg_id"></a> [sg\_id](#output\_sg\_id) | ID del security group de la NAT instance |
<!-- END_TF_DOCS -->
