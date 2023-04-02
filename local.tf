locals {
  current_account = data.aws_caller_identity.current.account_id
  clixx_creds = jsondecode(
    data.aws_secretsmanager_secret_version.clixxcreds.secret_string
  )
}