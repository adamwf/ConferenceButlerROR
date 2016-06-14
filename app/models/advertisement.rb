class Advertisement < ActiveRecord::Base
  belongs_to :user

  mount_uploader :image, ImageUploader

  
  validates :title, presence: true, length: { maximum: 30 }
  validates :image, presence: true
  validates :discription, presence: true, length: { maximum: 250 }
  # validates :user_id, presence: true
  # validates :priority, presence: true#, uniqueness: true
end
