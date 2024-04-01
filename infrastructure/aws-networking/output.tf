output "vpc_id" {
    description = "The id of vpc"
    value = module.vpc.vpc_id 
  
}

output "private_subnets_id" {
    description = "List of private subnets"
    value = module.vpc.private_subnets
  
}

output "vpc_owner_id" {
    value = module.vpc.vpc_owner_id
}