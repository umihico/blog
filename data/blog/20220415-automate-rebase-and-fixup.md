---
tags: ['Git']
excerpt: "fixupしたコミットを上から数えて10なら`git rebase -i --autosquash HEAD~10`とかやってましたが、rebaseもまとめてやるコマンド作った話"
references:
  - "https://qiita.com/inukai-masanori/items/82eb0626fd75f3eb0922"
date: '2022-04-15'
title: 'fixup,rebaseコマンドの自動化'
summary: 'fixupしたコミットを上から数えて10なら`git rebase -i --autosquash HEAD~10`とかやってましたが、rebaseもまとめてやるコマンド作った話。これから少し捗りそう'
---

# fixup,rebaseコマンドの自動化

fixupしたコミットを上から数えて10なら`git rebase -i --autosquash HEAD~10`とかやってましたが、rebaseもまとめてやるコマンド作った話

[dotfileにも反映しました](https://github.com/umihico/dotfiles/commit/e27a66dedef5ef18c4c2f884cc620b7ccd38d9c4#diff-b122e030b0d26beb6d1e8c64d5e30d9c9082d0c6809d52e03336f48a423edd70R31-R35)

```bash
function rebase() {
  command git commit --fixup $1
  command git rebase -i --autosquash HEAD~$(git log --oneline --pretty=format:"%h" | grep -n $1 | cut -d : -f 1)
}
```

これから少し捗りそう
