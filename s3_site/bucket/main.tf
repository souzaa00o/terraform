provider "aws" {
  region = "${var.region}"
}

data "template_file" "policy" { // Importando policy criada em "./templates/policy.json"
   template = "${file("templates/policy.json")}"  // Apontando para a policy

  vars = {
    "bucket_name" = "${var.domain}"   // Setando a variavel bucket_name usada em "./templates/policy.json" 
  } 
   
}
