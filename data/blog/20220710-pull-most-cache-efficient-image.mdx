---
tags: ['bash', 'jq', 'CI']
date: '2022-07-10'
title: 'CIのビルド用キャッシュとしてECRから最も適切なイメージタグを選んでみた'
summary: 'CIのビルド時にECRからキャッシュ用にイメージをプルするパターンは多いと思いますが、その際は簡単に最も日時が新しいイメージが選ばれがちかと思います。  しかし「最新のイメージをとる」方法では複数のブランチで複数人が交互にプッシュする状況で、例えば片方がnode_modulesなど依存関係に変更を加えるものであると、互いのキャッシュを活かせないことになります。 この解決法は「最新のイメージをとる」ことではなく、「自身のコミットログと一致する範囲での最新のイメージをとる」ことです。そうすることで、まだマージされてない他所のコミット（イメージ）をスキップして、自身の直系の先祖にあたるコミットのイメージをプルしますので、キャッシュ効率が高くなります。'
---

# CIのビルド用キャッシュとしてECRから最も適切なイメージタグを選んでみた

CIのビルド時にECRからキャッシュ用にイメージをプルするパターンは多いと思いますが、その際は簡単に最も日時が新しいイメージが選ばれがちかと思います。

しかし「最新のイメージをとる」方法では複数のブランチで複数人が交互にプッシュする状況で、例えば片方がnode_modulesなど依存関係に変更を加えるものであると、互いのキャッシュを活かせないことになります。
この解決法は「最新のイメージをとる」ことではなく、「自身のコミットログと一致する範囲での最新のイメージをとる」ことです。そうすることで、まだマージされてない他所のコミット（イメージ）をスキップして、自身の直系の先祖にあたるコミットのイメージをプルしますので、キャッシュ効率が高くなります。

## コード

CircleCIのイメージにインストール済みのjqを使って実装してみます。

```bash
commits=$(echo '['$(git log -100 --oneline  --pretty=format:'"%H"' | paste -sd "," -)']' | jq '@json') # commitidの配列化
fetch_closest_tag () {
  tags=$(aws ecr describe-images --repository-name $1 --query 'sort_by(imageDetails,& imagePushedAt)[].imageTags' --region $2 | jq '. | flatten | @json') # ecrタグの配列化（コミットID＝タグである前提）
  diffs=$(jq -n --argjson tags $tags --argjson commits $commits '{"commits": $commits|fromjson, "tags": $tags|fromjson} | .commits-.tags | @json') # ecrに無い差分の検出
  jq -n -r --argjson diffs $diffs --argjson commits $commits --argjson tags $tags '{"commits": $commits|fromjson, "diffs": $diffs|fromjson} | .commits-.diffs | .[0] // ($tags|fromjson[-1])'
  # commitsからdiffs(差分)を引くことでcommitsとtagsの積集合を出し、最新[0]を抽出。重複がなければECRタグ上で最新ものを出す
}
export JPN_NEXT_CACHE_TAG=$(fetch_closest_tag << pipeline.parameters.env >>-jpn-next ${<< parameters.jpn-region >>})
export USA_NEXT_CACHE_TAG=$(fetch_closest_tag << pipeline.parameters.env >>-usa-next ${<< parameters.usa-region >>})

```

複数回使うので関数にして呼び出しています。積集合を一発で出す方法が分からなかったので、このように2回引き算をしました。ローカルでは動作したものの、CircleCI上では何故かjqのアウトプットをjqが--argjsonで使おうとするとparse errorを吐くので、`@json`と`fromjson`を使って受け渡しはJSONエンコードしたものにしています。
