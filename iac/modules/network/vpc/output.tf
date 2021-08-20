output "vpc_id" {
  description = "vpc id"
  value       = aws_vpc.main.id
}
output "private_subnet_ids" {
  description = "list of private subnets id's"
  value       = aws_subnet.private.*.id
}
output "public_subnet_ids" {
  description = "list of public subnets id's"
  value       = aws_subnet.public.*.id
}
output "private_route_table_id" {
  description = "private route table id"
  value       = aws_route_table.private.id
}
output "public_route_table_id" {
  description = "public route table id"
  value       = aws_route_table.public.id
}