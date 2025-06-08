output "cost_anomaly_lambda_name" {
  value = aws_lambda_function.cost_anomaly_alerts.function_name
}

output "idle_ec2_lambda_name" {
  value = aws_lambda_function.idle_ec2_stopper.function_name
}