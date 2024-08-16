

terraform {
    source = "../../../modules/elastic-redis"
}


include {
    path = find_in_parent_folders()
}

inputs = {
  environment = "dev"
  redis_name = "redis-test"
  cluster_mode_enabled = true
  number_cache_clusters = 0
  tags = {
    cluster = "redis"
  }
  redis_node_type = "cache.t3.small"
  redis_version = "5.0.6"
  automatic_failover_enabled = true
  redis_num_node_groups = 2
  redis_replicas = 1
  redis_parameter_group_family = "redis5.0"
  vpc_cidr = "10.0.0.0/16"
  redis_availability_zones =  ["us-east-1a","us-east-1d"]
  # redis_name_second = "redis-test-second"
  # redis_availability_zones_second = ["us-east-1a","us-east-1d"]
  # cluster_mode_enabled_second = true
  # number_cache_clusters_second = 2
  # tags_second = {
  #   cluster = "redis_second"
  # }
  # redis_node_type_second = "cache.t3.small"
  # redis_version_second = "5.0.6"
  # automatic_failover_enabled_second = true
  # redis_num_node_groups_second = 2
  # redis_replicas_second = 2
  # redis_parameter_group_family_second = "redis5.0"
}