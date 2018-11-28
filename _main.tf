// Setup AWS account
//
provider "aws" {
  region  = "${var.aws-region}"
  profile = "${var.aws-profile}"
}

// Setup IAM user account
//
resource "aws_iam_user" "iamu" {
  name                 = "${var.user-email}"
  path                 = "${var.user-path}"
  permissions_boundary = "${var.permissions-boundary}"
  force_destroy        = "${var.force-destroy}"

  tags {
    Name  = "${var.user-name}"
    Email = "${var.user-email}"
  }
}

// Setup IAM user login info
// 
resource "aws_iam_user_login_profile" "iamulp" {
  user                    = "${aws_iam_user.iamu.name}"
  pgp_key                 = "keybase:${var.keybase-account}" // requires review!
  password_reset_required = "${var.pwd-reset}"
  password_length         = "${var.pwd-min-length}"
}

// Setup account password policy
// Note_1: there can only be one password policy per account
// Note_2: this means that this block should NOT be changed
//
resource "aws_iam_account_password_policy" "iamacpp" {
  allow_users_to_change_password = "${var.pwd-allow-user-change}"
  hard_expiry                    = "${var.pwd-hard-expiry}"
  max_password_age               = "${var.pwd-max-age}"
  minimum_password_length        = "${var.pwd-min-length}"
  password_reuse_prevention      = "${var.pwd-reuse-prevention}"
  require_lowercase_characters   = "${var.pwd-require-lowercase}"
  require_uppercase_characters   = "${var.pwd-require-uppercase}"
  require_numbers                = "${var.pwd-require-numbers}"
  require_symbols                = "${var.pwd-require-symbols}"
}

// Setup IAM user permissions using IAM groups
//
resource "aws_iam_user_group_membership" "iamugm" {
  user   = "${aws_iam_user.iamu.name}"
  groups = ["${var.user-groups}"]
}
