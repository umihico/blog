---
tags: ['Ruby on Rails']
date: '2022-08-24'
title: '全Rakeタスクにグローバルにhookをつける'
summary: '調べてみると`Rake::Task.tasks.each`で全タスクにenhanceする例が多く見つかったが、そうなると:environmentなど継承先のタスクにも付与されるからか、なぜか私の環境では実行したいタスクより先に実行されてしまった。 これを防ぎ正しく後から実行するには`Rake::Task[Rake.application.top_level_tasks[0]]`と指定する必要があった'
---

# 全Rakeタスクにグローバルにhookをつける

調べてみると`Rake::Task.tasks.each`で全タスクにenhanceする例が多く見つかったが、そうなると:environmentなど継承先のタスクにも付与されるからか、なぜか私の環境では実行したいタスクより先に実行されてしまった。
これを防ぎ正しく後から実行するには`Rake::Task[Rake.application.top_level_tasks[0]]`と指定する必要があった

## コード

```ruby
# lib/tasks/hooks.rake
namespace :hooks do
  desc "Rakeタスクの実行ログを記録するラッパー"
  task after_rake: :environment do
    puts "Doing #{Rake.application.top_level_tasks[0]}"
  end
end

# Rakefile
require_relative "config/application"

Rails.application.load_tasks

Rake::Task[Rake.application.top_level_tasks[0]].enhance do
  Rake::Task["hooks:after_rake"].invoke
end
```
