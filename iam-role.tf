resource "aws_iam_role" "my_iam_role" {
  name               = "ed-ec2-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "my_iam_attachment_policy" {
  name       = "iam-role-attachment"
  roles      = [aws_iam_role.my_iam_role.name]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "Instance-Profile"
  role = aws_iam_role.my_iam_role.name
}