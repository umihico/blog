---
tags: "Alfred"
references:
  - "https://www.alfredforum.com/topic/14793-solved-insert-todays-date-shortcut/"
  - "https://www.alfredforum.com/topic/5289-adding-today%E2%80%99s-date/"
title: 'Alfredで本日の日付を入力するショートカットを作る'
summary: '議事録、日報などなにかと必要になる本日の日付をショートカットで呼び出す方法を紹介します'
---

# Alfredで本日の日付を入力するショートカットを作る

議事録、日報などなにかと必要になる本日の日付をショートカットで呼び出す方法を紹介します

## 作り方

1. Workflowsタブを開き、＋ボタンからBlank Workflow
1. 作業スペースを右クリックして[Triggers→Hotkey](https://www.alfredapp.com/help/workflows/triggers/hotkey/)または[Inputs→Keyword](https://www.alfredapp.com/help/workflows/inputs/keyword/)など好みのトリガーを登録
1. 作成されたトリガーを右クリックして[Insert After→Outputs→Copy to Clipboard](https://www.alfredapp.com/help/workflows/outputs/copy-to-clipboard/)
1. テキストエリアに`{date:short}`を入力
1. `Automatically paste to front most app`にチェックしてSave

実行するとYYYY/MM/DD形式で現在の日付がペーストされる

## 他の日付フォーマットは？

Date and Time \[Sortable\]を開くと`{date:yyyy-MM-dd HH:mm:ss}`という書式が得られ、`{date:yyyy-MM-dd}`など無事改造することができた。
