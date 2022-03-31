
---
references:
  - "https://hacknote.jp/archives/13756/"
  - "https://github.com/rebuy-de/aws-nuke"
---

# aws-nukeを触ってみた

アカウント内のリソースを全削除してくれるライブラリ[aws-nuke](https://github.com/rebuy-de/aws-nuke)を触ってみました

## config.ymlの用意

Cloudshellから実行してみる。configファイルを作成したいが、ブラウザ上で動くターミナルのvimでescキー押せなくて困ったので、以下のコマンド貼り付けで生成する。

```bash
THIS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

cat <<EOF > config.yml
regions:
  - ap-northeast-1
  - global

account-blocklist:
  - "000000000000" # https://github.com/rebuy-de/aws-nuke/issues/520

resource-types:
  targets:
    - IAMRole

accounts:
  $THIS_ACCOUNT_ID:
    filters:
      IAMRole:
      - "OrganizationAccountAccessRole"
EOF
```

最初は削除したくない`OrganizationAccountAccessRole`が適切に除外されているか確認したかったが、削除対象が多すぎて見ることができなかった。以下の設定をconfig.ymlに足して削除対象をIAMロールだけにフィルターしてdry-runして確認できた。

```yml
resource-types:
  targets:
    - IAMRole
```

## アカウントエイリアスつける

[エイリアスつける必要があった。](https://docs.aws.amazon.com/IAM/latest/UserGuide/console_account-alias.html)無いと以下のエラーが発生

`Error: The specified account doesn't have an alias. For safety reasons you need to specify an account alias. Your production account should contain the term 'prod'.`

## バイナリのインストール

```bash
mkdir bin && wget -c "https://github.com/rebuy-de/aws-nuke/releases/download/v2.16.0/aws-nuke-v2.16.0-linux-amd64.tar.gz" -O - | sudo tar -xz -C $HOME/bin
```

## 実行（ドライラン）

```bash
aws-nuke-v2.16.0-linux-amd64 -c config.yml
```
