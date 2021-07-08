output "remote_state_bucket_name" {
  value = "${module.bucket.name}" // Expondo o nome do bucket no output
}

# output "remote_state_bucket_arn" {
#   value = "${module.bucket.arn}"        // Expondo a ARN do bucket no output 
# }