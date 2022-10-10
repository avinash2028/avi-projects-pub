# terraform-eks-ci_cd
### Prerequisite
 1. Setup aws profile in your local machine
 2. Setup s3 bucket for terraform backend
### Below services get setup with this terraform
    VPC, RDS, EKS, ECR, Subnets, Security Groups, IAM role, Codebuild, two APIs written in python by using flask. 
### Infra Setup Steps 
1. Download https://github.com/avinash2028/terraform-eks-ci_cd.git
2. cd terraform-eks-ci_cd/terraform
3. terraform init --var-file=var.tfvars
4. terraform plan --var-file=var.tfvars -out tfplan
5. terraform apply tfplan

### Api service deployment.
1. Trigger code build job
2. Get the load balancer url and send sample request

#### POST

      curl --location --request POST 'http://<elb_url>/emp_form' \
      --header 'Content-Type: application/json' \
      --data-raw '{
          "email_id": "john@gmail.com",
          "name": "john",
          "age": "22",
          "sex": "M",
          "income": "22000"
      }'

#### GET

      curl --location --request GET 'http://<elb_url>/emp_info' \
      --header 'Content-Type: application/json' \
      --data-raw '{
          "email_id": "john@gmail.com"
      }'
