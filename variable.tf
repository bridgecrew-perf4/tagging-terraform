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
  description = "The slalom market"
  default = "its"
}