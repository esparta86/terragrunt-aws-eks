resource "aws_elasticache_replication_group" "this" {
  replication_group_id       = "${var.environment}-${var.redis_name}"
  description                = "${var.environment}-${var.redis_name} Redis"
  num_cache_clusters         = var.cluster_mode_enabled ? null : var.number_cache_clusters
  node_type                  = var.redis_node_type
  port                       = var.redis_port
  engine_version             = var.redis_version

  subnet_group_name          = aws_elasticache_subnet_group.this.name
  security_group_ids         = [aws_security_group.this.id]
  automatic_failover_enabled = var.automatic_failover_enabled
  tags                       = var.tags
  apply_immediately          = true
  num_node_groups            = var.cluster_mode_enabled ? var.redis_num_node_groups : null
  replicas_per_node_group    = var.cluster_mode_enabled ? var.redis_replicas : null
  timeouts {
    create = "2h"
    update = "2h"
    delete = "2h"
  }
}

resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.environment}-${var.redis_name}"
  subnet_ids =  data.aws_subnets.list_private_subnets_redis.ids
  tags       = var.tags
}

resource "aws_elasticache_parameter_group" "this" {
  name   = "${var.environment}-${var.redis_name}"
  family = var.redis_parameter_group_family

  dynamic "parameter" {
    for_each = var.cluster_mode_enabled ? concat([{ name = "cluster-enabled", value = "yes" }], var.redis_parameters) : var.redis_parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}