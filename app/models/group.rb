class Group < ApplicationRecord
  has_many :members
  has_many :users, through: :members
  has_many :messages
  validates :name, presence: true

  def last_message
    self.messages.order("created_at").last
  end
end
