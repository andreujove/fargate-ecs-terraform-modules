# terraform {
#   backend "s3" {
#     bucket         = "mi-terraform-state-storage"
#     key            = "environments/dev/terraform.tfstate" # Ruta única para dev
#     region         = "us-east-1"
#     dynamodb_table = "terraform-lock"
#   }
# }