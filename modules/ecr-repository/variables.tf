
variable "ecr_map" {
    type = list(object({
        name = string
        image_tag_mutability = string
        exclusion_filter = optional(list(map(any)))
        encryption_configuration = optional(map(string))

    }))
}
