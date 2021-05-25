resource "aws_flow_log" "app_flow_logs" {
  iam_role_arn    = aws_iam_role.app_flow_log_role.arn
  log_destination = aws_cloudwatch_log_group.app_cloudwatch_grp.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.dac_app_vpc.id
}

resource "aws_cloudwatch_log_group" "app_cloudwatch_grp" {
  name = "app_cloudwatch_grp"
}

resource "aws_iam_role" "app_flow_log_role" {
  name = "app_flow_log_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "app_flow_log_role_policy" {
  name = "app_flow_log_role_policy"
  role = aws_iam_role.app_flow_log_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}