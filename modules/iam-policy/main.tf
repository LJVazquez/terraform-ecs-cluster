variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = "terra policy"
}

variable "policy_json_path" {
  type = string
}

resource "aws_iam_policy" "policy" {
  name        = var.name
  description = var.description

  policy = file(var.policy_json_path)
}

output "arn" {
  value = aws_iam_policy.policy.arn
}
