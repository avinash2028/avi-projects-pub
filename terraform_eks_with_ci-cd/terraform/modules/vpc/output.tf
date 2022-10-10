output "vpc_id" {
    value = aws_vpc.sandboxvpc.id 
}
output "public_subnet_id" {
    value = aws_subnet.public[*].id
}
output "private_subnet_id" {
    value = aws_subnet.private[*].id

}
# output "public_subnet_id-2" {
#     value = aws_subnet.public.id[1]
# }
# output "private_subnet_id-2" {
#     value = aws_subnet.private.id[1]
# }