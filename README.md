# README
## DB設計

### usersテーブル
- 登録ユーザ

|column|type|Options|index|
|------|----|-------|:---:|
|email|string|null: false, unique: true|o|
|name|string|null: false, unique: true|o|
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
|user|references|null: false, foreign_key| |
|group|references|null:false, foreign_key| |

#### Association
- belogns_to :group
- belongs_to :user

### messagesテーブル
|column|type|Options|index|
|------|----|-------|:---:|
|body|text|||
|image|string|||
|group|references|null: false, foreign_key| |
|user|references|null: false, foreign_key| |

#### Association
- belongs_to :group
- belongs_to :user
