terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  
  backend "s3" {
   endpoint = "storage.yandexcloud.net"
   bucket = "bin1989"
   region = "ru-central1"
   key = "~/terraform.tfstate"
   access_key = "YCA***************wkj"
   secret_key = "YCN**********************QqI"
  
   skip_region_validation = true
   skip_credentials_validation = true
  }
}


provider "yandex" {
  token = "AQA*********************Ff0"
  cloud_id  = "b1g9cb14mht57dso4pco"
  folder_id = "b1gi5ufjf161iudar0ce"
  zone = "ru-central1-a"
}
