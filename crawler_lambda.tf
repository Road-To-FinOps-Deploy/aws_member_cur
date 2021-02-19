#s3 event lambda

data "archive_file" "crawler_cf_zip" {
  type        = "zip"
  source_file = "${path.module}/source/crawler_cf.py"
  output_path = "${path.module}/output/crawler_cf.zip"
}

resource "aws_lambda_function" "crawler_cf" {
  filename         = "${path.module}/output/crawler_cf.zip"
  function_name    = "crawler_cf"
  role             = aws_iam_role.iam_role_for_athena.arn
  handler          = "crawler_cf.lambda_handler"
  source_code_hash = data.archive_file.crawler_cf_zip.output_base64sha256
  runtime          = "python3.7"
  memory_size      = "512"
  timeout          = "150"

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.s3_bucket.id
      REGION      = var.region
    }
  }
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.crawler_cf.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.s3_bucket.arn
  source_account = data.aws_caller_identity.current.account_id
}