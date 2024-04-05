---
tags: "Docker,Next.js,Ruby on Rails"
---

# WEBフレームワークをDockerで作るワンライナー

Next.jsとRuby on RailsのプロジェクトをDockerを通じて環境依存せず指定した言語バージョンで構築する

## アーキテクチャの指定

ローカルがM1 Macでデプロイ先が非armの時などケースバイケースで

```bash
export DOCKER_DEFAULT_PLATFORM=linux/amd64
```

## Ruby on Rails

```bash
docker run --rm -v $(pwd):/app -w /app ruby:3.1.1 bash -c "gem install rails && rails new my-backend-website"
```

## Next.js

```bash
docker run --rm -v $(pwd):/app -w /app node:17.8.0 npx create-next-app --example blog-starter-typescript my-frontend-website
```
