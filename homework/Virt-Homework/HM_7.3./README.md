# Домашнее задание к занятию "7.3. Основы и принцип работы Терраформ" Носов Максим

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно).

Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием
терраформа и aws. 

1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя,
а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано 
[здесь](https://www.terraform.io/docs/backends/types/s3.html).
2. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше. 
##### Результат (Yandex Cloud)
<img align="cetner" src=https://github.com/MGNosov/devops-netology/blob/main/homework/Virt-Homework/HM_7.3./img/img00.png>


## Задача 2. Инициализируем проект и создаем воркспейсы. 

1. Выполните `terraform init`:
    * если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице 
dynamodb.
    * иначе будет создан локальный файл со стейтами.  
1. Создайте два воркспейса `stage` и `prod`.
1. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах 
использовались разные `instance_type`.
1. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два. 
1. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.
1. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
жизненного цикла `create_before_destroy = true` в один из рессурсов `aws_instance`.
1. При желании поэкспериментируйте с другими параметрами и рессурсами.

В виде результата работы пришлите:
* Вывод команды `terraform workspace list`.
###### Результат
````
(venv) mgnosov@Maksims-MacBook-Pro src % terraform workspace new stage
Created and switched to workspace "stage"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
(venv) mgnosov@Maksims-MacBook-Pro src % terraform workspace new prod 
Created and switched to workspace "prod"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
(venv) mgnosov@Maksims-MacBook-Pro src % terraform workspace list
  default
* prod
  stage
````
* Вывод команды `terraform plan` для воркспейса `prod`.  
##### Результат
````
 mgnosov@Maksims-MacBook-Pro src % terraform workspace list
  default
* prod
  stage

(venv) mgnosov@Maksims-MacBook-Pro src % terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.node01[0] will be created
  + resource "yandex_compute_instance" "node01" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "node01.netology.cloud"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDkPdIzuRtHtJlVm1T8KdF5t4fbyjSupXFTh/zVb1qN+PB8IgTOt80FyES3mE0Ef6CDNZJeGQjRK+TggmorVgi07Ft0Jk5W9n6Yb21ZtidXtpaje/kACP1iQGKOiC4atRUmcsp5obonbZ7uHUojkAo3pgViQ0V7mLDwC9NXW24qXJQJpGi04ZDTxu7YugdnFc7UDQWmeFZnYAdLu4hIP/vzQi40qtsAIW44kOhw+dLP4bW20TPKuMI06PxgApNgUnTnvbDDHlpgeycIRnNNA9NshG9ZCwYPwsxAYmrWkrvWeg6oQixv9ug3opdyc4eNH2oKoHOuIitbbOJYOFKZ6mzjBwOR8ce6AlkqzS/7WMpgOCJYvaie9XET4+NJeuA2rGMol6G+eJLHbZxXXYmYBujoG1LT2u9YZp5uQUg7CT9MEe2PYuaelNU6XaBGF3JjU8JSJarpdZZtf2Y+adb/yx+VmDtoHadCRC8J6/4oCq1ddlGiEdqOyWf6+hT/SdEfMGk= root@Maksims-MacBook-Pro.local
            EOT
        }
      + name                      = "node01"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8u69ls2rjrcbhdllg9"
              + name        = "root-node01"
              + size        = 20
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 8
          + memory        = 8
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.node01[1] will be created
  + resource "yandex_compute_instance" "node01" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "node01.netology.cloud"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDkPdIzuRtHtJlVm1T8KdF5t4fbyjSupXFTh/zVb1qN+PB8IgTOt80FyES3mE0Ef6CDNZJeGQjRK+TggmorVgi07Ft0Jk5W9n6Yb21ZtidXtpaje/kACP1iQGKOiC4atRUmcsp5obonbZ7uHUojkAo3pgViQ0V7mLDwC9NXW24qXJQJpGi04ZDTxu7YugdnFc7UDQWmeFZnYAdLu4hIP/vzQi40qtsAIW44kOhw+dLP4bW20TPKuMI06PxgApNgUnTnvbDDHlpgeycIRnNNA9NshG9ZCwYPwsxAYmrWkrvWeg6oQixv9ug3opdyc4eNH2oKoHOuIitbbOJYOFKZ6mzjBwOR8ce6AlkqzS/7WMpgOCJYvaie9XET4+NJeuA2rGMol6G+eJLHbZxXXYmYBujoG1LT2u9YZp5uQUg7CT9MEe2PYuaelNU6XaBGF3JjU8JSJarpdZZtf2Y+adb/yx+VmDtoHadCRC8J6/4oCq1ddlGiEdqOyWf6+hT/SdEfMGk= root@Maksims-MacBook-Pro.local
            EOT
        }
      + name                      = "node01"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8u69ls2rjrcbhdllg9"
              + name        = "root-node01"
              + size        = 20
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 8
          + memory        = 8
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_vpc_network.default will be created
  + resource "yandex_vpc_network" "default" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "net"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.default will be created
  + resource "yandex_vpc_subnet" "default" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.101.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 4 to add, 0 to change, 0 to destroy.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
````
[Конфигурационный файл](https://github.com/MGNosov/devops-netology/blob/main/homework/Virt-Homework/HM_7.3./src/main.tf)
---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
