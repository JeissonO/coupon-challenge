output "eni_id" {
  description = "ID de la interfaz de red ENI de la NAT instance"
  value       = aws_network_interface.this.id
}
output "eni_private_ip" {
  description = "IP privada de la interfaz de red  ENI de la NAT instance"
  value       = tolist(aws_network_interface.this.private_ips)[0]
}
output "sg_id" {
  description = "ID del security group de la NAT instance"
  value       = aws_security_group.this.id
}
output "iam_role_name" {
  description = "Nombre del IAM role de la NAT instance"
  value       = aws_iam_role.this.name
}
