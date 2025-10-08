data "archive_file" "lambda_zip" {
    output_path = "${path.module}/lambda_function.zip"
    type = "zip"
    source_file = "${path.module}/lambda_function.py"
}


resource "aws_iam_role" "lambda_exec_role" {
    
}


resource "aws_lambda_function" "budget_alert_lambda" {
  filename = data.archive_file.lambda_zip.output_path
  function_name = "budget_lambda"
role = "value"
}
