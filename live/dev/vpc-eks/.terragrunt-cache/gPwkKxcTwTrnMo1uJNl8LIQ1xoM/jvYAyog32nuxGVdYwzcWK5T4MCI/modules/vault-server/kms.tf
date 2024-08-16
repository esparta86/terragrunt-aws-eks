
resource "aws_kms_key" "vault" {
    description = "Vault unseal Key"
    deletion_window_in_days = 7

    tags = {
      "Name" = "vault-kms-unseal-key"
    }
}


resource "aws_kms_alias" "vault" {
  name = "alias/vault-kms-unseal-key"
  target_key_id = aws_kms_key.vault.key_id
}
