class AttendeeCentral::HomeController < AttendeeCentral::BaseController
	before_filter :current_attendee

	def index 
		@user_events = UserEvent.all.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
	end
end