# 投稿アプリ API（myhomework-Rails）

> **授業課題（学習目的）** — フロントエンドとバックエンドを別リポジトリに分け、REST API 経由で連携させる構成を学ぶために作ったもの。
> フロントエンド: **[myhomework-React-](https://github.com/Asuma09/myhomework-React-)**

投稿といいねを扱う JSON API。React 側から `fetch` で呼び出す。

**Ruby on Rails 8.0.1（API モード）/ PostgreSQL / rack-cors**

---

## 学んだこと

このリポジトリの目的は「1つのアプリの中で画面と DB を往復する」のではなく、**別オリジンのフロントエンドから呼ばれる API を作る**ことだった。そのため意識したのは次の2点。

- **ビューを返さない。** Rails を API モードで作り、レスポンスは JSON だけにした
- **CORS を通す。** フロントエンドが別ポート（Vite の開発サーバ）で動くため、`rack-cors` でオリジンを許可しないとブラウザがリクエストを拒否する。この設定の必要性を実際に詰まって理解した

## API

```ruby
get "up"                    # ヘルスチェック
root "posts#index"

resources :posts, only: [:index, :show, :create, :update, :destroy] do
  resources :likes, only: [:create, :destroy]
end
```

いいねは「投稿に属するもの」なのでネストさせ、`POST /posts/:post_id/likes` で表現している。独立した `/likes` にすると、どの投稿へのいいねかをリクエストボディで渡すことになり、URL が構造を表さなくなる。

## データ構造

```
posts : id, username, title, content, likes_count (default: 0)
likes : id, user_id, post_id
users : id, email, encrypted_password, reset_password_token, ...
```

`posts.likes_count` にカウントを持たせている。一覧表示のたびに `likes` を数えずに済むが、`likes` の実レコードとの整合を自分で保つ必要がある（カウンタキャッシュの考え方）。

## セットアップ

```bash
bundle install
rails db:create db:migrate
rails s        # http://localhost:3000
```

フロントエンド側は `myhomework-React-` を `npm run dev` で起動する。

## 制約

- **授業課題として作ったものなので、認証が完成していない。** `users` テーブルは用意してあるが、API 側でログイン必須にはしておらず、いいねは `user_id` をリクエストから受け取る形になっている
- バリデーションとエラーレスポンスの整備は最小限
- テストは書いていない
