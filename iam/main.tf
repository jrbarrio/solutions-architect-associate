terraform {
    backend "s3" {
        region = "eu-west-1"
        bucket = "jrb.2019.terraform.state"
        key = "solutions-architect-associate-iam/terraform.tfstate"
    }
}

provider "aws" {
    region = var.region
}

resource "aws_iam_group" "developers" {
    name = "developers"
    path = "/saa/"
}

data "aws_iam_policy" "AdministratorAccess" {
    arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy" "AmazonS3FullAccess" {
    arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_group_policy_attachment" "administrator_policy_attachment" {
    group      = aws_iam_group.developers.id
    policy_arn = data.aws_iam_policy.AdministratorAccess.arn
}

resource "aws_iam_group_policy_attachment" "s3_policy_attachment" {
    group      = aws_iam_group.developers.id
    policy_arn = data.aws_iam_policy.AmazonS3FullAccess.arn
}

resource "aws_iam_user" "developer" {
    name = "developer"
    path = "/saa/"

    tags = {
        Name = "User"
        Project = "solutions-architect-associate-iam"
    }
}

resource "aws_iam_user_group_membership" "developers" {
    user = aws_iam_user.developer.name

    groups = [
        aws_iam_group.developers.name,
    ]
}
