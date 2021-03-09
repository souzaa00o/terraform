###################
### AWS COGNITO ###
###################

resource "aws_cognito_user_pool" "this" {
  name = "${var.cg_pool}"
}

resource "aws_cognito_user_pool_client" "this" {    // Criação do Client ognito
  name = "${var.cg_client}"
  user_pool_id = "${aws_cognito_user_pool.this.id}"
  generate_secret = true
// Permições Oauth
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows = [ "client_credentials" ]
  allowed_oauth_scopes = "${aws_cognito_resource_server.this.scope_identifiers}" // scope_identifiers: lista todos os escopos configurados no recurso
}

resource "aws_cognito_user_pool_domain" "this" {    // Criação de dns da aplicação
  domain = "${var.cg_domain}-${random_id.bucket.dec}"
  user_pool_id = "${aws_cognito_user_pool.this.id}"
}

resource "aws_cognito_resource_server" "this" { // Escopo de CRUD
  identifier = "${var.cg_client}"
  name = "${var.cg_client}"

  scope {
    scope_name = "read_todo"
    scope_description = "Read todos"
  }

  scope {
    scope_name = "create_todo"
    scope_description = "Create todos"
  }

  scope {
    scope_name = "delete_todo"
    scope_description = "Delete todos"
  }

  user_pool_id = "${aws_cognito_user_pool.this.id}"
}