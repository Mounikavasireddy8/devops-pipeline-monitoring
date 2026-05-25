output "app_url" {
  value = "http://${aws_instance.web.public_ip}"
}

output "prometheus_url" {
  value = "http://${aws_instance.web.public_ip}:9090"
}

output "grafana_url" {
  value = "http://${aws_instance.web.public_ip}:3000"
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

output "ssh_command" {
  value = "ssh -i ~/Desktop/cloudops-key.pem ec2-user@${aws_instance.web.public_ip}"
}