resource "aws_vpc" "main" {
       cidr_block = "10.0.0.0/16"
       enable_dns_support = "true"
       enable_dns_hostnames = "true"
       instance_tenancy = "default"

       tags = {
          Name = "codepipeline-vpc-by-terraform"
       }

}

resource "aws_subnet" "codepipeline-public-subnet" {
           vpc_id = aws_vpc.main.id
           cidr_block = "10.0.0.0/24"
           map_public_ip_on_launch = "true"
           availability_zone = "us-east-1a"

           tags = {
              Name = "codepipeline-public-ec2-by-terraform"
           }       
}

resource "aws_key_pair" "key-tf" {
        key_name = "key-tf"
        public_key = file("${path.module}/id_rsa.pub")
}

resource "aws_instance" "web" {
         ami = "ami-0866a3c8686eaeeba"
         instance_type = "t2.small"
         key_name = "${aws_key_pair.key-tf.key_name}"
         vpc_security_group_ids = [aws_security_group.ssh-allowed.id]
         subnet_id = aws_subnet.codepipeline-public-subnet.id
         associate_public_ip_address = "true"

         tags = {
            Name = "codepipeline-ec2-by-terraform"
         }

        provisioner "remote-exec" {
               inline = [
                  "sudo apt-get update -y",
                  "sudo apt-get install -y apache2",
                  "sudo systemctl start apache2"
               ]

            connection {
                type = "ssh"
                user = "ubuntu"
                private_key = file("${path.module}/id_rsa")
                host = aws_instance.web.public_ip
            }
        }

}

    



