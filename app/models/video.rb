class Video < ActiveRecord::Base
  belongs_to :user

  mount_uploader :content, VideoUploader

  
end
