variable "region" { // região de deploy
  default = "us-east-1"
}

variable "ami" { // imagem de S.O para ec2 
  default = "ami-047a51fa27710816e"
}

variable "instance_type" { // tipo de instancia
  default = "t2.micro"
}