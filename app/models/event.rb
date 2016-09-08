class Event < ActiveRecord::Base
	has_many :invitations, dependent: :destroy
	def start_time
        self.time  #Where 'start' is a attribute of type 'Date' accessible through MyModel's relationship
    end
end
