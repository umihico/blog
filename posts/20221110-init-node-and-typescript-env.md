---
tags: "Node,TypeScript"
---

# Node,TypeScript環境の構築メモ

curlとjqでゴニョゴニョやるのが辛くなってきたり、API以外にもライブラリで提供されている場合に速やかに叩けるようにメモ。ライブラリで型ついてると、Github Copilotも最大限活きるので、とても高速に開発できました

## nodeの環境構築

```bash
brew install anyenv # インストール済みならスキップ
anyenv install nodenv # インストール済みならスキップ
eval "$(anyenv init -)"  # .bashrc/.zshrcにあればスキップ
nodenv install -l # バージョンを選んでメモる
echo 19.0.1 > .node-version # 選んだバージョンを出力
nodenv install $(cat .node-version) # インストール済みバージョンならスキップ 
nodenv local $(cat .node-version) # シェル再起動するなら.node-version存在する時点で不要かも
wget "https://raw.githubusercontent.com/github/gitignore/main/Node.gitignore" -O ".gitignore"
```

## TypeScriptの環境構築

```bash
yarn add --dev typescript @types/node ts-node prettier eslint eslint-config-prettier
npx tsc --init # tsconfig.jsonを生成する
npx eslint --init # 以下のように答えた(typescriptで書いてローカル/CIでnodeを実行したいだけのケース)
# ✔ How would you like to use ESLint? · style
# ✔ What type of modules does your project use? · esm
# ✔ Which framework does your project use? · none
# ✔ Does your project use TypeScript? · No / Yes
# ✔ Where does your code run? · browser
# ✔ How would you like to define a style for your project? · guide
# ✔ Which style guide do you want to follow? · standard-with-typescript
# ✔ What format do you want your config file to be in? · YAML
# ✔ Would you like to install them now? · No / Yes
# ✔ Which package manager do you want to use? · yarn
cat <<EOF > .prettierrc.yml
semi: false
singleQuote: false
trailingComma: all
EOF
yq '.extends = [.extends, "prettier"]' -i .eslintrc.yml
yq '.parserOptions += {"project": "./tsconfig.json"}' -i .eslintrc.yml
```
