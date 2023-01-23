---
tags: "Git"
---

# Githubにてコミットをverifiedでカッコつけるのが簡単になってた件

以前にverifiedにしようとしたら公開鍵がED25519だと手順が煩雑だったので諦めてましたが、久しぶりに調べたら簡単になってました

## 1. 公開鍵を登録する

既にSSH鍵として登録済みであっても、
https://github.com/settings/ssh/new にて「Key type」を`Signing Key`として登録する必要があった。

## 2. コマンド叩く

```bash
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
git config --global gpg.format ssh
```

この状態でcommitでき、pushしてverifiedになったら成功

## 3. エラーしたらバージョン上げる

もしcommitが失敗し`error: unsupported value for gpg.format: ssh`というエラーが出た場合、
gitのバージョンが2.34未満じゃないか確認してください。

```bash
git --version # バージョン確認
brew upgrade git # 主にMacの場合
```

## 4. バージョン上げが反映されなかったら

`brew upgrade git`しても`git --version`するとバージョンが変わらなかった。しかしもう一度`brew upgrade git`しても、`Warning: git 2.39.1 already installed`と警告がでるだけに。調べてみると、なぜかダウンロードするディレクトリが変わっていた以下のようにして解決した

```
git --version # git version 2.29.2
which git # /usr/local/bin/git
/usr/bin/git --version # git version 2.37.1 (Apple Git-137.1)
rm -rf /usr/local/bin/git
```
