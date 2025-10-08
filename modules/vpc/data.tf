data "aws_caller_identity" "current" {
   count = 1
}

data "aws_iam_session_context" "current" {
    arn =  try(data.aws_caller_identity.current[0].arn, "")
}

output "aws_account_id" {
  value = data.aws_caller_identity.current[0].account_id
}
output "aws_arn" {
  value = data.aws_caller_identity.current[0].arn
}
output "aws_user_id" {
  value = data.aws_caller_identity.current[0].user_id
}
