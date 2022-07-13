variable "yandex_cloud_id" {
  default = "b1g9cb14mht57dso4pco"
}

variable "yandex_folder_id" {
  default = "b1gi5ufjf161iudar0ce"
}

variable "centos-7-base" {
  default = "fd8u69ls2rjrcbhdllg9"
}

variable "instances" {
  description = "Map of project names to configuration."
  type        = map
  default     = {
    node_1 = {
      instance_type           = "t2.large",
      name                    = "node01"
    },
    node_2 = {
      instance_type           = "t2.micro",
      name                    = "node02"
    }
  }
}