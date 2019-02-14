class Group < ApplicationRecord
  has_many :members
  has_many :users, through: :members
  has_many :messages
  validates :name, presence: true

  def show_last_message
    if(last_message = self.messages.order("created_at").last)
      last_message.body? ? last_message.body : "画像が投稿されました"
    else
      "まだメッセージがありません"
    end
  end
end
