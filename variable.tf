# application name 
variable "app_name" {
  type = string
  description = "The service name used to build resources"
  default = "tag"
}
# application or company environment
variable "environment" {
  type = string
  description = "The environment to be built"
  default = "git"
}
# market 
variable "market" {
  type = string
  description = "The market"
  default = "its"
}

# role assignment - reader 
variable "role_reader" {
  type = string
  description = "Azure Role Assignment"
  default = "reader"
}
# role assignment - tag contributor 
variable "role_tag" {
  type = string
  description = "Azure Role Assignment"
  default = "tag contributor"
}

