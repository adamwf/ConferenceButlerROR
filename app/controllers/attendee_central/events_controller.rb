class AttendeeCentral::EventsController < AttendeeCentral::BaseController

	before_filter :require_attendee

	def index 
		@user_events = UserEvent.all.order("created_at desc").map(&:event_id).uniq
		@event_list =[]
		@user_events.each do |id|
			@event_list << Event.find(id)
		end
		@event_list = @event_list.paginate(:page => params[:page], :per_page => 10)
	end

	def new
		@event = Event.new
	end

	def create
		@event = Event.new(event_params)
		if @event.save
			flash[:notice] = "You are create an event successfully."
          	redirect_to attendee_central_home_index_path 
		else
			redirect_to attendee_central_home_index_path
			flash[:error] = "You are unable create an event."
		end
	end

	private

	def event_params
      params.require(:event).permit(:name,:location,:start_time,:end_time,:category,:event_type,:no_of_availability,:availability,:user_id)
	end
end