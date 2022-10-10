# vpc setup
module "vpc" {
    source = "./modules/vpc"

    vpc_cidr  =  var.vpc_cidr
    project   = var.project
    subnet_cidr_bits = var.subnet_cidr_bits
    availability_zones_count = var.availability_zones_count
    tags    = var.tags


}
# RDS setup 
module "rds" {
    source = "./modules/rds"
    project   = var.project
    subnet_ids = module.vpc.private_subnet_id
    vpc_id    = module.vpc.vpc_id
}
# setup eks
module "eks" {
    source = "./modules/eks"
    vpc_id  =  module.vpc.vpc_id
    pub_subnet_ids = module.vpc.public_subnet_id
    pri_subnet_ids = module.vpc.private_subnet_id
    project   = var.project
    tags    = var.tags


}
# ECR repo setup
module "ecr" {
    source = "./modules/ecr"
    project   = var.project
}
# Code build
module "codebuild" {
    source = "./modules/codebuild"
    project = var.project
    repo_name = "${var.project}-repo"
    eks_cluster_name = "${var.project}-cluster"

}