

# resource "aws_ec2_managed_prefix_list" "prefix_list" {
#     for_each = {
#       for cidr in local.new_map2 :
#        cidr.tgw_id => cidr.cidr
#     }
    
#     dynamic "entry" {
#         for_each = each.value
#         content {
#           cidr = entry.value
#         }
#     }

#     name = "prefix_list_${each.key}"
#     address_family = "IPv4"
#     max_entries = length(local.new_map2)

# }

# resource "aws_route" "aws_route_tgw" {
#     # for_each = {
#     #    for route_map in local.new_map2 :
#     #     route_map.tgw_id => route_map.routes
#     # }

#     count = length(local.routes_map)

#     route_table_id = local.routes_map[count.index].routeid
#     # destination_prefix_list_id = aws_ec2_managed_prefix_list.prefix_list[local.routes_map[count.index].tgw_id].id
#     destination_cidr_block = local.routes_map[count.index].cidr
#     transit_gateway_id = local.routes_map[count.index].tgw_id
#     # depends_on = [ aws_ec2_managed_prefix_list.prefix_list ]
# }


# resource "aws_vpc" "sample-vpc" {
#     for_each = local.networks
#     cidr_block = "${each.value.cidr_block}"
# }


