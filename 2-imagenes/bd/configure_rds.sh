#!/bin/bash

# Crea la primera instancia de RDS
aws rds create-db-instance \
  --db-instance-identifier ${DB_INSTANCE_IDENTIFIER_1} \
  --engine postgres \
  --engine-version 12.5 \
  --db-instance-class db.t2.micro \
  --vpc-security-group-ids ${VPC_SECURITY_GROUP_IDS} \
  --db-subnet-group-name ${DB_SUBNET_GROUP_NAME_1} \
  --availability-zone YOUR_AVAILABILITY_ZONE \
  --master-username admin \
  --master-user-password adminpassword \
  --allocated-storage 20

# Crea la segunda instancia de RDS
aws rds create-db-instance \
  --db-instance-identifier ${DB_INSTANCE_IDENTIFIER_2} \
  --engine postgres \
  --engine-version 12.5 \
  --db-instance-class db.t2.micro \
  --vpc-security-group-ids ${VPC_SECURITY_GROUP_IDS} \
  --db-subnet-group-name ${DB_SUBNET_GROUP_NAME_2} \
  --availability-zone YOUR_AVAILABILITY_ZONE \
  --master-username admin \
  --master-user-password adminpassword \
  --allocated-storage 20

# Configura la comunicación bidireccional entre las dos bases de datos
aws rds modify-db-instance \
  --db-instance-identifier ${DB_INSTANCE_IDENTIFIER_1} \
  --vpc-security-group-ids ${VPC_SECURITY_GROUP_IDS}

aws rds modify-db-instance \
  --db-instance-identifier ${DB_INSTANCE_IDENTIFIER_2} \
  --vpc-security-group-ids ${VPC_SECURITY_GROUP_IDS}
