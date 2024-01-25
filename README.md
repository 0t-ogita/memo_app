## 概要
sinatra を使用して作成した簡単なメモアプリです。<br>
メモを作成、編集、削除が行えます。

## 手順
ファイルを置くディレクトリに移動し、<br>
`git clone`を実行してローカルに複製してください。
```
$ git clone git@github.com:0t-ogita/memoTest.git
```
`memo_app`に移動し`bundle install`を実行して<br>
必要な gem をインストールしてください。
```
$ cd memo_app
$ bundle install
```
### WSLの場合は下記の①、②の手順を行ってください。
#### ①`memo.rb`の下記の部分を変更してください。
Postgreをインストールした時、自動で`postgres`というユーザー名が作られます。WSLであれば作成時パスワードの設定を行っていると思いますので、`postgres`というユーザー名、設定したパスワードを追記してください。
```
def conn
  @conn ||= PG.connect( dbname: 'postgres' )
end
↓
def conn
  @conn ||= PG.connect( dbname: 'postgres', user: 'postgres', password: '設定したパスワード' )
end
```
#### ②認証方法を変更してください。
`etc/postgresql/15/main`にある`pg_hda.conf`の中身を書き換え認証方法の変更を行ってください。
ターミナルで開き、当該ディレクトリまで移動します。
```
$ cd etc/postgresql/15/main
```
viコマンドでユーザー名が`postgres`の認証方法を`peer`から`md5`に変更してください。保存する時はコマンドモードにして`wq`で保存できます。
```
$ vi pg_hda.conf
```
### ここから共通
psqlサーバを下記のコマンドで立ち上げでください。
```
sudo /etc/init.d/postgresql start
```
`memo.rb`で実行し`http://localhost:4567`にアクセスると<br>
メモアプリを使用できます。<br>
```
$ ruby memo.rb
```
終了する時は`Ctrl + C`で終了できます。
また、psqlサーバを終了する時は下記のコマンドを実行します。
```
sudo /etc/init.d/postgresql stop
```
