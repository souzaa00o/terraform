output "name" {
  value = aws_s3_bucket.this.id // expondo o nome do bucket para o modulo
}


output "object" {
  value = aws_s3_bucket_object.this.*.key // expondo o nome do objeto para o modulo
}