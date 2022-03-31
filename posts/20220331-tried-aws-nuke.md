---
references:
  - "https://hacknote.jp/archives/13756/"
  - "https://github.com/rebuy-de/aws-nuke"
---

# aws-nukeを触ってみた

アカウント内のリソースを全削除してくれるライブラリ[aws-nuke](https://github.com/rebuy-de/aws-nuke)を触ってみました

## 環境構築

Cloudshellから実行してみる。configファイルを作成したいが、ブラウザ上で動くターミナルのvimでescキー押せなくて困ったので、以下のコマンド貼り付けで生成する。

```bash
cat <<EOF > config.yml
regions:
  - ap-northeast-1
  - global

account-blocklist:
  - "111222333444" # prod

accounts:
  "555666777888": {} # deleting
EOF
```

以下のコマンドでインストール

```bash
mkdir bin && wget -c "https://github.com/rebuy-de/aws-nuke/releases/download/v2.16.0/aws-nuke-v2.16.0-linux-amd64.tar.gz" -O - | sudo tar -xz -C $HOME/bin
```

以下のコマンドで実行する（引数なしがdryrunで対象リストとなる）

```bash
aws-nuke-v2.16.0-linux-amd64 -c config.yml
```
