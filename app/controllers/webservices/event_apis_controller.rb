class Webservices::EventApisController < ApplicationController
	before_filter :find_user, only: [:notification_list, :generate_qr, :add_social_login]


	def home
		@video = Video.all.order("created_at desc").paginate(:page => params[:page], :per_page => 1)
		@post = Post.all.order("created_at desc").paginate(:page => params[:page], :per_page => 1)
		@advertisement = Advertisement.all.order("priority asc").paginate(:page => params[:page], :per_page => 1)
		render :json =>  {:responseCode => 200,:responseMessage =>"Welcome to Conference Butler.",:video => @video, :post => @post, :advertisement => @advertisement}
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
	
	  	render :json => {:response_code => 200,:response_message => "Notification list fetched successfully.",:reviews => activities.sort_by{|x| x["created_at"]}.reverse }
	end

	def generate_qr
		if @qr_image = SocialCode.generate_qr
			@social_code = SocialCode.create(code: @qr_image["public_id"], image: @qr_image["url"], user_id: @user.id)
			render :json =>  {:responseCode => 200,:responseMessage =>"Your QR Code created successfully.",:social_code => @social_code}
    	else
		    render :json =>  {:responseCode => 500,:responseMessage => "Sorry! Your QR code not generated, Please try again."}
		end
	end

	def scan_qr
		if @qr = SocialCode.find_by(code: params[:code])
			@user = User.find_by_id(@qr.user_id)
			@social_profile = SocialLogin.find_by_user_id(@qr.user_id)
			if @user
				unless ProfileView.find_by(viewer_id: params[:viewer_id], user_id: @user.id)
					ProfileView.create(viewer_id: params[:viewer_id], user_id: @user.id)
					if @trend = Trending.find_by_user_id(@user.id)
						@trend.update_attributes(count: @trend.count+1)
					else 
						@trend = Trending.create(user_id: @user.id, count: 1)
					end
				end
				render :json =>  {:responseCode => 200,:responseMessage =>"You are scan #{@user.user_name}'s QR Code successfully.",:profile => @user, :social_profile => @social_profile}
	    	else
			    render :json =>  {:responseCode => 500,:responseMessage => "Oops! User not found."}
			end
		else
		    render :json =>  {:responseCode => 500,:responseMessage => "Sorry! This is not an authenticated QR code."}
		end
	end

	def trending
		@trend = Trending.all.order("count desc").paginate(:page => params[:page], :per_page => 10)
		render :json =>  {:responseCode => 200,:responseMessage =>"Top Trending profiles of Conference Butler is find successfully.",:trending_profiles => @trend }
	end

	def add_social_login
		@social_profile = SocialLogin.find_or_create_by(provider: params[:user][:provider], u_id: params[:user][:u_id], user_name: params[:user][:user_name], user_id: @user.id)
		if @social_profile
			render :json => {:responseCode => 200, :responseMessage => "Your social login is add in your social profile.", :profile => @user, :social_profile => @social_profile}
		else
			render :json => {:responseCode => 500, :responseMessage => "Your social login is not added in your social profile, Please try again." }
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