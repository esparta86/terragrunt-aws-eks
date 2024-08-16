
resource "aws_instance" "vault_server" {
    count = var.required_vault_server ? 1 : 0
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    subnet_id = var.private_vault_server ? var.private_subnets[0] : var.public_subnets[0]
    key_name = var.key_name
    vpc_security_group_ids = [ aws_security_group.sg_vault_server.id ]
    associate_public_ip_address = var.private_vault_server ? false : true
    iam_instance_profile = aws_iam_instance_profile.vault-server.id

    tags = {
      "Name" = "vault-server-${count.index}"
    }


    user_data = templatefile("${path.module}/templates/userdata-vault-server.tftpl", { tpl_vault_service_name = "vault-server", tpl_kms_key = aws_kms_key.vault.id, tpl_aws_region = var.aws_region, tpl_consul_bootstrap_expect = 1, account_id = data.aws_caller_identity.current.account_id, role_name = "vault-client-role" })

  lifecycle {
    ignore_changes = [
      ami,
      tags,
    ]
  }
}

data "aws_caller_identity" "current" {
}




