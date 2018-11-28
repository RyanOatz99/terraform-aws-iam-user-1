// -------------------------------------------------------------------------
//                          REQUIRED INPUT
// -------------------------------------------------------------------------

variable "aws-profile" {
  description = "The AWS account profile name."
}

variable "user-name" {
  description = "The IAM user name."
}

variable "user-email" {
  description = "The IAM user email."
}

variable "user-groups" {
  description = "The IAM groups to add the user to."
  type        = "list"
}

variable "keybase-account" {
  description = "The name of the keybase account"
}

// -------------------------------------------------------------------------
//                          OPTIONAL INPUT
// -------------------------------------------------------------------------

variable "aws-region" {
  description = "The AWS region."
  default     = "us-east-1"
}

variable "user-path" {
  description = "The path in which to create the user."
  default     = "/"
}

variable "permissions-boundary" {
  description = "The filepath to the permissions file."
  default     = ""
}

variable "force-destroy" {
  description = "Forces destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices. "
  default     = true
}

variable "pwd-reset" {
  description = "Whether the user must reset the password on first login."
  default     = true
}

variable "pwd-min-length" {
  description = "The minimum length of the password"
  default     = 24
}

variable "pwd-allow-user-change" {
  description = "Whether to allow users to change their own password."
  default     = true
}

variable "pwd-hard-expiry" {
  description = "Prevents changing the password after it experir. Requires admin reset."
  default     = false
}

variable "pwd-max-age" {
  description = "The number of days that an user password is valid."
  default     = 90
}

variable "pwd-reuse-prevention" {
  description = "The number of previous passwords that users are prevented from reusing."
  default     = 1
}

variable "pwd-require-lowercase" {
  description = " Whether to require lowercase characters for user passwords."
  default     = true
}

variable "pwd-require-uppercase" {
  description = " Whether to require uppercase characters for user passwords."
  default     = true
}

variable "pwd-require-numbers" {
  description = "Whether to require numbers for user passwords."
  default     = true
}

variable "pwd-require-symbols" {
  description = "Whether to require symbols for user passwords."
  default     = true
}
