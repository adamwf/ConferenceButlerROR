class Post < ActiveRecord::Base

  	belongs_to :user

   # validates :user_id, presence: true
   validates :title, presence: true, length: { maximum: 30 }
   validates :content, presence: true, length: { maximum: 250 }
   
   scope :published, -> {where(:status => true)}
   scope :home, -> {where(:status => true)}
end
