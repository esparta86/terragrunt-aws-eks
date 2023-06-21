

data "aws_availability_zones" "available_zones" {
 state = "available"
 filter {
   name = "zone-name"
   values = ["us-east-1a","us-east-1b","us-east-1c"]
 }

}


# locals {

#   zone_list = [
#     for zonename in data.aws_availability_zones.available_zones[*].names  :
#      {
#         name = "${zonename}"
#      }
#   ]
# }