# blog

## How to start

1. Modify environment variables in `buildspec.yml`
1. Connect CodeBuild with Github (from blank project creation)
1. Create hosted zone in parent account.
1. From parent account, `terraform -chdir=terraform/environments/parent apply -var="prod_domain=umihi.co" -var="dev_domain=dev-blog.umihi.co" -var="blog_account_id=$BLOG_ACCOUNT_ID"`
1. `terragrunt run-all apply`
1. Push development or main branch and things will be deployed.

## How to develop

### Use hot reload while coding or blogging

```bash
docker-compose up
```

### Export and browse files before uploading

```bash
docker-compose -f docker-compose.yml -f docker-compose.static.yml up
```

### Github Actionsへ環境変数のセット

```bash
env | grep \
-e AWS_DEFAULT_REGION \
-e SOURCE_LOCATION \
-e PROD_DOMAIN \
-e DEV_DOMAIN \
-e BLOG_ACCOUNT_ID \
-e NEXT_PUBLIC_GITHUB_URL \
-e NEXT_PUBLIC_BLOG_TITLE \
-e NEXT_PUBLIC_GTM_ID \
-e GH_ACTIONS_ROLE \
-e PROD_ASSETS_BUCKET \
-e DEV_ASSETS_BUCKET \
-e NEXT_PUBLIC_BLOG_DESCRIPTION > .env.secrets
gh secret set -f .env.secrets
```

### Terraformの運用について

Codebuildで実行しているが、`PowerUserAccess`なのでIAM系をいじる場合は手動で

```bash
# 手動実行時の手順書
eval $(save-session-key $AWS_PROFILE) # save-session-keyについては[ここ](https://github.com/umihico/dotfiles/blob/e18d72381800bc84f54c407a5fae1e4fcd0545a5/.functions.sh)を参照
unset AWS_PROFILE
terragrunt run-all apply
```
