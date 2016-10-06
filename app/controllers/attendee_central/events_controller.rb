class AttendeeCentral::EventsController < AttendeeCentral::BaseController

	before_filter :current_attendee

	def index 
	end

	def new
		@event = Event.new
	end

	def create
		@event = Event.new(event_params)
		@event.update(role: "organiser")
		@event.generate_auth_token
		if @event.save
			flash[:notice] = "You are create an event successfully."
          	redirect_to attendee_central_home_index_path
		else
			redirect_to attendee_central_home_index_path
			flash[:error] = "You are unable create an event."
		end
	end
end