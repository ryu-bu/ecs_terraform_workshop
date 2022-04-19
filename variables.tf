variable "key_name" {
  type        = string
  default     = "constellationjs"
  description = "The name for ssh key, used for aws_launch_configuration"
}

variable "cluster_name" {
  type        = string
  default     = "nona-research-foundation"
  description = "The name of AWS ECS cluster"
}