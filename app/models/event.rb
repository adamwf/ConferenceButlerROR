class Event < ActiveRecord::Base
	has_many :invitations, dependent: :destroy
	has_many :user_events, dependent: :destroy
	has_many :users, through: :user_events

end
