resource "aws_s3_bucket" "this" {
  bucket = var.name
  acl    = var.acl


  versioning {               // versionamento
    enabled = var.versioning // recebe true ou false via variavel
  }

  tags = var.tags

}

resource "aws_s3_bucket_object" "this" { // validação para criar objeto no bucket, o objeto deve ter todos esses atributos
  count  = var.create_object ? 1 : 0     //  caso o "create_object = true" ele retorna 1, caso contrario ele retorna 0
  bucket = aws_s3_bucket.this.id
  key    = var.object_key
  source = var.object_source
  etag   = md5(file(var.object_source))
}
 