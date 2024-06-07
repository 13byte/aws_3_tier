resource "aws_elasticache_replication_group" "redis-group" {
  preferred_cache_cluster_azs = [for az in var.availability_zones.* : az]
  replication_group_id        = "cluster-redis-group-${var.vpc_name}"
  description                 = "cluster redis group ${var.vpc_name}"
  node_type                   = "cache.t4g.small"
  num_cache_clusters          = 2
  parameter_group_name        = "default.redis7"
  port                        = 6379
  engine_version              = "7.1"
  multi_az_enabled            = true
  snapshot_retention_limit    = 0

  automatic_failover_enabled = true
  subnet_group_name          = aws_elasticache_subnet_group.redis-subnet.name
  security_group_ids         = [aws_security_group.elasticache-redis.id]
}

resource "aws_elasticache_subnet_group" "redis-subnet" {
  name       = "cluster-redis-subnet-${var.vpc_name}"
  subnet_ids = [for subnet in aws_subnet.private_db.* : subnet.id]
}
