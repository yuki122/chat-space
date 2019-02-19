class Message < ApplicationRecord
  TIME_FORMAT = '%Y年%m月%d日 %H:%M:%S'

  belongs_to :group
  belongs_to :user

  validates :body, presence: true, if: "image.blank?"

  mount_uploader :image, MessageImageUploader

  def created_at_for_disp
    created_at.strftime(TIME_FORMAT)
  end
end
