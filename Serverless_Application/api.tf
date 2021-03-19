resource "aws_api_gateway_rest_api" "this" { // Criando API
  name        = var.api_name
  description = var.api_description
}

resource "aws_api_gateway_resource" "this" {                   // Criando recurso API gateway
  rest_api_id = aws_api_gateway_rest_api.this.id               // Setando a API criada acima
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id // O "parent_id" é equivalente a "/" do endpoint
  path_part   = "todos"                                        // O primeiro parametro passado no Endpoint após o "/" ou "parent_id"
}

resource "aws_api_gateway_authorizer" "this" { // Autenticação da API 
  name          = "CognitoUserPoolAuthorizer"
  type          = "COGNITO_USER_POOLS"                  // Tipo de autorização no cognito, criado em "cognito.tf"
  rest_api_id   = aws_api_gateway_rest_api.this.id      // ID de API
  provider_arns = ["${aws_cognito_user_pool.this.arn}"] // providers
}

resource "aws_api_gateway_method" "any" {                 // Criando metodo
  rest_api_id          = aws_api_gateway_rest_api.this.id // API criada acima
  resource_id          = aws_api_gateway_resource.this.id // Recurso criado acima
  http_method          = "ANY"                            // Todos os metodos http
  authorization        = "COGNITO_USER_POOLS"
  authorizer_id        = aws_api_gateway_authorizer.this.id // Authorizer criado acima
  authorization_scopes = "${aws_cognito_resource_server.this.scope_identifiers}" // scope_identifiers: lista todos os escopos configurados no recurso
}

resource "aws_api_gateway_integration" "this" {                    // Integrando o metodo com nossa lambda
  rest_api_id             = aws_api_gateway_rest_api.this.id       // API criada acima
  resource_id             = aws_api_gateway_resource.this.id       // Recurso da API criado acima
  http_method             = aws_api_gateway_method.any.http_method // Metodo criado acima
  integration_http_method = "POST"                                 // Metodo "POST"
  type                    = "AWS_PROXY"                            // Atravez do proxy
  uri                     = aws_lambda_function.dynamo.invoke_arn  // Para invocar a lambda
}

resource "aws_api_gateway_deployment" "this" {       // Criando deploy
  rest_api_id = aws_api_gateway_rest_api.this.id     // Usando a API criada acima
  stage_name  = var.env                              // No ambiente desejado
  depends_on  = ["aws_api_gateway_integration.this"] // O recurso de deploy depende da integração "aws_api_gateway_integration.this" para ser executado
}
