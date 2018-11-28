output "user-name" {
  description = "The name tag associated to the user."
  value       = "${aws_iam_user.iamu.name}"
}

output "user-arn" {
  description = "The Amazon Resource Number of the user."
  value       = "${aws_iam_user.iamu.arn}"
}

output "user-id" {
  description = "The ID of the user."
  value       = "${aws_iam_user.iamu.unique_id}"
}

output "user-pwd-encrypted" {
  description = "The encrypted user password"
  value       = "${aws_iam_user_login_profile.iamulp.encrypted_password}"
}
