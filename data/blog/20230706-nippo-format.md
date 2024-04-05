---
tags: "gh"
date: '2023-07-06'
title: '日報用のスクリプトを公開してみる'
summary: '今日作ったプルリクと、今日レビューしたプルリクをリストしてくれます。  https://gist.github.com/umihico/4b131c0a9a521df40abcde701c90cc67'
---

# 日報用のスクリプトを公開してみる

今日作ったプルリクと、今日レビューしたプルリクをリストしてくれます。

https://gist.github.com/umihico/4b131c0a9a521df40abcde701c90cc67

## 使い方

前日の活動を採取する場合はNIPPO_OFFSET=1にして実行します。

```bash

export NIPPO_OFFSET=0; curl -sL "https://gist.githubusercontent.com/umihico/4b131c0a9a521df40abcde701c90cc67/raw/dockered.sh?v=$(date +'%s')" | bash -exv

```
