resource "aws_sns_topic" "this" { // Criando topic do sns
  name = "${var.sns_topic_name}"
  display_name = "S3 Data"
}

resource "aws_sns_topic_subscription" "this" { // Criando os subscriptions (usuario a receber notificações)
  topic_arn = "${aws_sns_topic.this.arn}" // Topic a ser usado
  protocol = "lambda"
  endpoint = "${aws_lambda_function.dynamo.arn}" // Endpoint da lamda dynamo
}