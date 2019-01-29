provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "what_is_your_ip_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "test_lambda" {
  filename         = "../../functions/what_is_your_ip/main.zip"
  function_name    = "what-is-your-ip"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "main.handle"
  source_code_hash = "${base64sha256(file("../../functions/what_is_your_ip/main.zip"))}"
  runtime          = "python2.7"

  environment {
    variables = {
      foo = "bar"
    }
  }
}


# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${aws_lambda_function.test_lambda.function_name}"
  retention_in_days = 14
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "lambda_logging" {
  name = "lambda_logging"
  path = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = "${aws_iam_role.iam_for_lambda.name}"
  policy_arn = "${aws_iam_policy.lambda_logging.arn}"
}

module "iam" {
  source = "../modules/iam"

  name = "${var.name}"
}

module "api_gateway" {
  source = "../modules/api_gateway"

  name       = "${var.name}"
  aws_region = "${var.aws_region}"
  lambda_arn = "${aws_lambda_function.test_lambda.arn}"
}

module "cloudfront" {
  source = "../modules/cloudfront"

  name           = "${var.name}"
  aws_region     = "${var.aws_region}"
  api_gateway_id = "${module.api_gateway.id}"
  cf_config      = "${var.cf_config}"
}
