# resource "aws_iam_instance_profile" "s3_profile" {
#   name = "s3-access-profile"
#   role = aws_iam_role.ec2_s3_role.name
# }

# resource "aws_iam_role" "ec2_s3_role" {
#   name = "ec2_s3_role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       },
#     ]
#   })
# }

# resource "aws_iam_policy" "s3_access_policy" {
#   name        = "s3_access_policy"
#   path        = "/"
#   description = "My test policy to give ec2 instance access to s3"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "s3:*",
#         ]
#         Effect = "Allow"
#         Resource = [
#         #   "${aws_s3_bucket.iqies_my_first_resourse.arn}",
#         #   "${aws_s3_bucket.iqies_my_first_resourse.arn}/*",
#         "arn:aws:s3:::devops16-project-bucket/*",
#         "arn:aws:s3:::devops16-project-bucket"
#         ]
#       }
#     ]
#   })
# }

# resource "aws_iam_policy_attachment" "ec2_role_attach" {
#   name       = "ec2-attachment"
#   roles      = [aws_iam_role.ec2_s3_role.name]
#   policy_arn = aws_iam_policy.s3_access_policy.arn
# }