variable "environment" {
  type = string
}


variable "listString" {
  type = list(string)
  default = [ "uno","dos","tres","cuatro","cinco" ]
}



variable "recordset" {
  type = list(object({
    name = string
    type = string
    ttl  = number
    records = list(string)
    internal = bool
  }))

  default = [
    {
      name = "db",
      records = ["1.1.1.1"],
      ttl = 300,
      type= "A",
      internal = true
    },
   {
      name = "db",
      records = ["1.1.1.1"],
      ttl = 300,
      type= "A",
      internal = true
    }
  ]
}


variable "eks_managed_node_groups" {
  type        = list(object({
    iam_role_name = string
  }))
  description = "EKS cluster security group"
  # default     = []
  default = [
    {
      iam_role_name: "test"
    },{
      iam_role_name: "test2"
    }
  ]


}
