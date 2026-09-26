module "networking" {
  source = "./module/vpc"

}

module "security_groups" {
    source = "./module/security_groups"
    
  
}