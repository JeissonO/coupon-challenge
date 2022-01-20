<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.app_down](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.app_up](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.app_scale_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_cloudwatch_log_group.log_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_metric_alarm.utilization_high](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.utilization_low](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_ecs_service.microservice_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.microservice](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.ecs_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ecs_execution_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lb_listener.listener_alb_microservice](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.target_alb_microservice](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_service_discovery_service.service_discovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_service) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_namespace_id"></a> [dns\_namespace\_id](#input\_dns\_namespace\_id) | dns namespace id utilizado para service discovery | `string` | n/a | yes |
| <a name="input_ecr_repository_url"></a> [ecr\_repository\_url](#input\_ecr\_repository\_url) | URL del repositorio ECR en el que se encuetra la imagen del microservicio a desplegar | `any` | n/a | yes |
| <a name="input_ecs_autoscale_max_instances"></a> [ecs\_autoscale\_max\_instances](#input\_ecs\_autoscale\_max\_instances) | numero maximo de instancias en el autoscaling | `number` | `2` | no |
| <a name="input_ecs_autoscale_min_instances"></a> [ecs\_autoscale\_min\_instances](#input\_ecs\_autoscale\_min\_instances) | numero minimo de instancias en el autoscaling | `number` | `1` | no |
| <a name="input_ecs_capacity_provider_fargate_spot_weight"></a> [ecs\_capacity\_provider\_fargate\_spot\_weight](#input\_ecs\_capacity\_provider\_fargate\_spot\_weight) | peso asignado a instancias spot 0-100 | `number` | `100` | no |
| <a name="input_ecs_capacity_provider_fargate_weight"></a> [ecs\_capacity\_provider\_fargate\_weight](#input\_ecs\_capacity\_provider\_fargate\_weight) | peso asignado a instancias fargate 0 - 100 | `number` | `0` | no |
| <a name="input_ecs_cluster"></a> [ecs\_cluster](#input\_ecs\_cluster) | ID del cluster de ecs donde se despliega el servicio | `string` | n/a | yes |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | nombre del cluster de ecs donde se despliega el servicio | `string` | n/a | yes |
| <a name="input_ecs_high_threshold_per"></a> [ecs\_high\_threshold\_per](#input\_ecs\_high\_threshold\_per) | valor que dispara alarma de escalamiento up | `number` | `85` | no |
| <a name="input_ecs_low_threshold_per"></a> [ecs\_low\_threshold\_per](#input\_ecs\_low\_threshold\_per) | valor que dispara alarma de escalamiento down | `number` | `50` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Ambiente en el cual se crea el recurso | `any` | n/a | yes |
| <a name="input_evaluation_periods"></a> [evaluation\_periods](#input\_evaluation\_periods) | Periodos de evaluacion del servicio | `string` | `"1"` | no |
| <a name="input_healthcheck_interval"></a> [healthcheck\_interval](#input\_healthcheck\_interval) | The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. For lambda target groups, it needs to be greater as the timeout of the underlying lambda. Default 30 seconds | `number` | `30` | no |
| <a name="input_healthcheck_path"></a> [healthcheck\_path](#input\_healthcheck\_path) | path en el cual se expone el servicio de health check | `string` | `"/health"` | no |
| <a name="input_healthcheck_port"></a> [healthcheck\_port](#input\_healthcheck\_port) | Puerto healthcheck para target group | `number` | `2000` | no |
| <a name="input_healthcheck_protocol"></a> [healthcheck\_protocol](#input\_healthcheck\_protocol) | protocolo de healthcheck de balanceador | `string` | `"TCP"` | no |
| <a name="input_healthcheck_timeout"></a> [healthcheck\_timeout](#input\_healthcheck\_timeout) | The amount of time, in seconds, during which no response means a failed health check. For Application Load Balancers, the range is 2 to 120 seconds, and the default is 5 seconds for the instance target type and 30 seconds for the lambda target type. For Network Load Balancers, you cannot set a custom value, and the default is 10 seconds for TCP and HTTPS health checks and 6 seconds for HTTP health checks. | `number` | `10` | no |
| <a name="input_load_balancer_arn"></a> [load\_balancer\_arn](#input\_load\_balancer\_arn) | arn del balanceador de red donde se expondra el servicio | `string` | n/a | yes |
| <a name="input_load_balancer_port"></a> [load\_balancer\_port](#input\_load\_balancer\_port) | id de la VPC donde esta al balanceador | `number` | n/a | yes |
| <a name="input_load_balancer_protocol"></a> [load\_balancer\_protocol](#input\_load\_balancer\_protocol) | Protocolo que se esa en el balanceador | `string` | `"tcp"` | no |
| <a name="input_metric_name"></a> [metric\_name](#input\_metric\_name) | metrica utilizada para el escalamiento (CPUUtilization, MemoryUtilization) | `string` | `"MemoryUtilization"` | no |
| <a name="input_microservice_count"></a> [microservice\_count](#input\_microservice\_count) | numero de instancias con las que arranca el microservicio | `number` | `1` | no |
| <a name="input_microservice_cpu"></a> [microservice\_cpu](#input\_microservice\_cpu) | CPU Asignada al microservicio default 256 | `number` | `256` | no |
| <a name="input_microservice_memory"></a> [microservice\_memory](#input\_microservice\_memory) | memoria asignada al microservicio default 512 | `number` | `512` | no |
| <a name="input_microservice_memory_reservation"></a> [microservice\_memory\_reservation](#input\_microservice\_memory\_reservation) | memoria reservada por el microservicio default 256 | `number` | `256` | no |
| <a name="input_network_mode"></a> [network\_mode](#input\_network\_mode) | Tipo de red que debe manejar la task | `string` | `"awsvpc"` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | Entidad a la que pertenece el recurso | `any` | n/a | yes |
| <a name="input_period"></a> [period](#input\_period) | Periodos tiempo entre periodos | `string` | `"60"` | no |
| <a name="input_private_subnet_id"></a> [private\_subnet\_id](#input\_private\_subnet\_id) | Lista de id de las subnets privadas | `list(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Proyecto para el cual se crea el recurso | `any` | n/a | yes |
| <a name="input_retention_in_days_logs"></a> [retention\_in\_days\_logs](#input\_retention\_in\_days\_logs) | tiempo que se retendran los logs en cloudwatch | `number` | `5` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | nombre del servicio a desplegar | `any` | n/a | yes |
| <a name="input_service_namespace"></a> [service\_namespace](#input\_service\_namespace) | service namespace usado en auto scaling group | `string` | `"ecs"` | no |
| <a name="input_service_port"></a> [service\_port](#input\_service\_port) | Puerto del contenedor del servicio | `any` | n/a | yes |
| <a name="input_sg_id"></a> [sg\_id](#input\_sg\_id) | security group del cluster donde se desplegara la task | `list(string)` | n/a | yes |
| <a name="input_store_in_s3"></a> [store\_in\_s3](#input\_store\_in\_s3) | se debe alamacenar en S3 | `bool` | `true` | no |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | target type del load balance | `string` | `"ip"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | id de la VPC donde esta al balanceador | `string` | n/a | yes |
| <a name="input_xray_repository"></a> [xray\_repository](#input\_xray\_repository) | Repositorio desde el cual se descargara la imagen de Xray | `string` | `"amazon/aws-xray-daemon"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
