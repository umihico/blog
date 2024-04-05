---
tags: "Docker,ChatGPT"
date: '2023-08-12'
---

# DockerでChatGPTを立ち上げるエイリアスで、月20ドルの課金をケチる

APIキーで動かせる良いオープンソースのChatGPTのUIがあり、これを使う方が月20ドル課金してchat.openai.comで会話するより安上がりです。
このオープンソースのUIをクイックに起動できるエイリアスを紹介します。

## 使うのはmckaywrigley/chatbot-uiのDockerイメージ

https://github.com/mckaywrigley/chatbot-ui

このUIが優秀で、VercelでのデプロイやDocker Imageをサポートしています。

以下のコマンドで簡単にイメージを立ち上げることができます。

```bash
docker run -d -e DEFAULT_MODEL=gpt-4 -e OPENAI_API_KEY=${OPENAI_API_KEY} -p 7464:3000 ghcr.io/mckaywrigley/chatbot-ui:main
```

## エイリアス化していく

問題はこのコマンドだと、既に１つ起動してたら２個めの起動はポート重複で失敗することです。こちらは先にcurlしてレスポンスが無いときだけ、新規に起動するように設定して回避しました。
また、Chromeの起動も一緒にしてほしいので、それも追記します。
他にも、ghcr.ioにログインしないといけないですね。

エイリアスは以下のようになりました。

```bash
function chat() {
  curl --silent --output /dev/null "http://localhost:7464"
  if [ $? -ne 0 ]; then
    # docker stop $(docker ps -a -q  --filter ancestor=ghcr.io/mckaywrigley/chatbot-ui:main)
    echo $(gh config get -h github.com oauth_token) | docker login ghcr.io -u umihico --password-stdin
    docker run -d -e DEFAULT_MODEL=gpt-4 -e OPENAI_API_KEY=${OPENAI_API_KEY} -p 7464:3000 ghcr.io/mckaywrigley/chatbot-ui:main
  fi
  open -a 'Google Chrome' 'http://localhost:7464'
}
```
