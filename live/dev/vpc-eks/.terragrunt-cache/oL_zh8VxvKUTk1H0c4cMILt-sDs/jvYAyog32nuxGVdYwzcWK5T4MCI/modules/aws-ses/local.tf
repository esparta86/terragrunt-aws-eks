locals {
  new_map = flatten([
    for config in var.configuration_ses : [
        for event in coalesce(config.event_destination,[]) : {
            "set_name" = config.name
            "enabled"  = event.enabled
            "matching_event_types" = event.matching_event_types

            "cloud_watch_destination" = lookup(event,"cloud_watch_destination",null) != null ? event.cloud_watch_destination : false
            "default_dimension_value" = lookup(event,"dimension_configuration",null) != null ? event.dimension_configuration.default_dimension_value : null
            "dimension_name" = lookup(event,"dimension_configuration",null) != null ? event.dimension_configuration.dimension_name : null
            "dimension_value_source" = lookup(event,"dimension_configuration",null) != null ? event.dimension_configuration.dimension_value_source : null

            "sns_destination" = lookup(event,"sns_destination",null) != null ? event.sns_destination : false
            "topic_arn" = lookup(event,"topic_arn",null) != null ? event.topic_arn : null

        }
    ]
  ])
}
