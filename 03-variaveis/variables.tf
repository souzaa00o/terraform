variable "ami" {
  default = "ami-047a51fa27710816e"     // Imagem de S.O para criação da instancia EC2
}

variable "type" {
    // O campo segue vazio por ser dinamico, o valor de "type" se encontra nos arquivos "dev.tfvars" && "prd.tfvars
}


      // Varivel de tipo "list", foi comentada, pois os IPs abaixo são ficticios
# variable "ips" {
#   type = "list"
#   default = ["192.168.0.1","192.168.0.15"]
# }

     // Variavel de mapeamento
variable "tags" {
  type = "map"
  default = {
      "Name" = "Server Test"
      "Env" = "Dev"
  }
}