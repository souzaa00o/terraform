# ----- Recursos IAM DynamoDB -----

resource "aws_iam_role" "dynamo" { // Criando a Role
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole" 
    }
  ]
}
EOF
}


data "aws_iam_policy_document" "dynamo" { // Criando documento json da policy
  statement {                             // Permissões dynamo
    sid       = "AllowDynamoPermissions"
    effect    = "Allow"        // Permissão
    resources = ["*"]          // para todos os recursos
    actions   = ["dynamodb:*"] // Do dynamo
  }

  statement { // Permissões chamada de lambda
    sid       = "AllowInvokingLambdas"
    effect    = "Allow"
    resources = ["arn:aws:lambda:*:*:function:*"]
    actions   = ["lambda:InvokeFunction"]
  }

  statement { // Permissões para criação grupos de logs
    sid       = "AllowCreatingLogGroups"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
    actions   = ["logs:CreateLogGroup"]
  }

  statement { // Permissões de escrita de logs
    sid       = "AllowWritingLogs"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:log-group:/aws/lambda/*:*"]
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}


resource "aws_iam_policy" "dynamo" {                // Definindo policy
  policy = data.aws_iam_policy_document.dynamo.json // Policy criada acima em "data.aws_iam_policy_document.dynamo"
}

resource "aws_iam_role_policy_attachment" "dynamo" { // Atachando policy na role
  policy_arn = aws_iam_policy.dynamo.arn
  role       = aws_iam_role.dynamo.name
}


# ----- Recursos S3 Bucket -----

resource "aws_iam_role" "s3" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "s3" {
  statement {
    sid       = "AllowS3Permissions"
    effect    = "Allow"
    resources = ["*"]

    actions = [ // As permissões declaradas acima, se aplicam aos dois recursos passados em actions, S3 e SNS
      "s3:*",   // Recurso S3
      "sns:*",  // Recurso SNS
    ]
  }

  statement {
    sid       = "AllowInvokingLambdas"
    effect    = "Allow"
    resources = ["arn:aws:lambda:*:*:function:*"]
    actions   = ["lambda:InvokeFunction"]
  }

  statement {
    sid       = "AllowCreatingLogGroups"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
    actions   = ["logs:CreateLogGroup"]
  }

  statement {
    sid       = "AllowWritingLogs"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:log-group:/aws/lambda/*:*"]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}


resource "aws_iam_policy" "s3" {
  policy = data.aws_iam_policy_document.s3.json
}

resource "aws_iam_role_policy_attachment" "s3" {
  policy_arn = aws_iam_policy.s3.arn
  role       = aws_iam_role.s3.name
}
