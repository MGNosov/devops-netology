# devops-netology
Studying repository for DevOps Engineering Course.

Editing file README.md favourite way.

#Не уверен, что сделал данную задачу правильно.

         # Local .terraform directories

**/.terraform/*. - игнорирует только директорию .terraform. Всё что выше и ниже индексируется.




# .tfstate files

*.tfstate - игнорируются файлы с расширением .tfstate

*.tfstate.* - ??? (если не сложно, могли бы вы подсказать, как работает данное правило. Заранее большое спасибо)




# Crash log files

crash.log - исключаются файлы из всех каталогов с именем crash.log




# Exclude all .tfvars files, which are likely to contain sentitive data, such as

# password, private keys, and other secrets. These should not be part of version

# control as they are data points which are potentially sensitive and subject

# to change depending on the environment.

#

*.tfvars - исключаются все файлы из всех каталогов репозитория с расширением .tfvars




# Ignore override files as they are usually used to override resources locally and so

# are not checked in

override.tf - исключаются файлы override.tf

override.tf.json - исключаются файлы override.tf.json

*_override.tf - исключаются файлы имеющие в имени _override с расширением .tf

*_override.tf.json - исключаются файлы имеющие в имени _override с расширением .tf.json




# Include override files you do wish to add to version control using negated pattern

#

# !example_override.tf - данный файл является исключением в игнорировании




# Include tfplan files to ignore the plan output of command: terraform plan -out=tfplan

# example: *tfplan* - ???




# Ignore CLI configuration files

.terraformrc - файлы с расширением .terraformrс игнорируются

terraform.rc - файлы terraform.rc игнорируются.

newly added line.
