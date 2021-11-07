
################################
###### QUICK EDIT'S HERE  ######
################################

###### CLUSTER OPTIONS  ######

# Customize the Cluster Name
variable "project_name" {
    description = "Cluster Name"
    default     = "first"
}

variable "ami" {
    description = "Debian 10 Buster AMI"
    default = "ami-0d910fe71cfc09ca6"
}

# Customize your AWS Region
variable "aws_region" {
    description = "AWS Region for the VPC"
    default     = "us-east-1"
}

# Customize your key path
variable "aws_key_path" {
    description = "key_path"
    default     = "first.pub"
}

# Tags
variable "tags" {
    default = {
        Project       = "learning-iac"
        enviroment    = "prod"
    }
}

################################
######    KUBERNETES   #########
################################

variable "first_instance_type" {
    description = "VM instance type"
    default     = "t2.nano"
}

