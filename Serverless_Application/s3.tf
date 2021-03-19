resource "aws_s3_bucket" "todo" { // Criando bucket
  bucket = "myBucket-todo-${random_id.bucket.hex}"
}

resource "aws_s3_bucket_notification" "lambda" { // Notification
  bucket = aws_s3_bucket.todo.id                 // Para o bucket criado acima "aws_s3_bucket.todo"

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3.arn // chamando a função da lambda s3 criada em "lambda.tf"
    events              = ["s3:ObjectCreated:*"]     // Para todo objeto criado, o lambda function invoca a lambda
  }
}
