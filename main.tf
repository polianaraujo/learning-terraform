# Configurações do terraform
# Versão do terraform, versão de providers, backends, etc
terraform {
  required_version = "~> 1.14.0" # 1.14.0 até 1.14.n

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.19.0"
    }
  }
}


# Definir Configurações para determinados providers que estamos criando infraestrutura
provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      owner = "polianaraujo"
      managed-by = "terraform"
    }
  }
}


# bloco de recurso que cria e gerencia uma bucket na aws
# resource "aws_s3_bucket" "ref_aws_se_bucket" { }


# bloco de DataSource serve para nós irmos buscar alguma informação de algum recurso que não está sendo gerido pelo Terraform e que nós precisemos dessa informação para referenciar no nosso código ou para usar em algum momento dentro do código
# data "aws_instance" "name" { }


# grupo de recursos (nao referencia recursos, mas tem referência interna)
# module "name" { }


# variable "name_variavel" { }


# output "name" {
    # nao pode ter dois outputs com o mesmo nome e mesmo código }


# locals { }


# serve para nós importarmos determinado recurso para que o terraform gerencie aquele recurso que foi criado fora dele
#import { }


# mudar a referência interna que o terraform tem para determinado recurso
# moved { }


# nao quero que o terraform gerencie mais determinado recurso (sem destruir esse recurso)
# removed { }


# verificação determinada condição em determinado recurso no provider, que está sendo gerida ou não pelo terraform
# check "name" { }