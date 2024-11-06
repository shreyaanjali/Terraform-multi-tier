resource "aws_internet_gateway" "codepipeline-igw" {
            vpc_id = aws_vpc.main.id

            tags = {
                 Name = "codepipeline-igw"
            }
}

resource "aws_route_table" "codepipeline-route-table" {
            vpc_id = aws_vpc.main.id 

            route {
                cidr_block = "0.0.0.0/0"
                gateway_id = aws_internet_gateway.codepipeline-igw.id

            }

            tags = {
                Name = "codepipeline-coustm-route"
            }
            
}

resource "aws_route_table_association" "codepipeline-route-table" {
            subnet_id = aws_subnet.codepipeline-public-subnet.id
            route_table_id = aws_route_table.codepipeline-route-table.id

}

resource "aws_security_group" "ssh-allowed" {
          vpc_id = aws_vpc.main.id
          egress {
             from_port = 0
             to_port = 0
             protocol = -1
             cidr_blocks = ["0.0.0.0/0"]
          }
          ingress {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]

          }
          ingress {
             from_port = 80
             to_port = 80
             protocol = "tcp"
             cidr_blocks = ["0.0.0.0/0"]
          }
        tags = {
            Name = "codepipeline-security-group"
        }
}

