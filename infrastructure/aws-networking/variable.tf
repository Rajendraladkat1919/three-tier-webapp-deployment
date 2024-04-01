variable "region" {
  type    = string
  default = "eu-central-1"

}

variable "availability_zones" {
  type    = list(any)
  default = ["eu-central-1a", "eu-central-1b"]

}