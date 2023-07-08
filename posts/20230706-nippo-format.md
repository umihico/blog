---
tags: "gh"
---

# 日報用のスクリプトを公開してみる

今日作ったプルリクと、今日レビューしたプルリクをリストしてくれます。

https://gist.github.com/umihico/4b131c0a9a521df40abcde701c90cc67

## 使い方

前日の活動を採取する場合はNIPPO_OFFSET=1にして実行します。

```bash

export NIPPO_OFFSET=0; curl -sL "https://gist.githubusercontent.com/umihico/4b131c0a9a521df40abcde701c90cc67/raw/dockered.sh?v=$(date +'%s')" | bash -exv

```

## こんな感じになります

Notionに貼ると、マークダウンがただしく評価され装飾に変換されます。

```markdown
## 今日作ったプルリク

- 23:19 ✅[git-pr-release修正](https://github.com/umihico/blog/pull/46)
- 23:24 ✅[Update gem installation command to use sudo](https://github.com/umihico/blog/pull/47)
- 23:53 ✅[Automatic rebase and merge](https://github.com/umihico/blog/pull/48)
- 23:56 ✅[Release 2023-07-08 23:56:19 +0900](https://github.com/umihico/blog/pull/49)

## 今日レビューしたプルリク

- [Release 2023-07-08 23:56:19 +0900](https://github.com/umihico/blog/pull/49)
- [Automatic rebase and merge](https://github.com/umihico/blog/pull/48)

## 今日やったこと（=相手に提供済）

- 00:01 ✅自動rebaseの実装

## 今日やっていたこと（=相手に提供前）

-

## 明日やること

- 💥泳ぐ
```
