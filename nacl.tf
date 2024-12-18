resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "main_nacl"
  }
}

# Associate Subnets with the NACL
resource "aws_network_acl_association" "public_1_association" {
  subnet_id      = aws_subnet.public_1.id
  network_acl_id = aws_network_acl.main.id
}

resource "aws_network_acl_association" "public_2_association" {
  subnet_id      = aws_subnet.public_2.id
  network_acl_id = aws_network_acl.main.id
}

resource "aws_network_acl_association" "private_1_association" {
  subnet_id      = aws_subnet.private_1.id
  network_acl_id = aws_network_acl.main.id
}

resource "aws_network_acl_association" "private_2_association" {
  subnet_id      = aws_subnet.private_2.id
  network_acl_id = aws_network_acl.main.id
}

# Allow inbound rules
resource "aws_network_acl_rule" "allow_http_inbound" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "allow_ssh_inbound" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "allow_dns_inbound" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 120
  egress         = false
  protocol       = "udp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 53
  to_port        = 53
}

resource "aws_network_acl_rule" "allow_ephemeral_inbound" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 130
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Allow outbound rules
resource "aws_network_acl_rule" "allow_dns_outbound" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 140
  egress         = true
  protocol       = "udp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 53
  to_port        = 53
}

resource "aws_network_acl_rule" "allow_ephemeral_outbound" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 150
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "allow_all_outbound" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 200
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}