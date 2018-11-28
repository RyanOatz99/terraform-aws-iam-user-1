# IAM User management w/ Terraform

- [IAM User management w/ Terraform](#iam-user-management-w-terraform)
  - [WWH](#wwh)
  - [Input](#input)
  - [Output](#output)
  - [Usage](#usage)
  - [Notes](#notes)
  - [Useful links](#useful-links)

<hr/>

## WWH

* **What:** This is a Terraform module to automate the creation and management of IAM users for an AWS account.
* **Why:** The previous automation of the IAM users was management based on bash scripts that became difficult to manage. 
* **How:** This module uses Terraform to create an IAM user, defines their permissions using existing IAM groups, and also sets a password policy for the entire account. 

<hr/>

## Input

The following is the list of all input arguments:

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| **aws-profile** | The AWS account profile name. | string | - | yes |
| aws-region | The AWS region. | string | `us-east-1` | no |
| force-destroy | Forces destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices. | string | `true` | no |
| **keybase-account** | The name of the keybase account | string | - | yes |
| permissions-boundary | The filepath to the permissions file. | string | `` | no |
| pwd-allow-user-change | Whether to allow users to change their own password. | string | `true` | no |
| pwd-hard-expiry | Prevents changing the password after it experir. Requires admin reset. | string | `false` | no |
| pwd-max-age | The number of days that an user password is valid. | string | `90` | no |
| pwd-min-length | The minimum length of the password | string | `24` | no |
| pwd-require-lowercase | Whether to require lowercase characters for user passwords. | string | `true` | no |
| pwd-require-numbers | Whether to require numbers for user passwords. | string | `true` | no |
| pwd-require-symbols | Whether to require symbols for user passwords. | string | `true` | no |
| pwd-require-uppercase | Whether to require uppercase characters for user passwords. | string | `true` | no |
| pwd-reset | Whether the user must reset the password on first login. | string | `true` | no |
| pwd-reuse-prevention | The number of previous passwords that users are prevented from reusing. | string | `1` | no |
| **user-email** | The IAM user email. | string | - | yes |
| **user-groups** | The IAM groups to add the user to. | list | - | yes |
| **user-name** | The IAM user name. | string | - | yes |
| user-path | The path in which to create the user. | string | `/` | no |


Note_1: *user-email* is used as the login name, while *user-name* is only used to tag the user.

Note_2: *keybase-account* refers to a username on [https://keybase.io/](https://keybase.io/). Keybase is used as a service to handle the encryption of the passwords of the accounts. 

<hr/>

## Output

The following outputs are exported:

| Name | Description |
|------|-------------|
| user-arn | The Amazon Resource Number of the user. |
| user-id | The ID of the user. |
| user-name | The name tag associated to the user. |
| **user-pwd-encrypted** | The encrypted user password |

<hr/>

## Usage

Instructions on how to use this module to create/manage an IAM user.

1. Create and navigate to a folder for the new user;
    
    ```bash
    mkdir new-user && cd new-user
    ```
    
2. Create a `.tf` file and insert a reference to the module:
    
    ```hcl
    module "new-user" {
      source = "path-to-this-module"
    }
    ```

3. Complete it with the information of the user and the account:
    
    ```hcl
    module "test-user" {
      source = "path-to-this-module"

      aws-profile     = "ds-web-products-staging"
      user-name       = "test-user-name"
      user-email      = "test-user-email@test.com"
      user-groups     = ["developers", "ManageOwnCreds"]
      keybase-account = "rafaelmarques7"
    }
    ```

4. Add output variable to retrieve the password:
   
    ```hcl
    output "user-pwd-encrypted" {
      value = "${module.test-user.user-pwd-encrypted}"
    }
    ```

5. Run the terraform script:
    
    ```bash
    terraform init
    terraform plan  # optional - detects possible errors
    terraform apply --auto-approve=true
    ```
    
    **Important Notes**: 
      * this will execute the script, and create the users. The information will be saved on the state file, which will be located on the repository just created. 
      * if you want to **change user permissions**, change the `user-groups` variable, and run `terraform apply` again. 
      * if you want to **delete the user**, run `terraform destroy`. This command analyzes the state and determines what resources were previously created, and which must be destroyed.
      * finally, because of the two points above, **it is recommended to not add any user permissions manually**.

6. Decrypt the password (if used on a CI/CD, use env. variables)
      
      ```bash
      cat ./filename.txt | base64 --decode | keybase pgp decrypt
      ```

7. At the first login, you will be required to change the password (unless the variable `pwd-reset` is overwritten).

<hr/>

## Notes

* Multifactor authentication can not be forced using Terraform scripts.
  * it must be configured using IAM policies 
  * (applying the *ManageOwnCreds* group to the user forces MFA)
* Revisit the tagging strategy.

<hr/>

## Useful links

* Terraform
  * [aws_iam_user](https://www.terraform.io/docs/providers/aws/r/iam_user.html)
  * [aws_iam_user_login_profile](https://www.terraform.io/docs/providers/aws/r/iam_user_login_profile.html)
  * [aws_iam_account_password_policy](https://www.terraform.io/docs/providers/aws/r/iam_account_password_policy.html)
  * [aws_iam_user_group_membership](https://www.terraform.io/docs/providers/aws/r/iam_user_group_membership.html)
* Encryption and Security
  * how to [generate a GPG key](https://help.github.com/articles/generating-a-new-gpg-key/)
