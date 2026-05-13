# resource "aws_kms_key" "cloudtrail_key" {
#   description             = "KMS Key for Central CloudTrail Logs"
#   enable_key_rotation     = true
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#
#     Statement = [
#       {
#         Sid    = "Enable IAM User Permissions"
#         Effect = "Allow"
#
#         Principal = {
#           "AWS" = "arn:aws:iam::${var.account_id}:root"
#         }
#
#         Action   = "kms:*"
#         Resource = "*"
#       },
#       {
#         Sid    = "Allow CloudTrail to encrypt logs"
#         Effect = "Allow"
#
#         Principal = {
#           Service = "cloudtrail.amazonaws.com"
#         }
#
#         Action = [
#           "kms:GenerateDataKey*",
#           "kms:Decrypt",
#           "kms:DescribeKey"
#         ]
#
#         Resource = "*"
#       }
#     ]
#   })
# }
#
# resource "aws_kms_alias" "cloudtrail_key" {
#   name          = "alias/central-cloudtrail-key"
#   target_key_id = aws_kms_key.cloudtrail_key.key_id
# }