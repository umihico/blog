# Parent IAM role

Because my hosted zone `umihi.co` and `dev-blog.umihi.co` are managed by parent account, creating assumable role is required.

## import

Terraform states are roughly managed and gitignored on local disk. If you lose, you need to import first.


```bash
terraform import aws_iam_role.blog role-assumed-by-blog
```

## apply

```bash
terraform apply -var="prod_domain=umihi.co" -var="dev_domain=dev-blog.umihi.co" -var="blog_account_id=$BLOG_ACCOUNT_ID"
```