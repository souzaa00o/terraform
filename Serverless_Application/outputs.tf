output "client_id" {
  value = "${aws_cognito_user_pool.this.id}"
}

output "client_secret" {
  value = "${aws_cognito_user_pool_client.this.client_secret}"
}

output "cg_domain" {
  value = "${aws_cognito_user_pool_domain.this.domain}"
}

output "cg_url" {
  value = "https://${aws_cognito_user_pool_domain.this.domain}.auth.us-east-1.amazoncognito.com"
}