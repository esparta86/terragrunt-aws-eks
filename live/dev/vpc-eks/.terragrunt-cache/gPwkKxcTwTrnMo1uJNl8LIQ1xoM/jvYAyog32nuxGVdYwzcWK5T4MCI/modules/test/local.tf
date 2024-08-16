locals {
  
  mergelist = concat(["cero","un medio"], var.listString)

  records = [
    for pair in var.recordset : {
        names = pair.name
        ttls  = pair.ttl
    }
  ]

  #   private_routes_cidr_maps = [
  #   {
  #     "tgw_id" = "tgw-0a2b303cf28c27a43"
  #     "cidr"   = [
  #       "10.42.0.0/19",
  #       "10.42.32.0/19",
  #       "10.42.64.0/19",
  #       "10.42.96.0/19"
  #     ]
  #   },
  #    {
  #      "tgw_id" = "tgw-0a2b303cf28c27a455"
  #      "cidr"   = [
  #        "1.1.3.0/24",
  #        "1.1.4.0/24"
  #   ]
  #   }

  # ]

  # vpc_private_route_table_ids = [ "rtb-0842c44c68569c88b", "rtb-02db9c2c4a3e18997","rtb-024c3461bc5fbb759", "rtb-013127c0f86d9cfc9" ]

  # routes_map = flatten([
  #   for route_id in local.vpc_private_route_table_ids : [
  #     for tgw_cidr in local.private_routes_cidr_maps : [
  #        for cidr in tgw_cidr.cidr : {
  #         "tgw_id"  = tgw_cidr.tgw_id
  #         "routeid" = route_id
  #         "cidr"    = cidr
  #        }
  #     ]
  #   ]
  # ])

  # new_map = distinct(flatten([
  #   for route  in local.vpc_private_route_table_ids : [
  #     for tgw in local.private_routes_cidr_maps : {
  #        for cidr in tgw.cidr : {
  #           tgw = tgw.tgw_id

  #        }
  #     }
  #   ]
  # ]))

  # new_map2 = [ for routes_build in local.private_routes_cidr_maps : {
  #   "tgw_id" = routes_build.tgw_id
  #   "cidr"   = routes_build.cidr
  #   "routes" = local.vpc_private_route_table_ids
  # }]




#   networks  = {
#     "private" = {
#       cidr_block = "10.1.0.0/16"
#       subnets = {
#         "db1" = {
#           cidr_block = "10.1.0.0/24"
#         }
#         "db2" = {
#           cidr_block = "10.1.254.0/16"
#         }
#       }
#     }

#     "public"  = {
#       cidr_block = "10.2.0.0/16"
#       subnets = {
#         "webserver" = {
#           cidr_block = "10.2.0.0/24"
#         }
#         "email_server" = {
#           cidr_block = "10.2.254.0/24"
#         }
#       }

#     }

#     "dmz" = {
#       cidr_block = "10.3.0.0/16"
#       subnets = {
#         "firewall" = {
#           cidr_block = "10.3.0.0/24"
#         }
#         "firewall2" = {
#           cidr_block = "10.3.254.0/24"
#         }
#       }
#     }
#   }

#   # networks_subnet = flatt
#   list_of_list = [[1,2,3],[4,5],[6,7,8],[9,1]]

#   lista = [1,2,3,4,5]
#   listb = ["a","b","c","d","e"]

#   concatlist2 = [ for item in local.lista : [
#       for item2 in local.listb : {
#         item1 = item
#         item2 = item2
#       }
#      ]
#   ]

}
