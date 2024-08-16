variable "vpc_name" {
  description = "name for vpc"
  type        = string
}

variable "vpc_cidr" {
  description = "cidr for vpc"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "The availability zones to spread nodes in"
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
    ]
  type = list(string)
}



variable "default_tags" {
  default = {
    cloudprovider = "aws"
    owner         = "devops-team"
    Terraform     = "true"
    Environment   = "development"
  }
  description = "Default tags name to tag in resources"
  type        = map(string)
}

variable "worker_default_instance" {
  description = "The availability zones to spread nodes in"
  default = [
    "t2.medium"
    ]
  type = list(string)
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes cluster version"
  default     = "1.27"
}

variable "create_db_cluster_parameter_group" {
  description = "Determines whether a cluster parameter should be created or use existing"
  type        = bool
  default     = true
}

variable "db_cluster_parameter_group_parameters" {
  description = "A list of DB cluster parameters to apply. Note that parameters may differ from a family to an other"
  type        = list(map(string))
  default     =  [{
  "name"  : "work_mem"
  "value" : 655360
  },
  {
    "name"  : "work_mem2"
    "value" : 334444}
  ]
}

variable "max_size_primary" {
  default = 2
}

variable "enable_compute_ng_default" {
 type = bool
 default = true
}

variable "list_manage_compute_ng_default" {
  type = map(any)
  default = {
      compute_1 = {
          min_size     = 1
          max_size     = 4
          desired_size = 1
          update_config = {
            max_unavailable_percentage = 10
          }
          instance_types               = ["c5.4xlarge"]
          block_device_mappings = {
            xvda = {
              device_name = "/dev/xvda"
              ebs = {
                volume_size           = 100
                volume_type           = "gp3"
                iops                  = 3000
                throughput            = 150
                encrypted             = false
                delete_on_termination = true
              }
            }
          }
          labels = {
            "pluto.tv/service-dedicated-group" = "istio"
            "pluto.tv/instance-compute-type"   = true
            "pluto.tv/node-group"              = "compute_1"
          }
        }

       compute_2 = {
            min_size     = 0
            max_size     = 2
            desired_size = 0
            update_config = {
              max_unavailable_percentage = 10
            }
            instance_types               = ["c5.9xlarge"]
            block_device_mappings = {
              xvda = {
                device_name = "/dev/xvda"
                ebs = {
                  volume_size           = 100
                  volume_type           = "gp3"
                  iops                  = 3000
                  throughput            = 150
                  encrypted             = false
                  delete_on_termination = true
                }
              }
            }
            labels = {
              "pluto.tv/instance-compute-type" = true
              "pluto.tv/node-group"            = "compute_2"

            }
            # taints = [
            #   {
            #     key    = "instance-dedicated"
            #     value  = "9xl"
            #     effect = "NO_SCHEDULE"
            #   }
            # ]
          }
  }
}
