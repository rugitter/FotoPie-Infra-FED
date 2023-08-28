# FotoPie-Infra-BED-FED
A repo for FotoPie project infrastruture FED + BED

## Operation Menu
Jump directly to the desired application folder where the tf files are saved:
For
    * FED - go to \applications\fotopie-fed\
    * BED - go to \applications\fotopie-bed\

Change the variables.tf file at the specific application level to values that suit you. This will make your input var passed across this entire application from top to down. e.g. \applications\fotopie-fed\variables.tf

Change the following app, env, aws specific parameters:
backend.tf:
    * profile   - the AWS account profile in use
    * bucket    - tfstatefile stored S3 bucket
    * provider-profile  - Same as profile above

Run command: 
    Initiation  - terraform init
    Plan        - terraform plan
    Apply       - terraform apply (-var-file="
    terraform_prod.tfvars")
    Destroy     - terraform destroy

### Destroy tips
* When destroying resources, run destroy bed first, then destroy fed. Because some bed resource has dependency on fed resources, e.g. Route53 zone.
* Can't delete ECR repo if not empty
* Can't delete tfstate S3 bucket if not empty
