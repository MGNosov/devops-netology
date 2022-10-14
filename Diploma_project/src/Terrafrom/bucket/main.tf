terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = "AQAAAAAnxe1uAATuwbFCSoUwM0v_p5OSKy3TFf0"
  cloud_id  = "b1g9cb14mht57dso4pco"
  folder_id = "b1gi5ufjf161iudar0ce>"
  zone      = "ru-central1-a"
}

resource "yandex_storage_bucket" "test" {
  access_key = "YCAJEfgYIo7o_SSfZ-O-Tfwkj"
  secret_key = "YCN0n7ocw6ilLq1bVqDEXUTBQxBbNL8u-Ck3SQqI"
  bucket = "bin1989"
}