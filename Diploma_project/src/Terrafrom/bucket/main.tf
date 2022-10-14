terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = "AQA************Ff0"
  cloud_id  = "b1g9cb14mht57dso4pco"
  folder_id = "b1gi5ufjf161iudar0ce>"
  zone      = "ru-central1-a"
}

resource "yandex_storage_bucket" "test" {
  access_key = "YCA**************wkj"
  secret_key = "YCN****************QqI"
  bucket = "bin1989"
}
