##############################
# Security Group
##############################

# modeled after sg-0958fe906cc9ac79c - awseb-e-ad7wfz6i5j-stack-AWSEBSecurityGroup-1V018GNXFYB0N
resource "aws_security_group" "katalon-testops-io-production-waf-sg" {
  description = "Katalon Testops IO Production WAF Security Group"
  name        = "katalon-testops-io-production-waf-sg"
  tags        = {
    Type             = "production"
    environment-name = "katalon-testops-io-production-waf"
    Project          = "TestOps"
    Name             = "katalon-testops-io-production-waf"
    System           = "testops"
  }
  # vpc_id = "vpc-5b67113c"
  vpc_id      = module.vpc.vpc_id

  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
}

# have to add self to policy
resource "aws_security_group_rule" "katalon-testops-io-production-waf-sg-internal" {
  description       = "Alllow The same security group"
  from_port         = 5000
  protocol          = "-1"
  security_group_id = aws_security_group.katalon-testops-io-production-waf-sg.id
  # source_security_group_id = aws_security_group.katalon-testops-io-production-waf-sg.id
  self              = true
  to_port           = 5000
  type              = "ingress"
}


#modeled after sg-0dce0161262038fa8
resource "aws_security_group" "katalon-tools-sg" {
  description = "For monitoring system , sonar ..."
  name        = "Katalon-Tools"
  tags        = merge({ Name = "Katalon-Tools" }, var.tags)
  # vpc_id = "vpc-5b67113c" # production TEstops main
  vpc_id      = module.vpc.vpc_id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }
  ingress {
    ipv6_cidr_blocks = [
      "::/0"
    ]
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
  }
  ingress {
    cidr_blocks = [
      "125.212.208.58/32"
    ]
    description = "KMS Offices"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
  ingress {
    cidr_blocks = [
      "192.168.0.0/16"
    ]
    description = "Katalon VPC Private subnet"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
  ingress {
    cidr_blocks = [
      "52.205.13.69/32"
    ]
    description = "Katalon VPN"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
  ingress {
    cidr_blocks = [
      "52.45.203.41/32"
    ]
    description = "NAT GW1"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
  ingress {
    cidr_blocks = [
      "52.203.34.201/32"
    ]
    description = "NAT GW2"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
  ingress {
    cidr_blocks = [
      "35.172.81.5/32"
    ]
    description = "NAT GW3"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
  /*
  ingress {
    security_groups = [
      # "sg-05f5cc91e18b740eb" # k8s
      aws_security_group.kubernetes-testops-k8s-security-group.id
    ]
    protocol        = "-1"
    from_port       = 0
    to_port         = 0
  }
*/

  ingress {
    security_groups = [
      # "sg-2978b453"  # default vpc sg
      module.vpc.default_security_group_id
    ]
    description     = "Default"
    protocol        = "-1"
    from_port       = 0
    to_port         = 0
  }

  ingress {
    cidr_blocks = [
      "13.107.6.0/24"
    ]
    description = "Azure"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }
  ingress {
    cidr_blocks = [
      "13.107.9.0/24"
    ]
    description = "Azure"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }
  ingress {
    cidr_blocks = [
      "13.107.42.0/24"
    ]
    description = "Azure"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }
  ingress {
    cidr_blocks = [
      "13.107.43.0/24"
    ]
    description = "Azure"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }
  ingress {
    cidr_blocks = [
      "13.107.6.175/32"
    ]
    description = "Azure ExpressRoute"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }
  ingress {
    cidr_blocks = [
      "13.107.6.176/32"
    ]
    description = "Azure ExpressRoute"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }
  ingress {
    cidr_blocks = [
      "13.107.6.183/32"
    ]
    description = "Azure ExpressRoute"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }
  ingress {
    cidr_blocks = [
      "13.107.9.175/32"
    ]
    description = "Azure ExpressRoute"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }
  ingress {
    cidr_blocks = [
      "13.107.43.20/32"
    ]
    description = "Azure ExpressRoute"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }
  ingress {
    cidr_blocks = [
      "13.107.42.20/32"
    ]
    description = "Azure ExpressRoute"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }
  ingress {
    ipv6_cidr_blocks = [
      "::/0"
    ]
    from_port        = 443
    protocol         = "tcp"
    to_port          = 443
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port   = 2049
    protocol    = "tcp"
    to_port     = 2049
  }
  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
}

resource "aws_security_group_rule" "katalon-tools-sg-internal" {
  description       = "Alllow The same security group"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.katalon-tools-sg.id
  # source_security_group_id = aws_security_group.katalon-tools-sg.id
  self              = true
  to_port           = 0
  type              = "ingress"
}

resource "aws_security_group" "katalon-analytics-rds-sg" {
  # resource "aws_security_group" "EC2SecurityGroup2" {
  # modeled from sg-4ade5a3a	rds-launch-wizard-1
  description = "Katalon Analytics RDS Security Group"
  name        = "Katalon Analytics RDS Security Group"
  tags        = {
    Name = "Katalon Analytics RDS Security Group"
  }
  #vpc_id = "vpc-5b67113c"
  vpc_id      = module.vpc.vpc_id

  ingress {
    cidr_blocks = [
      "192.168.0.0/16"
    ]
    description = "Allow VPC TestOps Local"
    from_port   = 5432
    protocol    = "tcp"
    to_port     = 5432
  }

  #ingress {
  #  security_groups = [
  #    "sg-031d7a73" # katalon-analytics-production
  #  ]
  #  description = "EBS"
  #  from_port = 5432
  #  protocol = "tcp"
  #  to_port = 5432
  #}
  ingress {
    security_groups = [
      aws_security_group.vpn-security-group.id
    ]
    description     = "VPN"
    from_port       = 5432
    protocol        = "tcp"
    to_port         = 5432
  }
  ingress {
    cidr_blocks = [
      "192.168.0.0/16"
    ]
    description = "LocalVPC"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
  ingress {
    cidr_blocks = [
      "52.205.13.69/32"
    ]
    description = "Katalon VPN"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
  ingress {
    cidr_blocks = [
      "125.212.208.58/32"
    ]
    description = "KMS Offices"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
  ingress {
    cidr_blocks = [
      "172.21.0.0/16"
    ]
    description = "Management VPC"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
}

# resource "aws_security_group" "EC2SecurityGroup3" {
resource "aws_security_group" "vpn-security-group" {
  # taken from sg-02bb03a6f80119200 - VPN
  description = "VPN Security Group"
  name        = "VPN"
  tags        = {
    Name = "Katalon-VPN"
  }
  # vpc_id = "vpc-5b67113c"
  vpc_id      = module.vpc.vpc_id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    description = "Public VPN 80"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }
  ingress {
    security_groups = [
      aws_security_group.vpn-sg.id
    ]
    description     = "vpn-sg"
    protocol        = "-1"
    from_port       = 0
    to_port         = 0
  }

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    description = "Public VPN UDP 1194"
    from_port   = 1194
    protocol    = "udp"
    to_port     = 1194
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    description = "Public VPN 943"
    from_port   = 943
    protocol    = "tcp"
    to_port     = 943
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    description = "Public VPN TCP 1194"
    from_port   = 1194
    protocol    = "tcp"
    to_port     = 1194
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    description = "Public VPN 443"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }
  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
}

resource "aws_security_group_rule" "vpn-security-group-internal" {
  description       = "Allow The same security group"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.vpn-security-group.id
  self              = true
  # source_security_group_id = aws_security_group.vpn-security-group.id
  to_port           = 0
  type              = "ingress"
}

resource "aws_security_group" "vpn-sg" {
  # modeled after sg-06fac3390239ccb17 - vpn-sg
  description = "vpn-sg"
  name        = "vpn-sg"
  tags        = {
    Name = "vpn-sg"
  }
  #vpc_id = "vpc-5b67113c"
  vpc_id      = module.vpc.vpc_id
  ingress {
    cidr_blocks = [
      "20.0.0.0/16"
    ]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
  ingress {
    cidr_blocks = [
      "172.20.0.0/16"
    ]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
  ingress {
    cidr_blocks = [
      "172.1.0.0/16"
    ]
    description = "shared services vpc"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
}

resource "aws_security_group_rule" "vpn-sg-internal" {
  type              = "ingress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  security_group_id = aws_security_group.vpn-sg.id
  self              = true
  description       = "Allow Inside Security Group"
}

resource "aws_rds_cluster_parameter_group" "RDSDBClusterParameterGroup" {
  description = "ka-aurora"
  # family      = "aurora-postgresql9.6"
  family      = "aurora-postgresql12"
  parameter {
    apply_method = "pending-reboot"
    name  = "idle_in_transaction_session_timeout"
    value = "300000"
  }
  parameter {
    apply_method = "pending-reboot"
    name  = "pg_stat_statements.track"
    value = "ALL"
  }
  parameter {
    apply_method = "pending-reboot"
    name  = "rds.rds_superuser_reserved_connections"
    value = "4"
  }
  parameter {
    apply_method = "pending-reboot"
    name  = "shared_preload_libraries"
    value = "pg_stat_statements"
  }
}

resource "aws_db_subnet_group" "KatalonTestOpsProductionRDSDBSubnetGroup" {
  description = "Katalon TestOps Production Subnet Group"
  name        = "ka-production"
  subnet_ids  = [
    module.vpc.private_subnets[0],
    module.vpc.private_subnets[1],
    module.vpc.private_subnets[2]
  ]
}