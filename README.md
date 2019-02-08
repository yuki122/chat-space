# README
## DB設計

### usersテーブル
- 登録ユーザ

|column|type|Options|index|
|------|----|-------|:---:|
|email|string|null: false, unique: true|o|
|name|string|null: false||
|devise_defaults||||

#### Association
- has_many :members
- has_many :groups through :members
- has_many :messages

### groupsテーブル
- usersが所属するチャットルーム

|column|type|Options|index|
|------|----|-------|:---:|
|name|string|null:false||

#### Association
- has_many :members
- has_many :users through :members
- has_many :messages

### membersテーブル
- usersとgroupsの中間テーブル

|column|type|Options|index|
|------|----|-------|:---:|
|user_id|integer|null: false, foreign_key| |
|group_id|integer|null:false, foreign_key| |

#### Association
- belogns_to :group
- belongs_to :user

### messagesテーブル
|column|type|Options|index|
|------|----|-------|:---:|
|body|text|null:false||
|image|string|||
|group_id|integer|null: false, foreign_key| |
|user_id|integer|null: false, foreign_key| |

#### Association
- belongs_to :group
- belongs_to :user


This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
# chat-space
