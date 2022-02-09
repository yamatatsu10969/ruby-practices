# ls コマンド

## 目的

```ruby
標準出力について学ぶ
標準ライブラリの使い方を学ぶ
Enumeratorには、each以外に便利なメソッドがあることを学ぶ
RailsじゃないRubyプログラミングを学ぶ
メソッド分割を学ぶ
わかりやすい変数名メソッド名を学ぶ
```

## どうやって作成するか

### ls1

- 成果物
  - オプションなしの ls コマンドを作成する
- 条件
  - [lsコマンドを作る | FJORD BOOT CAMP（フィヨルドブートキャンプ）](https://bootcamp.fjord.jp/pages/ls-command#requirements)
- 調査
  - [x] 条件把握
  - [x] ファイルの取得方法を調べる（gem は使わない）→ Dirクラスを使う
  - [x] 実装方法考える
- 実装方法
  - [ ] テストケースの作成
  - [ ] テストファイル、ディレクトリ作成
  - [ ] カレントディレクトリの取得
  - [ ] ファイルの取得
  - [ ] 3列にするために、3つの配列に入れる
  - [ ] 順番に表示して、3列にする
  - [ ] インデントを揃える
  - [ ] テストが通るようにする

### ls2

- 成果物
  - `-a` オプションの ls コマンドを作成する
- 条件
  - [lsコマンドを作る | FJORD BOOT CAMP（フィヨルドブートキャンプ）](https://bootcamp.fjord.jp/pages/ls-command#requirements)
- 調査
  - [ ] 条件把握
  - [ ] ファイルの取得方法を調べる（gem は使わない）→ Dirクラスを使う
  - [ ] 実装方法考える
- 実装方法
  - [ ] テストケースの作成
  - [ ] オプションの取得
  - [ ] 隠しファイルの取得
  - [ ] 表示
  - [ ] テストが通るようにする

## 参考

- [【lsコマンド】大きな問題を小さく分解してから取り組む | FJORD BOOT CAMP（フィヨルドブートキャンプ）](https://bootcamp.fjord.jp/pages/279)
- [【67日目】lsコマンド#8 提出, wcコマンド#1 仕様確認 | FJORD BOOT CAMP（フィヨルドブートキャンプ）](https://bootcamp.fjord.jp/reports/17617)
- [プログラムを書くときの考え方 | FJORD BOOT CAMP（フィヨルドブートキャンプ）](https://bootcamp.fjord.jp/pages/147)

### 考え方

- [【新人プログラマ応援】開発タスクをアサインされたらどういう手順で進めるべきか - Qiita](https://qiita.com/jnchito/items/017487cd882091494298)
- [セルフマネジメントの必須スキル「タスクばらし」そのポイント | Social Change!](https://kuranuki.sonicgarden.jp/2016/07/task-break.html)
- [Rubyスクリプトにもmainメソッドを定義するといいかも、という話 - Qiita](https://qiita.com/jnchito/items/4b4cae54170cc2f4377e)
