
---
tags: "bash,jq,CI"
---

# CIのビルド用キャッシュとしてECRから最も適切なイメージタグを選ぶ

CIのビルド時にECRからキャッシュ用にイメージをプルするパターンは多いと思いますが、その際は簡単に最も日時が新しいイメージが選ばれがちかと思います。

しかし「最新のイメージをとる」方法では複数のブランチで複数人が交互にプッシュする状況で、例えば片方がnode_modulesなど依存関係に変更を加えるものであると、互いのキャッシュを活かせないことになります。
この解決法は「最新のイメージをとる」ことではなく、「自身のコミットログと一致する範囲での最新のイメージをとる」ことです。そうすることで、まだマージされてない他所のコミット（イメージ）をスキップして、自身の直系の先祖にあたるコミットのイメージをプルしますので、キャッシュ効率が高くなります。

## コード

jqを使って改善してみます。

```bash
commits=$(echo '['$(git log --oneline  --pretty=format:'"%H"' | paste -sd "," -)']' | jq) # commitidの配列化
tags=$(aws ecr describe-images --repository-name dev-jpn-next --query 'sort_by(imageDetails,& imagePushedAt)[].imageTags' | jq '. | flatten') # ecrタグの配列化（コミットID＝タグである前提）
diffs=$(jq -n --argjson tags $tags --argjson commits $commits '{"commits": $commits, "tags": $tags} | .commits-.tags') # ecrに無い差分の検出
tag=$(jq -n -r --argjson diffs $diffs --argjson commits $commits --argjson tags $tags '{"commits": $commits, "diffs": $diffs} | .commits-.diffs | .[0] // $tags[-1]')
# commitsからdiffs(差分)を引くことでcommitsとtagsの積集合を出し、最新[0]を抽出。重複がなければECRタグ上で最新ものを出す($tags[-1)
```

積集合を一発で出す方法が分からなかったので、このように2回引き算をしました
