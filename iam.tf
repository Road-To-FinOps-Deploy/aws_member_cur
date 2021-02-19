data "aws_iam_policy_document" "billing_policy" {
  statement {
    actions = [
      "aws-portal:*Billing",
      "awsbillingconsole:*Billing",
      "aws-portal:*Usage",
      "awsbillingconsole:*Usage",
      "aws-portal:*PaymentMethods",
      "awsbillingconsole:*PaymentMethods",
      "budgets:ViewBudget",
      "budgets:ModifyBudget",
      "cur:*",
      "s3:*",
      "quicksight:*",
    ]

    resources = [
      "*",
    ]
  }
}


#Athena createion Lambda

resource "aws_iam_role" "iam_role_for_athena" {
  name               = "athena"
  assume_role_policy = file("${path.module}/policies/LambdaAssume.pol")
}

resource "aws_iam_role_policy" "iam_role_policy_for_athena" {
  name   = "athena"
  role   = aws_iam_role.iam_role_for_athena.id
  policy = file("${path.module}/policies/LambdaAthena.pol")
}


