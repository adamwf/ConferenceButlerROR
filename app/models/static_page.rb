class StaticPage < ActiveRecord::Base

	validates :title, presence: true, length: { maximum: 30 }
   validates :content, presence: true, length: { maximum: 300 }
end
