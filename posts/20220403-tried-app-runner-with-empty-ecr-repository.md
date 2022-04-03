---
tags: "AWS,AWS App Runner"
---

# Terraformで空のECRレポジトリを参照するApp Runnerをapplyしたくて辛かった話

別の新規プロジェクトに既存のTerraform資産を流用した時に、App RunnerとECRを一発で同時デプロイすることになりましたが、そうなると当然ECRのレポジトリは空なので失敗するわけで、次回スムーズに流用できる方法がないか試行錯誤しました

## 先に健全な解決案

もちろん、モジュール単位で先にECRだけapplyして、pushしてイメージを作ってからApp Runnerを作ればよい。しかしCIからデプロイする縛りを逸したくなかった、かつCI上でモジュール単位のデプロイを構築するのは手間なため、あえて色々やってみました

## ダミーのパブリックECRを参照して一旦applyする作戦

**失敗。**  
どうやら`aws_apprunner_service`の`image_repository_type`の値`ECR_PUBLIC`と`ECR`を途中で切り替えするのは不可のため。Terraformからやっても`aws apprunner update-service`叩いても同じ。以下のエラーをゲットする。不便なだけだし、いつか修正されるかも？

> An error occurred (InvalidRequestException) when calling the UpdateService operation: The image repository type cannot be changed in UpdateService request

## 存在しないタグを指定してapplyする作戦

**失敗。**  
Terraformのタイムアウトのようで、以下のエラーをゲットする。

> aws_apprunner_service.this: Still creating... [12m40s elapsed]  
Error: error waiting for App Runner Service (arn:aws:apprunner:ap-northeast-1:*********:service/dev-app/hogehoge) creation: unexpected state 'CREATE_FAILED', wanted target 'RUNNING'. 

## 存在しないタグを指定してapplyしてその間にそのタグでpushする作戦

**成功。**  
上の作戦でハングする時間が長いので、加えてその間にpushして存在させてしまう作戦を試みところうまくいった。インフラ構築時はイメージを問わないので、以下のようにヘルスチェックをパスできるイメージならなんでもよいからローカルからpushする。（結局CI使ってないという）

```bash
export DOCKER_DEFAULT_PLATFORM=linux/amd64
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com
docker pull kennethreitz/http
docker tag kennethreitz/httpbin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/dev-app-runner:httpbin
docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/dev-app-runner:httpbin
```
