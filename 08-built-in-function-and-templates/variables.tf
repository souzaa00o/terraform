variable "region" {
  # type = "map(string)"

  default = {
    "dev" = "us-east-1"
    "prd" = "sa-east-1"
  }
}

variable "env" {

}
