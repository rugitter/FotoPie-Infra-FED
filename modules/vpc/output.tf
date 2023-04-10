output "vpc_id" {
  description = "The id of the custom vpc for our app"
  value = aws_vpc.main.id
}

output "public1_id" {
  description = "The id of the public subnet"
  value = aws_subnet.public_1.id
}

output "public2_id" {
  description = "The id of the public subnet"
  value = aws_subnet.public_2.id
}

output "private1_id" {
  description = "The id of the private subnet"
  value = aws_subnet.private_1.id
}