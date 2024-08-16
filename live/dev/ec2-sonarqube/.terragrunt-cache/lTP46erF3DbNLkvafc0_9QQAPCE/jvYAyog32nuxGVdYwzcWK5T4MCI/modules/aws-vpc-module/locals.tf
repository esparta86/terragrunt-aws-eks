locals {
  list_azs = slice(data.aws_availability_zones.available.names,0,length(var.azs))


# where i will be 0,1,2 and it will be the netnum of cidrsubnet
# Example
# 10.0.0.0/16 if this is the cidr range for vpc and we are telling that  4 should be the newbits
#  16+4 = 20 so the mask should be /20
#  network portion = 20 bits of 32
#  host portion = 12 bits
# -----------------------------
#   0  0  0  0 - 0  0  0  0  0  0  0  0
#  2048   1024    512  256     128   64   32   16   8   4   2   1
  private_subnets = [ for i,v in local.list_azs : cidrsubnet(var.vpc_cidr,4,i)]
  public_subnets   = [ for i,v in local.list_azs : cidrsubnet(var.vpc_cidr,8, i+48) ]
  intra_subnets =   [ for i,v in local.list_azs: cidrsubnet(var.vpc_cidr,8,i+52)]
  name = "ex-${replace(basename(path.cwd),"_","-")}"
  primary_l = {
      primary = {
        min_size = 0
        max_size = var.max_size_primary
        desired_size = 0

      }
  }
  # eks_managed_ng = var.enable_compute_ng_default == true ? merge(local.primary_l, var.list_manage_compute_ng_default) : local.primary_l



}
