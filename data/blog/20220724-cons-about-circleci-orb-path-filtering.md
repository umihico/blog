---
tags: "CircleCI"
references:
  - "https://circleci.com/developer/orbs/orb/circleci/path-filtering"
  - "https://blog.adachin.me/archives/48488"
  - "https://zenn.dev/korosuke613/scraps/74e6ccaf6f8b67"
date: '2022-07-24'
title: 'circleci/path-filteringの欠点'
---
# circleci/path-filteringの欠点

モノレポ運用をしてるPJにて、導入寸前まで思案したcircleci/path-filteringというorbsですが、導入を諦めた懸念点をメモします

## ズバリ冪等性が下がる
指定したフォルダ配下の変更点を検知して条件分岐を可能にするというのはモノレポ運用時に実行する必要があるワークフローだけを実行できとてもエコで魅力的でした。問題点は差分というのが「何と比較して」であると思います。

ドキュメントによると`base-revision`というパラメータに比較対象のブランチを指定するようで、デフォは`main`、つまりブランチを指定するということ。これはCircleCIのジョブをrerunした時に、比較対象ブランチの状態が不定であるため、同一HEADのrerunにも関わらず、どのワークフローが走るかがタイミング毎に異なるリスクがあるということです。

本番デプロイしてやらかした際に、手っ取り早く一つ前のCIをrerunすればロールバックできる仕組みであってほしいですが、想定のワークフローが起動しない、別のワークフローが起動するリスクを考慮したくないと思いました。

ブランチを指定する仕様にケチをつけるつもりはなく、極めて妥当だと思います。しかし無茶を承知で欲を言えば、rerunした時には初回runと常に同じon/offが設定されてここの冪等性は確保されてほしいと思いました。
