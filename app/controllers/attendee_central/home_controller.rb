require 'will_paginate/array'
class AttendeeCentral::HomeController < AttendeeCentral::BaseController
	before_filter :require_attendee, except: [:new, :create]

	def index 
		@user_events = UserEvent.all.order("created_at desc").map(&:event_id).uniq
		@event_list =[]
		@user_events.each do |id|
			@event_list << Event.find(id)
		end
		@event_list = @event_list.paginate(:page => params[:page], :per_page => 10)
		@invitations = Invitation.where(reciever_id: current_attendee.id).paginate(:page => params[:page], :per_page => 10)
		@_tab = params[:tab].present? ? params[:tab] : 1
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		@user.update(role: "organiser")
		@user.generate_auth_token
		if @user.save
			UserMailer.signup_confirmation(@user).deliver_now
			flash[:notice] = "You are successfully registered!"
          	redirect_to attendee_central_home_index_path
		else
			redirect_to attendee_central_home_index_path
			flash[:error] = @user.errors.full_messages
		end
	end
end