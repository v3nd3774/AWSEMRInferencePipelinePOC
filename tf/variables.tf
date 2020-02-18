variable "environment" {
  default = "Development"
}

variable "release_label" {
  default = "emr-5.29.0"
}

variable "applications" {
  default = ["Spark", "Hadoop"]
  type    = list
}

variable "key_name" {}

variable "bootstrap_args" {
  default = []
  type    = list
}

variable "projprefix" {
  default = "AWSEMRInferencePipelinePOC"
}

variable "tags" {
  default = {
    Project = "AWSEMRInferencePipelinePOC"
  }
}
