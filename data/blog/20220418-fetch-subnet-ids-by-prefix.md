---
tags: "AWS"
date: '2022-04-18'
title: 'prefixの一致するサブネットIDをカンマ区切りで取り出すワンライナー'
---

# prefixの一致するサブネットIDをカンマ区切りで取り出すワンライナー

`aws ec2 describe-subnets --filters "Name=tag:Name,Values=COMMON_PREFIX_HERE*" --query "Subnets[].[SubnetId]" --output text | python -c 'import sys; print(",".join(sys.stdin.read().splitlines()))'`

CircleCIのECSのOrbsに使いたかったが、そもそもCommandにしろJobにしろ引数は環境変数など静的にセットするか、circleci/continuationを使わないとダメそう
