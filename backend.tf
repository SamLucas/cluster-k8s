terraform {
  backend "s3" {
    region = "us-east-1"
    bucket = "k8s-backend-samuel"
    encrypt = "true"
    key = "terraform.tfstate"    
  }  
}
