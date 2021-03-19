locals {
  layer_name  = "terraform_layer.zip"                 // Nome da layer
  layers_path = "${path.module}/lambda-layers/nodejs" // Caminho de destino da layer
}

resource "null_resource" "build_lambda_layers" {                 // Null resource para buildar a layer
  triggers = {                                                     // Criação de trigger 
    layer_build = md5(file("${local.layers_path}/package.json")) // O null_resource sera disparado apenas em casos de alterações no arquivo "package.json", checado pela trigger
  }
  // Após o disparo da trigger acima o local-exec é executado
  provisioner "local-exec" {
    working_dir = local.layers_path
    command     = "npm install --production && cd ../ && zip -9 -r --quiet ${local.layer_name} *" // Instalando as dependencias npm e zipando o conteudo da pasta "local.layer_name"
  }
}

resource "aws_lambda_layer_version" "this" { // Criando o recurso lambda
  filename    = "${local.layers_path}/../${local.layer_name}"
  layer_name  = "terraform-layer"
  description = "joi: ^17.4.0" // dependencias usadas

  compatible_runtimes = ["nodejs8.10"] // Usando o node em tempo de execução

  depends_on = ["null_resource.build_lambda_layers"] // O recurso atual depende da execução do "null_resoure.build_lambda_layers"
}


#  ----- Lambda para DynamoDB -----
# Criação dos recursos do DynamoDB

data "archive_file" "dynamo" {
  type        = "zip"
  source_file = "${path.module}/lambdas/dynamo/index.js"     // executando o index.js
  output_path = "${path.module}/lambdas/dynamo/index.js.zip" // zipando o index.js
}

resource "aws_lambda_function" "dynamo" { // Criando a função da lambda para o Dynamo
  function_name = "dynamo"
  handler       = "index.handler"
  role          = aws_iam_role.dynamo.arn // Politica de acesso IAM atachado a lambda / Criado em "iam.tf"
  runtime       = "nodejs8.10"
  layers        = ["${aws_lambda_layer_version.this.layer_arn}"] // Layer criada acima em "aws_lambda_layer_version.this"

  filename         = data.archive_file.dynamo.output_path         // Output gerado pelo "data.archive_file.dynamo"
  source_code_hash = data.archive_file.dynamo.output_base64sha256 // Output gerado pelo "data.archive_file.dynamo"

  timeout     = 30
  memory_size = 128

  environment {
    variables = {                            // Setando variavel de ambiente
      TABLE = aws_dynamodb_table.this.name // Tabela criada em ".dynamo.tf"
    }
  }
}

resource "aws_lambda_permission" "dynamo" {      // Recurso de permissão para o dynamo
  statement_id  = "AllowExecutionFromAPIGateway" // Permitindo execuções vindas do APIGateway
  action        = "lambda:InvokeFunction"        // Definindo a ação ao ser executada / Execução da lambda
  function_name = aws_lambda_function.dynamo.arn // Nome da função
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.account_id}:*/*"
}


#  ----- Lambda para S3 ------
# Criação dos recursos do S3
data "archive_file" "s3" {
  type        = "zip"
  source_file = "${path.module}/lambdas/s3/index.js"
  output_path = "${path.module}/lambdas/s3/index.js.zip"
}

resource "aws_lambda_function" "s3" {
  function_name = "s3"
  handler       = "index.handler"
  role          = aws_iam_role.s3.arn
  runtime       = "nodejs8.10"
  layers        = ["${aws_lambda_layer_version.this.layer_arn}"]

  filename         = data.archive_file.s3.output_path
  source_code_hash = data.archive_file.s3.output_base64sha256

  timeout     = 30
  memory_size = 128

  environment {
    variables = {
      TOPIC_ARN = aws_sns_topic.this.arn
    }
  }
}

resource "aws_lambda_permission" "s3" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.todo.arn
}


resource "aws_lambda_permission" "sns" { // Recurso de permissão para o sns
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.dynamo.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.this.arn}"
}

