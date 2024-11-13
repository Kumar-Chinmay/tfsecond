provider "aws" {
  region = "us-east-1"  # Update this to the appropriate region
}


locals {
  bucket_data = csvdecode(file(var.csv_file_path))
}

# Create S3 buckets based on the parsed CSV data
resource "aws_s3_bucket" "bucket" {
  for_each = { for idx, item in local.bucket_data : 
               "${item.customer}-${item.application}-${item.dept}" => item }

  bucket = each.key
 
}

# Output the created bucket names
output "bucket_names" {
  value = [for b in aws_s3_bucket.bucket : b.bucket]
}
