resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.bucket_name}-${data.aws_caller_identity.current.account_id}"
  #region = var.region

  versioning {
    enabled = true
  }

  tags = {
    Project = "Penny"
    Team    = "FinOps"
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}

#386209384616 is AWS Account
data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    sid = "Stmt1335892150622"

    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketPolicy",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::386209384616:root"] # DO NOT CHANGE ACCOUNT NUMBER THIS IS SO AWS CAN PUT IN CUR
    }

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}",
    ]
  }

  statement {
    sid = "Stmt1335892526596"

    actions = [
      "s3:PutObject",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::386209384616:root"] # DO NOT CHANGE ACCOUNT NUMBER THIS IS SO AWS CAN PUT IN CUR
    }

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.s3_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.crawler_cf.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".yml"
  }
}
