resource "aws_s3_bucket" "origin_s3" {
  bucket = var.domain_name

  tags = {
    Name = var.domain_name
  }
}

resource "aws_s3_bucket_public_access_block" "origin_s3_acl" {
  bucket = aws_s3_bucket.origin_s3.id

  block_public_acls       = true
  block_public_policy     = ture
  ignore_public_acls      = ture
  restrict_public_buckets = ture
}

# OAI for CloudFront
resource "aws_s3_bucket_policy" "public_get_policy" {
  bucket = aws_s3_bucket.origin_s3.id
  policy = data.aws_iam_policy_document.public_get_policy.json
}

data "aws_iam_policy_document" "public_get_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity your_oai_id"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.origin_s3.arn}/*",
    ]
  }
}

# s3 upload static web files
resource "null_resource" "upload_web_files" {
  provisioner "local-exec" {
    command = "aws s3 sync ./stop-raining.com/ s3://${aws_s3_bucket.origin_s3.bucket}"
  }

  depends_on = [aws_s3_bucket.origin_s3]
}
