variable "key_name" {
  description = "AWS key pair name (the .pem file stays local; Terraform needs the key pair name)"
  type        = string
  default     = "my-key"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "c7i-flex.large"
}

variable "ami_id" {
  description = "AMI to use for all instances"
  type        = string
  default     = "ami-0b5a4e51202cd98e5"
}

