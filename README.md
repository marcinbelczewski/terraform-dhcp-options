# Issue with Terraform DHCP Options for VPC

## Issue

When creating a new VPC with new DHCP options set associated, the Terraform state of the VPC created references a default DHCP options set in the region rather than the newly created one. Immediate *terraform plan* invocation suggests a drift occurred.

Additionally, once DHCP options set is destroyed via Terraform, alongside its association, the VPC's *dhcp_options_id* remains pointing to the id of just removed DHCP options set. 
Immediate *terraform plan* invocation highlights a drift and suggests a change to "default" value.
Subsequent *terraform apply* indeed changes the value of VPC's *dhcp_options_id* to "default" but in AWS the VPC remains with no default DHCP options set associated.


## Steps to reproduce

1. initialise and apply VPC alongside DHCP options set

    ```hcl
    terraform init
    terraform apply -auto-approve
    ```
    Notice different values of *vpc_dhcp_options_in_terraform_state* output and *vpc_dhcp_options_in_aws* the latter being the value visible in AWS Management Console.

2. Execute 
    ```hcl
    terraform plan
    ```
    And notice the message *Note: Objects have changed outside of Terraform: Terraform detected the following changes made outside of Terraform since the last "terraform apply"* referring VPC's *dhcp_options_id* property.

3. Execute 
    ```hcl
    terraform apply -auto-approve
    ```
    And only now notice values of *vpc_dhcp_options_in_terraform_state* and *vpc_dhcp_options_in_aws* outputs matching.

4. Remove the following resources from main.tf
    * aws_vpc_dhcp_options
    * aws_vpc_dhcp_options_association
    * output vpc_dhcp_options_in_aws

5. Execute
    ```hcl
    terraform apply -auto-approve
    ```
    And notice the value of *vpc_dhcp_options_in_terraform_state* pointing to the id of DHCP options set just destroyed.

6. Execute 
    ```hcl
    terraform plan
    ```
    And notice the message *Note: Objects have changed outside of Terraform: Terraform detected the following changes made outside of Terraform since the last "terraform apply"* referring VPC's *dhcp_options_id* property suggesting the change to "default" value.

7. Execute
    ```hcl
    terraform apply -auto-approve
    ```
    And notice the value of *vpc_dhcp_options_in_terraform_state* being "default".
    
    Verify in AWS Management Console that despite "default" value for *dhcp_options_id" in Terraform, the VPC has no default DHCP Options set associated.
