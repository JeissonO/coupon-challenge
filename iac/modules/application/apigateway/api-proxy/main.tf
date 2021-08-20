// Definicion de API
resource "aws_api_gateway_rest_api" "main" {
  name        = "${var.environment}-${var.project}-${var.resource}-proxy-api"
  description = "API Rest para el microservicio ${var.resource} del proyecto ${var.project}"
  endpoint_configuration {
    types = var.endpoint_type
  }
  policy = file("${path.module}/all-access-policy.json")

  tags = {
    Name         = "${var.environment}-${var.project}-${var.resource}-api"
    Environment  = var.environment
    Organization = var.organization
    Project      = var.project
    Resource     = var.resource
  }

  lifecycle {
    ignore_changes = [policy]
  }
}
// Definicion del recurso root
resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = var.path_part
}
// Definicion del recurso proxy
resource "aws_api_gateway_resource" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.root.id
  path_part   = var.proxy_part
}
// Definicion del authorizer que se  utilizara en la API
resource "aws_api_gateway_authorizer" "authorizer" {
  name                             = "${var.environment}-${var.project}-cognito-authorizer"
  provider_arns                    = var.provider_arns
  rest_api_id                      = aws_api_gateway_rest_api.main.id
  authorizer_result_ttl_in_seconds = 300
  identity_source                  = "method.request.header.Authorization"
  type                             = "COGNITO_USER_POOLS"
}
// definicion del metodo proxy
resource "aws_api_gateway_method" "main" {
  rest_api_id          = aws_api_gateway_rest_api.main.id
  resource_id          = aws_api_gateway_resource.main.id
  http_method          = "ANY"
  authorization        = "COGNITO_USER_POOLS"
  authorizer_id        = aws_api_gateway_authorizer.authorizer.id
  authorization_scopes = var.authorization_scopes
  request_parameters = {
    "method.request.path.proxy" = true
  }
}
// definicion del la integracion proxy
resource "aws_api_gateway_integration" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.main.id
  http_method = aws_api_gateway_method.main.http_method
  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
  type                    = var.integration_input_type
  uri                     = "http://${var.nlb_dns_name}:${var.app_port}/${var.path_part}/{proxy}"
  integration_http_method = var.integration_http_method
  connection_type         = "VPC_LINK"
  connection_id           = var.api_gateway_vpc_link_id
}
// definicino de stage de despliegue
resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = var.environment
  depends_on  = [aws_api_gateway_integration.main]
  variables = {
    resources = join(", ", [aws_api_gateway_resource.main.id])
  }
  lifecycle {
    create_before_destroy = true
  }
}
// Inicia definicion de recursos CORS
resource "aws_api_gateway_method" "method_resource_options" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.main.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}
// Metodo Option para CORS
resource "aws_api_gateway_method_response" "resource_options_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.main.id
  http_method = aws_api_gateway_method.method_resource_options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = [aws_api_gateway_method.method_resource_options]
}
// Definicion de MOCK de integracion de CORS
resource "aws_api_gateway_integration" "resource_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.main.id
  http_method = aws_api_gateway_method.method_resource_options.http_method
  type        = "MOCK"
  depends_on  = [aws_api_gateway_method.method_resource_options]

  request_templates = {
    "application/json" = <<EOF
      {
        "statusCode": 200
      }
      EOF
  }
}
// Respuesta asociada a MOCK
resource "aws_api_gateway_integration_response" "resource_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.main.id
  http_method = aws_api_gateway_method.method_resource_options.http_method
  status_code = aws_api_gateway_method_response.resource_options_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  response_templates = {
    "application/json" = <<EOF
EOF
  }
  depends_on = [aws_api_gateway_method_response.resource_options_200]
}
