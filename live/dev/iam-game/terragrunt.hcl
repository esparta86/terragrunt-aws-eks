

terraform {
    source = "../../..//modules/iam-play"
}

inputs = {
    # vpc_cidr = "10.2.0.0/16"
    # default_tags =  {
    #    cloudprovider = "aws"
    #    owner         = "lisandro"
    #    environment   =  "dev"
    # }
    # instance_type = "t2.small"
    # instance_name = "public-server"
    # subnet_public_list = dependency.vpc.outputs.subnets_public_ids
    # # security_group_nginx_id = dependency.vpc.outputs.security_group_ngix_id
    # instance_name_server = "private-server"
    # # security_group_mysql_id = dependency.vpc.outputs.security_group_mysql_id
    # subnet_private_id = dependency.vpc.outputs.subnet_private_id
    # vpc_id = dependency.vpc.outputs.vpc_id


  aws_region                             = "us-east-1"
  aws_account_id                             = "AWS_ACCOUNT"
  account_name                           = "ste"
  cluster_name                           = "ste-use1-1"
  service                                = "service-jenkins-sandbox"
  environment                            = "sandbox"
  jenkins_agents_ec2_spot = {
    asg_max_size = 2
    asg_min_size = 0
    agent_label  = "ec2-fleet" 
  }

  jenkins_agents_ec2_spot_enhanced = {
    asg_max_size           = 2
    asg_min_size           = 0
    agent_label            = "docker-enhanced docker-spot-enhanced"
    workspace_storage_size = 80 //launch_template parameter    
  }

  jenkins_agents_ec2_spot_perf_test = {
    asg_max_size = 2
    asg_min_size = 0
    agent_label  = "perf-test docker-perf-test"    
  }


  vault_address                          = "https://vault-ent-preprod.devops.colocho.es:8200"
  project_name                           = "jenkins"
  mount_point                            = "ste"
  jenkins_controller_service_account     = "jenkins-sandbox-controller-sa"
  jenkins_hostname                       = "jenkins-sandbox.ste.colocho.es"
  jenkins_helm_chart_version             = "4.6.7"
  jenkins_controller_image               = "AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/jenkins-custom"
  jenkins_controller_tag                 = "latest"
  jenkins_controller_service_port        = 8080
  jenkins_controller_agent_listener_port = 50000
  jenkins_rbac_create                    = true
  jenkins_namespace                      = "sandbox-jenkins"
#   jenkins_agent_ami_id                   = "ami-02f1080d56b85f242"
  jenkins_controller_resources = {
    requests = {
      cpu    = "16"
      memory = "32Gi"
    }
    limits = {
      cpu    = "16"
      memory = "32Gi"
    }
  }

  jenkins_plugins = [
    "allure-jenkins-plugin:2.32.0",
    "amazon-ecr:1.151.vb_ca_71ddd0b_cf",
    "analysis-model-api:12.9.1",
    "android-emulator:652.v185536c05086",
    "ansicolor:1.0.5",
    "ant:511.v0a_a_1a_334f41b_",
    "antisamy-markup-formatter:162.v0e6ec0fcfcf6",
    "apache-httpcomponents-client-4-api:4.5.14-269.vfa_2321039a_83",
    "apache-httpcomponents-client-5-api:5.4-124.v31e2987e48f4",
    "asm-api:9.7.1-97.v4cc844130d97",
    "atlassian-jira-software-cloud:2.0.15",
    "audit-trail:382.vf64d6f626060",
    "authentication-tokens:1.119.v50285141b_7e1",
    "authorize-project:1.8.1",
    "aws-codebuild:0.59",
    "aws-credentials:243.v41c19a_fb_5dcf",
    "aws-java-sdk-api-gateway:1.12.772-474.v7f79a_2046a_fb_",
    "aws-java-sdk-autoscaling:1.12.772-474.v7f79a_2046a_fb_",
    "aws-java-sdk-cloudformation:1.12.772-474.v7f79a_2046a_fb_",
    "aws-java-sdk-cloudfront:1.12.772-474.v7f79a_2046a_fb_",
    "aws-java-sdk-codebuild:1.12.772-474.v7f79a_2046a_fb_",
    "aws-java-sdk-codedeploy:1.12.772-474.v7f79a_2046a_fb_",
    "aws-java-sdk-ec2:1.12.772-474.v7f79a_2046a_fb_",
    "aws-java-sdk-ecr:1.12.772-474.v7f79a_2046a_fb_",
    "aws-java-sdk-ecs:1.12.772-474.v7f79a_2046a_fb_",
    "aws-java-sdk-efs:1.12.772-474.v7f79a_2046a_fb_",
    "aws-java-sdk-elasticbeanstalk:1.12.772-474.v7f79a_2046a_fb_",
    "aws-java-sdk-elasticloadbalancingv2:1.12.772-474.v7f79a_2046a_fb_",
    "aws-java-sdk-iam:1.12.772-474.v7f79a_2046a_fb_",
    "aws-java-sdk-kinesis:1.12.772-474.v7f79a_2046a_fb_",
    "aws-java-sdk-lambda:1.12.772-474.v7f79a_2046a_fb_",
    "aws-java-sdk-logs:1.12.772-474.v7f79a_2046a_fb_",
    "aws-java-sdk-minimal:1.12.772-474.v7f79a_2046a_fb_",
    "aws-java-sdk-organizations:1.12.772-474.v7f79a_2046a_fb_",
    "aws-java-sdk-secretsmanager:1.12.772-474.v7f79a_2046a_fb_",
    "aws-java-sdk-sns:1.12.772-474.v7f79a_2046a_fb_",
    "aws-java-sdk-sqs:1.12.772-474.v7f79a_2046a_fb_",
    "aws-java-sdk-ssm:1.12.772-474.v7f79a_2046a_fb_",
    "aws-java-sdk:1.12.772-474.v7f79a_2046a_fb_",
    "aws-java-sdk2-core:2.30.28-26.v649b_8df2f988",
    "aws-java-sdk2-ec2:2.30.28-26.v649b_8df2f988",
    "aws-java-sdk2-ecr:2.30.28-26.v649b_8df2f988",
    "aws-secrets-manager-credentials-provider:1.214.va_0a_d8268d068",
    "aws-secrets-manager-secret-source:1.72.v61781b_35c542",
    "badge:2.5",
    "blueocean-autofavorite:1.2.5",
    "blueocean-bitbucket-pipeline:1.27.16",
    "blueocean-commons:1.27.16",
    "blueocean-config:1.27.16",
    "blueocean-core-js:1.27.16",
    "blueocean-dashboard:1.27.16",
    "blueocean-display-url:2.4.3",
    "blueocean-events:1.27.16",
    "blueocean-git-pipeline:1.27.16",
    "blueocean-github-pipeline:1.27.16",
    "blueocean-i18n:1.27.16",
    "blueocean-jwt:1.27.16",
    "blueocean-personalization:1.27.16",
    "blueocean-pipeline-api-impl:1.27.16",
    "blueocean-pipeline-editor:1.27.16",
    "blueocean-pipeline-scm-api:1.27.16",
    "blueocean-rest-impl:1.27.16",
    "blueocean-rest:1.27.16",
    "blueocean-web:1.27.16",
    "blueocean:1.27.16",
    "bootstrap5-api:5.3.3-1",
    "bouncycastle-api:2.30.1.78.1-248.ve27176eb_46cb_",
    "branch-api:2.1200.v4b_a_3da_2eb_db_4",
    "build-monitor-plugin:1.14-947.vfec2cf655fe2",
    "build-name-setter:2.4.3",
    "build-pipeline-plugin:2.0.2",
    "build-timeout:1.33",
    "build-user-vars-plugin:182.v378b_9f14b_487",
    "build-with-parameters:76.v9382db_f78962",
    "built-on-column:1.4",
    "caffeine-api:3.1.8-133.v17b_1ff2e0599",
    "checks-api:2.2.1",
    "cloud-stats:336.v788e4055508b_",
    "cloudbees-bitbucket-branch-source:933.v7119e94e8f56",
    "cloudbees-folder:6.963.v6edc0fc71472",
    "cobertura:1.17",
    "code-coverage-api:4.99.0",
    "command-launcher:116.vd85919c54a_d6",
    "commons-compress-api:1.26.1-2",
    "commons-lang3-api:3.17.0-84.vb_b_938040b_078",
    "commons-text-api:1.12.0-129.v99a_50df237f7",
    "config-file-provider:980.v88956a_a_5d6a_d",
    "configuration-as-code-groovy:1.1",
    "configuration-as-code:1903.v004d55388f30",
    "coverage:1.16.1",
    "datadog:8.2.0",
    "docker-workflow:580.vc0c340686b_54",
    "ssh-credentials:349.vb_8b_6b_9709f5b_",
    "workflow-step-api:678.v3ee58b_469476"
  ]


}


include {
    path = find_in_parent_folders()
}

include "provider_aws" {
  path = find_in_parent_folders("include/provider_aws.hcl")
}
# dependency "vpc" {
#     config_path = "../vpc"
# }
