## DYNAMODB ##

resource "aws_dynamodb_table" "this" { // Criando recurso tabela do DynamoDB
  name = "${var.dbname}"
  read_capacity = "${var.read_capacity}" // numero de unidades lidas na tabela
  write_capacity = "${var.write_capacity}" // numero de unidades gravadas na tabela
  hash_key = "TodoId"  // Hash key/Primary key da tabela

  attribute {
    name = "TodoId"
    type = "S"  // S == String
  }

  tags = {
      Name = "${var.dbname}"
      Enviroment = "${var.env}"
  }
}

resource "aws_dynamodb_table_item" "this" {  // Criando recurso de item na tabela referenciada logo abaixo
  table_name = "${aws_dynamodb_table.this.name}" // Tabela destino para a criação do item "aws_dynamodb_table.this" (tabela criada acima)
  hash_key = "${aws_dynamodb_table.this.hash_key}" // hash_key da tabela destino para criação do item 

    // Criando item para tabela destino
  item = <<ITEM
  {
      "TodoId": {"S":"1"},
      "Task": {"S": "Aprender Terraform"},
      "Done": {"S":"0"}
  }
  ITEM
}