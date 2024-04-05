---
tags: "Github Actions"
date: '2023-05-27'
title: 'Github Actionsのログでマスキングされたsecretsを明らかにする'
---

# Github Actionsのログでマスキングされたsecretsを明らかにする

ログではマスキングされ、Settingsページで見てもヒントも一切ないGithub Actionsのsecrets。

ログのマスキングはシンプルな文字列一致でみていると思い、base64エンコードしたら当然表示されたので、その後decodeすることで無事取得できました。

スニペットとして残しておきます。

## 作ったワークフローはこちら

.github/workflows/secrets-digger.yml

```yml
name: Getting secrets

on:
  push: {}

jobs:
  check:
    runs-on: ubuntu-latest
    env:
      SECRET_TOKEN: ${{secrets.SECRET_TOKEN}}

    steps:
      - name: Checkout
        uses: actions/checkout@v3
        with:
          token: ${{ env.SECRET_TOKEN }}
      - name: Get secret
        run: |
          echo ${{ env.SECRET_TOKEN }} | base64
          # To decode the secret, run the following command:
          # echo <base64-encoded-secret> | base64 --decode

          # After that, don't forget to delete the logs.
```

このあとコメント通り得られた出力を`echo <ここに貼る> | base64 --decode`と出力すればおしまい

ワークフローの実行ログを消すこと忘れずに。

（レポのWrite権限ある人たちは同様の手法でいつでも見れちゃうので意味は薄いですが）
