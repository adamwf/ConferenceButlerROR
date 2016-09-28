class Message < ActiveRecord::Base
  mount_uploader :video, VideoUploader
  mount_uploader :image, ImageUploader

  belongs_to :room
  belongs_to :sender,:class_name => 'User', :foreign_key => 'sender_id'
  belongs_to :reciever, -> { where(is_group: false) },:class_name => 'User', :foreign_key => 'assoc_id'

  scope :group_msgs, -> { where(is_group: true) }
  scope :one_to_one_msgs, -> { where(is_group: false) }
end
