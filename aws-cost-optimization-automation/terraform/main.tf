resource "aws_iam_role" "lambda_role" {
  name = "lambda_cost_optimization_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "cost_anomaly_alerts" {
  filename         = "../lambda/cost_anomaly_alerts.zip"
  function_name    = "cost-anomaly-alerts"
  role             = aws_iam_role.lambda_role.arn
  handler          = "app.lambda_handler"
  runtime          = "python3.9"
  timeout          = 300
  environment {
    variables = {
      SLACK_WEBHOOK_URL = var.slack_webhook_url
    }
  }
}

resource "aws_lambda_function" "idle_ec2_stopper" {
  filename         = "../lambda/idle_ec2_stopper.zip"
  function_name    = "idle-ec2-stopper"
  role             = aws_iam_role.lambda_role.arn
  handler          = "app.lambda_handler"
  runtime          = "python3.9"
  timeout          = 300
}

resource "aws_cloudwatch_event_rule" "daily_trigger" {
  name                = "daily-cost-optimizer-trigger"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "cost_alert_target" {
  rule = aws_cloudwatch_event_rule.daily_trigger.name
  target_id = "costAlertLambda"
  arn = aws_lambda_function.cost_anomaly_alerts.arn
}

resource "aws_cloudwatch_event_target" "ec2_stop_target" {
  rule = aws_cloudwatch_event_rule.daily_trigger.name
  target_id = "idleEc2Lambda"
  arn = aws_lambda_function.idle_ec2_stopper.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_cost_alert" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cost_anomaly_alerts.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_trigger.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_ec2_stop" {
  statement_id  = "AllowExecutionFromCloudWatchIdle"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.idle_ec2_stopper.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_trigger.arn
}