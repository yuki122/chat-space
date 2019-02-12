class Message < ApplicationRecord
  belongs_to :group
  belongs_to :user

  # TODO: この書き方でいいのか
  validates :body, presence: true, if: "image.blank?"

  mount_uploader :image_path, MessageImageUploader
end
