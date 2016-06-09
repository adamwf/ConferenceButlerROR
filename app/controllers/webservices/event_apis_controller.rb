class Webservices::EventApisController < ApplicationController
	before_filter :find_user, only: [:notification_list]


	def event_create
		@event = Event.create(event_params)
		if @event
			render :json =>  {:responseCode => 200,:responseMessage =>"Event has been created successfully.",:event => @event}
    	else
		    render :json =>  {:responseCode => 500,:responseMessage => @event.errors.full_messages.first}
    	end
	end


	def notification_list
		activities = []
		frnd_actity = @user.activities.where(activity_type: "friend_request").order("created_at DESC")
      	frnd_actity.each do |activity|
			user_name = activity.user.user_name
			notification_type = 'friend_request'
			notification_id = activity.user.id
			activities << activity.attributes.merge(user_id: activity.user.id, user_name: user_name,notification_type: notification_type,notification_id: notification_id)
		end
	
	  	render :json => {
          :response_code => 200,
          :response_message => "Notification list fetched successfully.",
          :reviews => activities.sort_by{|x| x["created_at"]}.reverse
        }
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

	def find_user
		if params[:user][:user_id]
			@user = User.find_by_id(params[:user][:user_id])
		    unless @user
		     render :json =>  {:responseCode => 500,:responseMessage => "Oops! User not found."}
		    end
		else
			render :json =>  {:responseCode => 500,:responseMessage => "Sorry! You are not an authenticated user."}
	    end
  	end
end