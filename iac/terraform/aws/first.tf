resource "aws_instance" "first" {

    ami = var.ami
    instance_type = var.first_instance_type

    subnet_id = aws_subnet.public_subnet_a.id
    associate_public_ip_address = true

    vpc_security_group_ids = [ 
        aws_security_group.first.id
    ]

    key_name = aws_key_pair.cluster_key.key_name

    tags = merge(var.tags, { 
        Name = format("first")
    })

}
