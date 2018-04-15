# THIS IS AN EXAMPLE OF USING TERRAFORM TO DEPLOY INFRASTRUCTURE ON AWS


## I. DIRECTORY STRUCTURE

```
Global <- Contain global resources to share between all staging/prod environment
Modules <- Contain common modules to be reusable and re-deployable for all environments. 
Stage <- Contain sample terraform deployment code that use Modules to create resources for Staging environment
```

#### BEFORE CONTINUE, PLEASE SETUP YOUR AWS CREDENTIALS IN THE SYSTEMS

## II. HOW TO RUN THIS DEPLOYMENT

### 1. Create a S3 bucket to store terraform state

This S3 bucket is to store terraform state file. A state file contains information of the infrastructure state that being 
managed by terraform. Using state file is a way to share current components and state of the infrastructure. 

Run:

```
terraform init ./global/
terraform plan ./global/ (Optional)
terraform apply ./global/
```

Save the bucket name to use later


### 2. Create VPC for staging environment

Edit terraform.tf
Line bucket = "unique-s3-bucket" <- please replace unique-s3-bucket with your own bucket

From top dir

Run:

```
terraform init ./stage/vpc/
terraform plan ./stage/vpc/
Terraform apply ./stage/vpc/
```

The vpc state file contains the newly create vpc information will be stored in the S3 bucket [our-bucket]/stage/vpc/terraform.tfstate

### 3. Create a front-end 

Edit /modules/frontend-app/terraform.tf 
Line bucket = "unique-s3-bucket" <- please replace unique-s3-bucket with your own bucket

Run

```
terraform init ./stage/services/front-end/
terraform plan ./stage/services/front-end/
terraform apply ./stage/services/front-end/
```

It will output the dns name of the LB, if the URL display hello world mean the front-end has been successfully deployed.

Destroy this front-end cluster before continue

```
terraform destroy ./stage/services/front-end/
```

### 4. Create a auto-scaling group 

Edit /modules/web-cluster/terraform.tf 
Line bucket = "unique-s3-bucket" <- please replace unique-s3-bucket with your own bucket

Run
```
terraform init ./stage/services/web-cluster/
terraform plan ./stage/services/web-cluster/
terraform apply ./stage/services/web-cluster/
```

It will output the dns name of the LB, if the URL display “hello world” mean the ASG has been successfully deployed. (Might take 1 mins to complete setup)

## NOTE:
To deploy to different environment rather than Staging, for e.g PROD; create a new VPC to PROD, save terraform state file to another S3 bucket, use the same modules to deploy but this time, change the vpc_state_file_location to the PROD vpc state file location. You can make further change such as: cluster_name change to PROD, minimum & maximum number of instance. Add your own variable such as instance type, AMI ID…etc


