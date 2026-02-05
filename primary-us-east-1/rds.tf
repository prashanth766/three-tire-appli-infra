#creation of rds
resource "aws_db_instance" "master" {
    allocated_storage = 20
    identifier = "books-rds"
    instance_class = "db.t3.micro"
    db_subnet_group_name = aws_db_subnet_group.dbsubgrp.id
    multi_az = true
    db_name = "mydb"
    engine = "mysql"
    engine_version = "8.0"
    username = "admin"
    password = "cloud123"
    skip_final_snapshot = true
    vpc_security_group_ids = [ aws_security_group.book-rds-sg.id ]
    publicly_accessible = false
    backup_retention_period = 7
    depends_on = [aws_db_subnet_group.dbsubgrp]
    


    tags = {
    DB_identifier = "book-rds"
  }
}



#creation of subnet group
resource "aws_db_subnet_group" "dbsubgrp" {
    name="main"
    subnet_ids = [ aws_subnet.rdspriv1.id,aws_subnet.rdspriv2.id ]
    depends_on = [ aws_subnet.rdspriv1,aws_subnet.rdspriv2 ]


    tags={
        Name="rds-subnet-grp"
    }
  
}