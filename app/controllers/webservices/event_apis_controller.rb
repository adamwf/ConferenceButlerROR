class Webservices::EventApisController < ApplicationController

	def event_create
		@event = Event.create(event_params)
		if @event
			render :json =>  {:responseCode => 200,:responseMessage =>"Event has been created successfully.",:event => @event}
    	else
		    render :json =>  {:responseCode => 500,:responseMessage => @event.errors.full_messages.first}
    	end
	end

	def attendee_create
		@attendee = Attendee.create(attendee_params)
		if @attendee
			render :json =>  {:responseCode => 200,:responseMessage =>"Attendee has been created successfully with event name.",:attendee => @attendee}
    	else
		    render :json =>  {:responseCode => 500,:responseMessage => @attendee.errors.full_messages.first}
    	end
	end

	private
	def event_params
		params.require(:event).permit(:name, :location, :time, :organizer)
	end

	def attendee_params
		params.require(:attendee).permit(:title, :address, :company, :website, :email, :phone, :mobile, :approval_status)
	end
end