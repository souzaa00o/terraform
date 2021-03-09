variable "region" {
  default = "us-east-1"
}

variable "account_id" {
  default = ""
}

variable "env" {
  default = "dev"
}

variable "cg_pool" {
  default = "Todos"
} 

variable "cg_client" {
    default = "todos-app-client"
}

variable "cg_domain" {
  default = "todos-api"
}