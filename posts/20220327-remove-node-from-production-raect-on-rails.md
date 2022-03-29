# React on Railsで本番イメージをNodeレスにした

Nextとしてサーバーを建てるのではなく、RailsのViewからscriptタグでJS配信するだけなら、本番イメージ内にインストールする必要ないのでは？と思ったらできた話

## 1. Dockerfileからnodeを取り除く

よくある下記のようなDockerfileではこれだけで数百MBイメージサイズが増える。これを外す

```Dockerfile
RUN apt-get install -y nodejs npm && \
  npm install -g yarn

COPY package.json yarn.lock ./
RUN yarn install
```

## 2. assets:precomplieはCircleCIでやる

こんな感じでorbsをフル活用するとスムーズにDockerfile外でビルドできた。rubyもnodeもキャッシュをよしなにしてくれるのでとても高速

```yml
version: "2.1"

orbs:
  ruby: circleci/ruby@1.4.0
  node: circleci/node@5.0.0

jobs:
  check:
    docker:
      - image: cimg/ruby:3.1-node
    steps:
      - checkout
      - ruby/install-deps
      - node/install-packages:
          check-cache: detect
          pkg-manager: yarn
      - run: bin/rails assets:precompile
```

## 3. manifestをイメージに追加する

S3からの配信を予定しているが、マニフェストファイルだけはイメージに取り込まないと`javascript_pack_tag`などが正常に動作しなかった。

webpackerのものは`public/packs/manifest.json`と固定値だが、アセットパイプライン本体のものは`public/assets/.sprockets-manifest-<< hash >>.json`といった動的なパスになる。

Dockerfileでは`COPY . .`して全追加する際にマニフェストだけは追加しつつJS、CSSは除外するように`.dockerignore`を調整した。

```bash
/public/assets
!public/assets/.sprockets-manifest-*.json
/public/packs
!public/packs/manifest*
```

なおCI上でこのままAWS CLIを使ってS3に丸ごとアップロードすれば、Rails内に`asset_sync`, `fog-aws`を追加する必要もない。

最後にCDN配信なので、asset_syncを使わない場合は`config.asset_host = ENV['CDN_HOST']`といった具合にホストを指定して無事に配信ができた。
