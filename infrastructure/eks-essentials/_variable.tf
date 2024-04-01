variable "region" {
  type    = string
  default = "eu-central-1"

}

variable "vpc_id" {
  type    = string
  default = "web-app-vpc"

}

variable "availability_zones" {
  type    = list(any)
  default = ["us-west-2a", "us-west-2b"]
}

variable "cluster_name" {
  type    = string
  default = "demp-webapp"
}

variable "cluster_version" {
  type    = number
  default = 1.28
}

variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))

  default = [
    {
      name    = "kube-proxy"
      version = "v1.25.6-eksbuild.1"
    },
    {
      name    = "vpc-cni"
      version = "v1.12.2-eksbuild.1"
    },
    {
      name    = "coredns"
      version = "v1.9.3-eksbuild.2"
    },
    {
      name    = "aws-ebs-csi-driver"
      version = "v1.23.0-eksbuild.1"
    }
  ]
}