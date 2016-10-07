class Group < ActiveRecord::Base
  mount_uploader :group_image, ImageUploader
  
  belongs_to :user
  has_many :group_memberships, dependent: :destroy
  has_many :members,:class_name => 'User',through: :group_memberships, :source => :user
  

  validates :group_name, presence: true
end
