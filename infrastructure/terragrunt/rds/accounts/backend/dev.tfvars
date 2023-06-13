rds_instance_list = [
  {
    engine                = "postgres"
    engine_version        = "14.3"
    family                = "postgres14"
    major_engine_version  = "14"
    instance_class        = "db.t4g.medium"
    rds_security_group    = "Postgresql_Sec_Group1"
    allocated_storage     = 20
    max_allocated_storage = 100
    db_name               = "database1"
    username              = "myuser1"
  },
  {
    engine               = "postgres"
    engine_version       = "14.3"
    family               = "postgres14"
    major_engine_version = "14"
    instance_class       = "db.t4g.medium"

    rds_security_group    = "Postgresql_Sec_Group2"
    allocated_storage     = 20
    max_allocated_storage = 100
    db_name               = "database2"
    username              = "myuser2"
  },


  // Add more RDS instances as needed
]