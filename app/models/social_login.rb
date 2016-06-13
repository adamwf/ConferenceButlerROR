class SocialLogin < ActiveRecord::Base
  belongs_to :user
  has_one :social_code
 
end
