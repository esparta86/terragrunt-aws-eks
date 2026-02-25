
resource "aws_ecr_repository" "this" {
  for_each = { for repository in var.ecr_map : repository.name => repository }

  name = each.value["name"]
  image_tag_mutability = each.value["image_tag_mutability"]
  force_delete = false


  dynamic "image_tag_mutability_exclusion_filter" {
    for_each = each.value["image_tag_mutability"] == "IMMUTABLE_WITH_EXCLUSION" || each.value["image_tag_mutability"] == "MUTABLE_WITH_EXCLUSION" && length(coalesce(each.value["exclusion_filter"],[])) > 0 ? coalesce(each.value["exclusion_filter"],[]) : []

    content {
        filter = image_tag_mutability_exclusion_filter.value.filter
        filter_type = image_tag_mutability_exclusion_filter.value.filter_type
    }
  }

#   dynamic "encryption_configuration" {
#     for_each = lookup(each.value,"encryption_configuration",false) ? [true] : []
#     content {
#       encryption_type = each.value["encryption_configuration"].encryption_type
#       kms_key = each.value["encryption_configuration"].kms_key
#     }
#   }


}
