output "all" {
  value = {
    private_buckets                     = aws_s3_bucket.private_buckets
    private_buckets_public_access_block = aws_s3_bucket_public_access_block.private_buckets
  }
}
