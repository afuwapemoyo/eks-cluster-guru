module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = "guru-vpc"

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}

# Use below for existing VPC
#module "vpc" {
  #source  = "terraform-aws-modules/vpc/aws"
  #version = "3.14.2"

  # Use existing VPC
  #vpc_id = "vpc-xxxxxxxx"  # Replace with your existing VPC ID

  # Existing subnets (replace with your existing subnet IDs)
  #private_subnets = [
    #"subnet-xxxxxxxx",  # Replace with your existing private subnet ID
    #"subnet-yyyyyyyy",  # Replace with another existing private subnet ID
  #]
  #public_subnets  = [
    #"subnet-zzzzzzzz",  # Replace with your existing public subnet ID
    #"subnet-aaaaaaaa",  # Replace with another existing public subnet ID
  #]

  # You don't need to define cidr, azs, or new subnet CIDR blocks since you are using existing resources
#}
