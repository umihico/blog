---
tags: "git"
date: '2022-12-17'
---

# 全ディレクトリのgit originを抽出する

クローンした際に割り当てたフォルダ名を失念して、gitのオリジンから調べたくなった、かつclone済みの全フォルダを走査する必要があったので

## こちら

```bash
find . -name .git -type d -maxdepth 2 -execdir git config --get remote.origin.url ";"
```
