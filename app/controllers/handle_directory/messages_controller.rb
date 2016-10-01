class HandleDirectory::MessagesController < HandleDirectory::BaseController
	before_filter :current_handle_user

	def index 
	end
end
