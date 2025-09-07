🚀 AWS Cost Optimization Automation

Automated AWS Cost Monitoring & Idle Resource Management with Terraform, Lambda, and Slack



📌 Overview

This project delivers an end-to-end AWS cost optimization automation system.
It helps organizations control cloud spending by:

🔍 Monitoring daily AWS costs

🛑 Automatically stopping idle EC2 instances

📢 Sending real-time alerts to Slack

⚡ Automating deployments via Terraform

🐳 Supporting Dockerized Lambda packaging

📂 Project Structure
aws-cost-optimization-automation/
│── src/
│   └── check_lambda/         # Lambda Function Source
│       ├── DockerFile        # Containerized Lambda build
│       └── main.py           # Lambda handler (Cost + Idle EC2 logic)
│
│── terraform/                # Terraform Infrastructure as Code
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   └── variales.tf           # (variables.tf)
│
│── .gitignore
│── LICENSE
└── README.md

🏗️ Architecture
flowchart TD
    A[EventBridge Daily Trigger] --> B1[Lambda: Check Costs & Idle EC2]
    B1 -->|If Cost > Threshold| S[Slack Notification]
    B1 -->|Stop Idle Instances| EC2[EC2 Instances]

    subgraph IaC
    T[Terraform] --> A
    T --> B1
    end

    subgraph Container
    D[Docker] --> B1
    end

⚙️ Setup & Deployment
Step 1. Create a Slack Webhook

Create a Slack channel (e.g., #aws-cost-alerts)

Add an Incoming Webhook app

Copy the Webhook URL

Step 2. Clone Repository
git clone https://github.com/cloude-user/aws-cost-optimization-automation.git
cd aws-cost-optimization-automation

Step 3. Configure Terraform

Edit terraform/variales.tf to include your Slack Webhook and AWS region.

Example:

variable "slack_webhook_url" {
  description = "Slack Incoming Webhook URL"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

Step 4. Build & Package Lambda (Docker)
cd src/check_lambda

# Build Docker image
docker build -t lambda-cost-optimization .


Step 5. Deploy Infrastructure
cd terraform
terraform init
terraform apply


Provide your Slack Webhook URL when prompted.

Step 6. Validate Deployment

Check CloudWatch Logs for Lambda execution

Receive Slack alerts if daily AWS costs exceed threshold

Confirm idle EC2 instances are automatically stopped

🧪 Example Slack Alert

⚠️ Warning! Yesterday’s AWS cost was $12.34. Please review your resources.

🛠️ Tech Stack

Python 3.9 – Lambda runtime

Docker – Packaging Lambda

AWS Lambda – Cost monitoring + EC2 automation

AWS EventBridge (CloudWatch Events) – Daily scheduling

Slack Webhook – Real-time notifications

Terraform – Infrastructure as Code

📌 Future Enhancements

Multi-region cost aggregation

Use CloudWatch Metrics (CPU, Network) for better idle EC2 detection

Integration with AWS Budgets for proactive cost alerts

Add CI/CD with GitHub Actions for auto-deployment

🎉 Conclusion

With this setup, you get a cloud-native cost optimization solution that is:
✅ Automated
✅ Containerized
✅ Infrastructure-as-Code
✅ Cost-efficient


