output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}
  
output "vpc_database_subnets" {
  value = module.vpc.database_subnets
}
  
output "vpc_database_subnet_groups" {
  value = module.vpc.database_subnet_group
}
  
output "vpc_cidr" {
  value = module.vpc.vpc_cidr_block
}
