class Group < ActiveRecord::Base
  mount_uploader :group_image, ImageUploader
  
  belongs_to :user
  has_many :group_memberships ,:dependent => :destroy
  has_many :users , :through => :group_memberships

  validates :group_name, presence: true
end
