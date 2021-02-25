resource "aws_s3_bucket" "log" {  // Criação do Bucket de log
  bucket = "${var.domain}-logs"  // Dominio criado no Route 53
  acl = "log-delivery-write"   // Setando a função de escrita de log no bucket
}

resource "aws_s3_bucket" "site"{    // Criação do Bucket para hospedar o site
    bucket = "${var.domain}"        // Dominio criado no Route 53
    acl = "public-read"     // Setando permissão de leitura do bucket
    policy = "${data.template_file.policy.rendered}"   // Intanciando politica de acesso da função "data.template_file" criada acima

    website {   // Setando o index.html
        index_document = "index.html"   
        error_document = "index.html"
    }

    logging{    // habilitando log
        target_bucket = "${aws_s3_bucket.log.bucket}"   // para o bucket criado acima para log
        target_prefix = "${var.domain}" // Com o dominio criado no Route 53
    }
}

resource "aws_s3_bucket" "redirect" {   // redireciona as requisições com "www" para nosso dns
    bucket = "www.${var.domain}"  
    acl = "public-read"

    website {
      redirect_all_requests_to = "${var.domain}"
    }

    
}