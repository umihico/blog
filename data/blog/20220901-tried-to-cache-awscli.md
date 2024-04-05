---
tags: "CircleCI,AWS"
---

# AWSCLIのインストールにキャッシュを使ってみたけど大して減らなかった話

ジョブ毎に[https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip](https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip)からダウンロードしてるのでこれをCircleCIのキャッシュを入れてみましたが、もともと３秒の処理時間は全く改善しなかった話

## Before

```yml
  - run:
    name: Install aws-cli
    command: |
      curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
      unzip -q awscliv2.zip
      sudo ./aws/install
```

## After

```yml
  - when:
    condition: true
    steps:
      - restore_cache:
          key: awscli-exe-linux-x86_64_zip_20220831
      - run:
          name: Install aws-cli
          command: |
            [ ! -f /tmp/awscliv2.zip ] && curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
            unzip -q awscliv2.zip
            sudo ./aws/install
          working_directory: /tmp
      - save_cache:
          key: awscli-exe-linux-x86_64_zip_20220831
          paths:
            - /tmp/awscliv2.zip
```

インスタンスサイズsmallでも３秒（たまに2秒）だったものが1秒+2秒+0秒と全く変わらない結果に。むしろたまに2秒だけなので負けてる疑惑さえある。

ネットワーク消費減って課金が微減したかもしれないけど、コードの複雑性を増してまで得るメリットではないので戻そう、、

そもそも全ジョブに入ってるとはいえ、３秒のものを更に減らそうとすべきじゃなかった
