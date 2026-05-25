
variable "name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "sg_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile name to attach to EC2"
  type        = string
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 20
}
