
### Provider

provider "aws" {
  region = var.aws_region
}

### Key pair

resource "aws_key_pair" "cluster_key" {
    key_name = format("%s-key", var.project_name)
    public_key = file(var.aws_key_path)
    tags = var.tags
}

### Security group

resource "aws_security_group" "aio-sg" {

    name        = format("%s-sg", var.project_name)

    vpc_id      = aws_vpc.cluster_vpc.id

    ingress {
        from_port   = "22"
        to_port     = "22"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = "3000"
        to_port     = "3000"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = "8000"
        to_port     = "8000"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

#    ingress {
#        from_port   = "443"
#        to_port     = "443"
#        protocol    = "tcp"
#        cidr_blocks = ["0.0.0.0/0"]
#    }
#
#    ingress {
#        from_port = 0
#        to_port = 65535
#        protocol = "tcp"
#        self = true
#        description = "nodes"
#    }
#
#    ingress {
#        from_port = 0
#        to_port = 65535
#        protocol = "udp"
#        self = true
#        description = "nodes"
#    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(var.tags, { 
        Name = format("%s-sg", var.project_name)
    })


}

### Instance

resource "aws_instance" "webodm" {

    ami = var.ami
    instance_type = var.instance_type
    availability_zone = "us-east-1a"

    subnet_id = aws_subnet.public_subnet_a.id
    associate_public_ip_address = true

    vpc_security_group_ids = [ 
        aws_security_group.aio-sg.id
    ]

    key_name = aws_key_pair.cluster_key.key_name

    tags = merge(var.tags, { 
        Name = format("webodm")
    })

}

### Elatic Block Service (EBS)

resource "aws_ebs_volume" "webodm-data" {

    availability_zone = "us-east-1a"
    type = "gp2"
    size = 80

    tags = merge(var.tags, {
        Name = "webodm-data"
    })

}

### Volume attachment

resource "aws_volume_attachment" "ebs_att" {

    device_name = "/dev/xvdb"
    volume_id   = aws_ebs_volume.webodm-data.id
    instance_id = aws_instance.webodm.id

}

### Virtual Private Cloud (VPC) subnet

resource "aws_vpc" "cluster_vpc" {
    cidr_block = "12.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = merge(var.tags, { Name = format("%s-vpc", var.project_name) })
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.cluster_vpc.id
  tags = {
    Name = format("%s-igw", var.project_name)
  }
}

# Route to Internet Gateway
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.cluster_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

### Routes

resource "aws_subnet" "public_subnet_a" {
    vpc_id                  = aws_vpc.cluster_vpc.id
    cidr_block              = "12.0.16.0/20"
    map_public_ip_on_launch = true
    availability_zone       = format("%sa", var.aws_region)

    tags = merge(var.tags, { 
        Name = format("%s-public-%sa", var.project_name, var.aws_region)
    })
}

# Associate subnet public_subnet_cluster_1a to public route table
resource "aws_route_table_association" "public_subnet_cluster_1a_association" {
    subnet_id      = aws_subnet.public_subnet_a.id
    route_table_id = aws_vpc.cluster_vpc.main_route_table_id
}

###### CLUSTER OPTIONS  ######

# Customize the Cluster Name
variable "project_name" {
    description = "Cluster Name"
    default     = "webodm-aio"
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
    default     = "key-aio.pub"
}

# Tags
variable "tags" {
    default = {
        project       = "learning-iac"
        enviroment    = "prod"
    }
}

#
variable "instance_type" {
    description = "VM instance type"
    default     = "t2.nano"
}

