output "api_id" {
  value = aws_api_gateway_rest_api.main.id
}
output "api_root_resource_id" {
  value = aws_api_gateway_rest_api.main.root_resource_id
}
output "api_gateway_invoke_url" {
  value = aws_api_gateway_deployment.main.invoke_url
}
