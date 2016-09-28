class GroupMembership < ActiveRecord::Base
  mount_uploader :group_image, ImageUploader

  belongs_to :group
  belongs_to :user
  has_many :group_memberships ,:dependent => :destroy

  validates :group_name, presence: true
end
