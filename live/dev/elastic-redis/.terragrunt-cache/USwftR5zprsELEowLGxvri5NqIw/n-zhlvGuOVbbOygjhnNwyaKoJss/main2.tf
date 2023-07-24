resource "aws_elasticache_replication_group" "second" {
  replication_group_id       = "${var.environment}-${var.redis_name_second}"
  description                = "${var.environment}-${var.redis_name_second} Redis"
  num_cache_clusters         = var.cluster_mode_enabled_second ? null : var.number_cache_clusters_second
  node_type                  = var.redis_node_type_second
  port                       = var.redis_port_second
  engine_version             = var.redis_version_second

  subnet_group_name          = aws_elasticache_subnet_group.second.name
  security_group_ids         = [aws_security_group.this.id]
  automatic_failover_enabled = var.automatic_failover_enabled_second
  tags                       = var.tags
  apply_immediately          = true
  num_node_groups            = var.cluster_mode_enabled_second ? var.redis_num_node_groups_second : null
  replicas_per_node_group    = var.cluster_mode_enabled_second ? var.redis_replicas_second : null
  timeouts {
    create = "2h"
    update = "2h"
    delete = "2h"
  }
}

resource "aws_elasticache_subnet_group" "second" {
  name       = "${var.environment}-${var.redis_name_second}"
  subnet_ids =  data.aws_subnets.list_private_subnets_redis_second.ids
  tags       = var.tags_second

  depends_on = [ data.aws_subnets.list_private_subnets_redis_second ]
}

resource "aws_elasticache_parameter_group" "second" {
  name   = "${var.environment}-${var.redis_name_second}"
  family = var.redis_parameter_group_family_second

  dynamic "parameter" {
    for_each = var.cluster_mode_enabled_second ? concat([{ name = "cluster-enabled", value = "yes" }], var.redis_parameters_second) : var.redis_parameters_second
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}