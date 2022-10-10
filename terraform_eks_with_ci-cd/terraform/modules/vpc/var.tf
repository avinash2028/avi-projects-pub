variable "availability_zones_count" {
  description = "The number of AZs."
  type        = number
  default     = 2
}

variable "project" {}

variable "vpc_cidr" {}

variable "subnet_cidr_bits" {}

variable "tags" {
}