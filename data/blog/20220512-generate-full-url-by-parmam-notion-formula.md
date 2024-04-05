---
tags: ['Notion']
date: '2022-05-12'
title: 'NotionのFormula使ってパスからフルURL生成'
summary: '整数のGithub Issue NoからIssue URLを生成したかった'
---

# NotionのFormula使ってパスからフルURL生成

整数のGithub Issue NoからIssue URLを生成したかった

`if(empty(prop("Github Issue No")), "", concat("https://github.com/umihico/hoge/issues/", format(prop("Github Issue No"))))`
