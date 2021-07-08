#Expondo as informações ID, AMI e ARN no output

output "id" {
  value = "${aws_instance.web.id}"
}

output "ami" {
  value = "${aws_instance.ami}"
}

output "arn" {
  value = "${aws_instance.arn}"
}

