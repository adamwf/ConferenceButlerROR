class HandleDirectory::HomeController < HandleDirectory::BaseController
	before_filter :require_user

	# layout 'handle_directory'

	def index 
		@events = Event.all
	end

end
