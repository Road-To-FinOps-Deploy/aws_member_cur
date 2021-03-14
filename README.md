# Member Account CUR
This is a tool to help with AWS billing and reporting.

The goal for this deployment is to start collecting your Cost and Uage report from AWS in a format for Athena to read. 


This stems from the AWS supplied cloud formation but running this script means there is no manual procces

CUR proccess:

- A terraform to create s3 for billing to go into
- Athana database 
- Glue crawler to keep tabel up-to-date


## Steps

### Pre-requisites

1. Make sure that your AWS default region is set correctly.
The region specified in your penny profile should match that in your local $AWS_DEFAULT_REGION environment variable.

2. Make sure the IAM policy you're using covers access to all the AWS services that you're using.
If you've coded up some Terraform for a new AWS service then the policy will need to change.
See "iam.json" for the policy definition.


### Set up 

1.  Install terraform 
[Terraform – Getting Started – Install Terraform on Windows, Linux and Mac OS | Vasos Koupparis](https://www.vasos-koupparis.com/terraform-getting-started-install/)

``` 
brew install terraform
```

2. Install AWS cli

[Installing the AWS CLI - AWS Command Line Interface](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

```
pip3 install awscli --upgrade --user
```


3. Create an AWS IAM User
This needs to be in your **billing account**.  It will need with programtic access with the administrator policy. See AWS instructions here
[Creating Your First IAM Admin User and Group - AWS Identity and Access Management](https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html)

Create using the policy in the iam.json file

Copy the Access and Secret key to your machine

4. Setup your aws profile
```
$ aws configure --profile penny
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: eu-west-1
Default output format [None]: json
```

5. terraform module reference 
    (see new to terraform bit below if you need help)
'''
module "aws_member_cur" {
  source = "github.com/Road-To-FinOps-Deploy/aws_member_cur"
}
'''

6. Deploy Terraform
```
terraform init
terraform plan
terraform apply
```
7. Run setup lambda
```
aws lambda invoke --function-name lambda_cur out --log-type Tail --profile penny
```


## Optional Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bucket\_name | Start of bucket name that will be created. this will add on account id| string | `"cur_bucket"` | no 
| region | Deployment Region | string | `"eu-west-1"` | no |
| report\_name | The name of your Cost and Usage Report | string | `"MemberCUR"` | no |
| timeunit | Granularity of CUR | string | `"HOURLY"` | no |
| athena_table_name | Name of your Athena table  | string | `"MemberCUR"` | no |


Now you have setup your access, deployed your terraform and triggered your lambda function you are all setup.

The first Cost and Usage report takes 24hr to appear in your s3 bucket. Once this happends the terraform will build the yaml file for the crawler AWS provides so set your timer and look out for your athena table.

Once the 24hrs is comeplete you should have an Athena Database with your aws billing data in it.


### Visualization 

After you have data in the anthea table you can put it in AWS Quicksight
https://wellarchitectedlabs.com/cost/200_labs/200_enterprise_dashboards/



### New to terraform?

Create a terraform file *main.tf*


```
terraform {
  backend "s3" {
    bucket  = "penny-bucket-577906137810"
    key     = "<name of bucket in managment account>"
    region  = "eu-west-1"
    encrypt = "true"
    profile = "penny"
  }
}


provider "aws" {
  region  = "eu-west-1"
  profile = "penny"
}

module "aws_member_cur" {
  source = "github.com/Road-To-FinOps-Deploy/aws_member_cur"
}

```