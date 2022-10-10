resource "random_password" "password" {
  length  = 16
  special = false
}

resource "aws_db_subnet_group" "subnetgroup" {
  name       = "${var.project}-subnetgroup"
  subnet_ids = flatten([var.subnet_ids])

  tags = {
    Name = "${var.project}"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/16"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project}-rdssg"
  }
}

resource "aws_db_instance" "rds" {
  identifier              = "${var.project}-rds"
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t3.micro"
  username                = "admin"
  password                = random_password.password.result
  db_subnet_group_name    =  aws_db_subnet_group.subnetgroup.id
  vpc_security_group_ids  = [aws_security_group.allow_tls.id]
  parameter_group_name    = "default.mysql5.7"
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false
  storage_encrypted       = true
  backup_retention_period = 7

  tags = {
    Name = "${var.project}"
  }
}


# Secret Manager
resource "aws_secretsmanager_secret" "rdssecret" {
  kms_key_id              = aws_kms_key.default.key_id
  name                    = "${var.project}-rds_admin"
  description             = "RDS Admin password"
  recovery_window_in_days = 14

  tags = {
    Name = "${var.project}"
  }
}

resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = aws_secretsmanager_secret.rdssecret.id
    secret_string = templatefile("${path.module}/ssm-string.json.tmpl", {
    DB_USER = aws_db_instance.rds.username,
    DB_PASSWORD = random_password.password.result,
    DB_HOST     = aws_db_instance.rds.address,
    DB_PORT     = aws_db_instance.rds.port
  })  

}

# KMS key used by Secrets Manager for RDS
resource "aws_kms_key" "default" {
  description             = "KMS key for RDS"
  deletion_window_in_days = 30
  is_enabled              = true
  enable_key_rotation     = true

  tags = {
    Name = "${var.project}"
  }
}