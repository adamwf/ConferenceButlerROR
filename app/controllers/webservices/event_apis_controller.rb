require 'will_paginate/array'
class Webservices::EventApisController < ApplicationController
	before_filter :find_user, only: [:notification_list, :generate_qr, :add_social_login, :profile_view]
	before_filter :authentication

	def home
		@video = Video.where(category: "home")
		@video = @video.order("created_at desc").paginate(:page => params[:page], :per_page => 3)
		@post = Post.where(category: "home")
		@post = @post.order("created_at desc").paginate(:page => params[:page], :per_page => 3)
		@advertisement = Advertisement.where(category: "home")
		@advertisement = @advertisement.order("priority asc").paginate(:page => params[:page], :per_page => 3)
		@feeds=[]
		feed = @video.zip(@post)
		feeds = feed.zip(@advertisement)
		feeds = feeds.each{|feed| @feeds.push(feed.flatten)}
		data = {}
		@feeds.each_with_index do |x,i|
      		x.each_with_index do |y,j|
        		if y.eql?(nil)
          		 	@feeds[i][j] = data
        		end
        	end
      	end
		render :json =>  {:responseCode => 200,:responseMessage =>"Welcome to Conference Butler.",:feeds => @feeds}#.each{|x| x.compact}}
	end

	def notification_list
		activities = []
		frnd_actity = @user.activities.where(activity_type: "friend_request").order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
      	frnd_actity.each do |activity|
			user_name = activity.user.user_name
			notification_type = 'friend_request'
			notification_id = activity.user.id
			activities << activity.attributes.merge(user_id: activity.user.id, user_name: user_name,notification_type: notification_type,notification_id: notification_id)
		end	
	  	render :json => {:responseCode => 200,:response_message => "Notification list fetched successfully.",:reviews => activities.sort_by{|x| x["created_at"]}.reverse }
	end

	def generate_qr
		if @qr_image = SocialCode.generate_qr
			@social_code = SocialCode.find_or_create_by!(user_id: @user.id)
			@social_code.update_attributes(code: @qr_image["original_filename"], image: @qr_image["url"])
			render :json =>  {:responseCode => 200,:responseMessage =>"Your QR Code created successfully.",:social_code => @social_code}
    	else
		   render_message 500, "Sorry! Your QR code not generated, Please try again."
		end
	end

	def scan_qr
		if @qr = SocialCode.find_by(code: params[:code])
			@user = User.find_by_id(@qr.user_id)
			@social_profile = SocialLogin.where(user_id: @qr.user_id)
			if @user
				unless ProfileView.find_or_create_by(viewer_id: params[:viewer_id], user_id: @user.id)
					if @trend = Trending.find_by_user_id(@user.id)
						@trend.update_attributes(count: @trend.count+1)
					else 
						@trend = Trending.create(user_id: @user.id, count: 1)
					end
				end
				render :json =>  {:responseCode => 200,:responseMessage =>"You are scan #{@user.user_name}'s QR Code successfully.",:profile => @user.attributes.merge(:social_profile => @social_profile)}
	    	else
			    render_message 500, "Oops! User not found."
			end
		else
		    render_message 500, "Sorry! This is not an authenticated QR code."
		end
	end

	def profile_view
		@profile = ProfileView.where(user_id: @user.id)#.map(&:viewer_id)
		@viewer=[]
		@profile.map do |profile| 
			@profile = profile
			user = User.find_by(id: profile)
			@viewer << user unless user.eql?(nil)
		end
		render :json =>  {:responseCode => 200,:responseMessage =>"You are find successfully your profile viewer list.",:profile_viewer => @viewer.map {|viewer| viewer.attributes.merge(is_friend: viewer.friend_with?(@user), profile_view_time: @profile.updated_at.localtime).compact}.paginate(:page => params[:page], :per_page => 3) }
	end

	def trending
		@trend = Trending.all.order("count desc").paginate(:page => params[:page], :per_page => 10)
		render :json =>  {:responseCode => 200,:responseMessage =>"Top Trending profiles of Conference Butler is find successfully.",:trending_profiles => @trend.map(&:user_id).map{|profile| User.find_by(id: x)} }
	end

	def add_social_login
		@social_profile = SocialLogin.find_or_create_by(provider: params[:user][:provider], u_id: params[:user][:u_id], user_name: params[:user][:user_name], user_id: @user.id)
		if @social_profile
			render :json => {:responseCode => 200, :responseMessage => "Your social login is add in your social profile.", :profile => @user, :social_profile => @social_profile}
		else
			render_message 500, "Your social login is not added in your social profile, Please try again." 
		end
	end

	def event_list
		@event = Event.all.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
		render :json =>  {:responseCode => 200,:responseMessage =>"Event list find successfully.",:event_list => @event}
	end

	# def attendee_create
	# 	@attendee = Attendee.create(attendee_params)
	# 	if @attendee
	# 		render :json =>  {:responseCode => 200,:responseMessage =>"Attendee has been created successfully with event name.",:attendee => @attendee}
 #    	else
	# 	    render_message 500, @attendee.errors.full_messages.first
 #    	end
	# end

	private
	def event_params
		params.require(:event).permit(:name, :location, :time, :organizer)
	end

	# def attendee_params
	# 	params.require(:attendee).permit(:title, :address, :company, :website, :email, :phone, :mobile, :approval_status)
	# end

	# def find_user
	# 	if params[:user][:user_id]
	# 		@user = User.find_by_id(params[:user][:user_id])
	# 	    unless @user
	# 	     render_message 500, "Oops! User not found."
	# 	    end
	# 	else
	# 		render_message 500, "Sorry! You are not an authenticated user."
	#     end
 #  	end
end