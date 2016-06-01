class SocialCode < ActiveRecord::Base
  belongs_to :user
  has_many :social_logins
end
