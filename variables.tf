variable "rg_name" {
  type    = string
  default = "NOTEJAM-DEMO-RG"
}
variable "location" {
  type    = string
  default = "westeurope"
}

variable "db_server" {
  type    = string
  default = "kknotejamdb"
}
variable "admin_login" {
  type    = string
  default = "sqladmin"
}
variable "admin_pwd" {
  type    = string
  default = "Microsoft2020"
}
variable "db_name" {
  type    = string
  default = "pollsdb"
}
variable "app_plan" {
  type    = string
  default = "kknotejamappplan"
}
variable "app_name" {
  type    = string
  default = "kknotejamapp"
}