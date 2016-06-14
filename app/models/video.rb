class Video < ActiveRecord::Base
  belongs_to :user

  mount_uploader :content, VideoUploader
  
  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true
  validates :discription, presence: true, length: { maximum: 250 }
  # validates :user_id, presence: true
end
