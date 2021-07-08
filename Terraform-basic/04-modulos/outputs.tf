## Os outputs são informações a serem exibidas na console


output "bucket_1" {
  value = module.bucket.name // As informações são puxadas do modulo "name", declarado em "./s3/outputs.tf"
}

output "bucket_1_object" {
  value = module.bucket.object // As informações são puxadas do modulo "object", declarado em "./s3/outputs.tf"
}

output "bucket_2" {
  value = module.bucket.name // As informações são puxadas do modulo "name", declarado em "./s3/outputs.tf"
}