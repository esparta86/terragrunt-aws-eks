locals {
  
  mergelist = concat(["cero","un medio"], var.listString)

  records = [
    for pair in var.recordset : {
        names = pair.name
        ttls  = pair.ttl
    }
  ]


}