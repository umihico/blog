---
tags: "Google App Script"
excerpt: '某サイトからCSVのインポートをよく行うのですが、インポートしたデータを使った後に毎度足したシートが増えており、消すのも大変なのでスクリプトを書きました。'
date: '2022-03-30'
title: 'シート名の先頭が一致する全シートを削除する（Google Spreadsheet）'
---

# シート名の先頭が一致する全シートを削除する（Google Spreadsheet）

某サイトからCSVのインポートをよく行うのですが、インポートしたデータを使った後に毎度足したシートが増えており、消すのも大変なのでスクリプトを書きました。

例として`users`から始まる全てのシートを除去するスクリプトです。

```JavaScript
function delete_sheets_by_prefix() {
  const spreadsheet = SpreadsheetApp.getActive();
  const sheets = spreadsheet.getSheets();
  for(let sheet of sheets){
    if(sheet.getName().startsWith("users")) spreadsheet.deleteSheet(sheet);
  }
}
```
