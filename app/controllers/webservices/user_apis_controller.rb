 class Webservices::UserApisController < ApplicationController
	before_filter :find_user,except: [:sign_up, :sign_in, :otp_confirm, :otp_resend, :social_login, :forget_password]
	before_filter :authentication, :except => [:sign_up,:otp_confirm, :otp_resend,:sign_in, :social_login, :forget_password]
	before_filter :find_friend,only: [:privacy_status, :update_privacy_status]
	def sign_up
		if @user_param = User.find_by(email: params[:user][:email].downcase)
			render :json =>  {:responseCode => 200,:responseMessage =>"Email has already been taken."}
		else
	    	@otp = OtpInfo.find_or_create_by(email: params[:user][:email].downcase)
	    	@otp.otp =  rand(1000..9999)
	    	if @otp.save
		    	UserMailer.send_otp(@otp).deliver_now
			    render :json =>  {:responseCode => 200,:responseMessage =>"Your OTP successfully send to your account email, Please verify your OTP to create your account.",:user => @otp }
   			end
   		end
   	end

  	def otp_confirm
  		@user = OtpInfo.find_by(email: params[:user][:email].downcase)
  		if @user.otp.eql?(params[:user][:otp])
  			@user_param = User.new(user_params)
  			@user_param.role = "user"
  			@user_param.generate_auth_token
  			if @user_param.save
	    		@device = Device.find_or_create_by(device_id: params[:device_id], device_type: params[:device_type], user_id: @user_param.id)
	  			UserMailer.signup_confirmation(@user_param).deliver_now
	  			render :json =>  {:responseCode => 200,:responseMessage =>"You are successfully verify your OTP and account created successfully.",:user => @user_param }
			else
		    	render_message 500, @user_param.errors.full_messages.first
    		end
		else
  			render_message 500, "Invalid OTP, Please enter a valid OTP."
		end	
  	end

  	def otp_resend                
  		if @user = OtpInfo.find_by(email: params[:user][:email])
	  		@otp = rand(1000..9999)
	  	    if @user.save
	  			@user.update_attributes(otp: @otp)
	  			UserMailer.send_otp(@user).deliver_now
	  			render :json =>  {:responseCode => 200,:responseMessage =>"Your OTP successfully send to your account email, Please verify your account.",:user => @user}
			else
	  			render_message 500, @user.errors.full_messages.first 
			end	
		else
		   	render_message 500, "Oops! User does not exists." 
		end
	end

	def profile
		data=""
		if @user.social_code.eql?(nil)				
			render :json =>  {:responseCode => 200,:responseMessage =>"Your account has been updated successfully.",:user => @user.attributes.merge(:image => @user.image.try(:url),:social_login => @user.social_logins, :social_code => data)}
		else
			render :json =>  {:responseCode => 200,:responseMessage =>"Your account has been updated successfully.",:user => @user.attributes.merge(:image => @user.image.try(:url),:social_login => @user.social_logins, :social_code => @user.social_code.try(:image))}
		end
	end

  	def update_user
  		if @user.update_attributes(user_params)
  			render :json =>  {:responseCode => 200,:responseMessage =>"Your account has been updated successfully.",:user => @user}	
  		else
		    render_message 500, @user.errors.full_messages.first
		end	
  	end

  	def sign_in
	    if @user = User.find_by_user_name(params[:user][:user_name]) || @user = User.find_by_email(params[:user][:email].downcase)
	        if (@user && @user.valid_password?(params[:user][:password]))
		        @device = Device.find_or_create_by(device_id: params[:device_id], device_type: params[:device_type]).update(user_id: @user.id)
	        	render :json =>  {:responseCode => 200,:responseMessage =>"User login successfully.",:user => @user}
	      	else
	        	render_message 500,"Invalid Email or Password, Please try again."
	      	end
	    else
	      render_message 500, "Invalid Email or Username, Please enter a valid email or Username."
	    end
  	end

  	def social_login
		@user = User.find_by(email: params[:user][:email].downcase, provider: params[:user][:provider], u_id: params[:user][:u_id])
		if @user
		    @user.update_attributes(first_name: params[:user][:first_name],last_name: params[:user][:last_name])
		    @device = Device.find_or_create_by(device_id: params[:device_id], device_type: params[:device_type], user_id: @user.id)
		    render :json => {responseCode: 200,responseMessage: "User login successfully.",user: @user }
		else
			@otp = OtpInfo.find_or_create_by(email: params[:user][:email])
	    	@otp.otp =  rand(1000..9999)
	    	if @otp.save
		    	UserMailer.send_otp(@otp).deliver_now
			    render :json =>  {:responseCode => 200,:responseMessage =>"Your OTP successfully send to your account email, Please verify your OTP to create your account.",:user => @otp }
   			end
		end
	end


  	def sign_out
	    @device = Device.find_or_create_by(device_id: params[:device_id], device_type: params[:device_type])
	    if @user
	      @device.update(device_id: "")
	      render :json => {:responseCode => 200,:responseMessage => "You've successfully logged out."}
	    end     
	end

	def forget_password
		@user = User.find_by(:email => params[:email].downcase)
		if @user
			User.send_password_reset(@user)
			render :json => {:responseCode => 200,:responseMessage => "Your new password send to your email, please find and reset password."}
		else
			render_message 500, "Your email doesn't exist, please verify your email."
		end	 
	end

	def change_password
		if @user.valid_password?(params[:user][:old_password])
	    	if @user.update_attributes(password: params[:user][:new_password], password_confirmation: params[:user][:new_password_confirmation])
			  	render :json => {:responseCode => 200,:responseMessage => "Your Password has been reset successfully"}
	    	else
	      		render_message 500, "Your password can't be reset, please try again."
	    	end
	  	else
	  		render_message 500, "Your old password has not been matched."
	  	end  
	end

	def availability
		render :json =>  {:responseCode => 200,:responseMessage =>"Your availability status has been updated successfully.",:user_availability => @user.availability}
	end

	def update_availability
		if @user.update_attributes(availability: params[:user][:availability])
			render :json =>  {:responseCode => 200,:responseMessage =>"Your availability status has been updated successfully.",:user_availability => @user.availability}
		else
			render_message 500, "Unable to update availability status."
		end		
	end

	def privacy_status
		@status = ProfileShowStatus.find_by(user_id: @user.id)
		render :json =>  {:responseCode => 200,:responseMessage =>"Privacy status has been find successfully.",:privacy_status => @status.attributes.merge(:is_friend => @user.friend_with?(@friend))}
	end

	def get_privacy_status
		@status = ProfileShowStatus.find_by(user_id: @user.id)
		render :json =>  {:responseCode => 200,:responseMessage =>"Privacy status has been find successfully.",:privacy_status => @status}
	end

	def update_privacy_status
		@status = ProfileShowStatus.find_by(user_id: @user.id)
		if @status.update_attributes(profile_status_params)
			render :json =>  {:responseCode => 200,:responseMessage =>"Privacy status has been find successfully.",:privacy_status => @status}
		else
			render_message 500, "Unable to update Privacy status."
		end
	end

	def get_reminder
		data={}
		if @user.reminder.eql?(nil)
			render :json =>  {:responseCode => 200,:responseMessage =>"Your reminder has been find successfully.",:reminder => data}
		else
			render :json =>  {:responseCode => 200,:responseMessage =>"Your reminder has been find successfully.",:reminder => @user.reminder}
		end
	end

	def set_reminder
		unless params[:delay_time].eql?("never")
			if @user.reminder.eql?(nil)
				Reminder.create(user: @user, delay_time: params[:delay_time], status: true)
			else
				@user.reminder.update_attributes(delay_time: params[:delay_time], status: true)
			end
		else
			if @user.reminder.eql?(nil)
				Reminder.create(user: @user, delay_time: params[:delay_time], status: false)
			else
				@user.reminder.update_attributes(delay_time: params[:delay_time], status: false)
			end
		end
		@reminder = Reminder.find_by(user: @user)
		render :json =>  {:responseCode => 200,:responseMessage =>"Your reminder has been find successfully.",:reminder => @reminder}
	end

  	private
	def user_params
		params[:user][:image] = User.image_data(params[:user][:image].to_s.gsub("\\r\\n","")) if params[:user][:image]
	    params.require(:user).permit(:first_name, :last_name, :user_name, :email, :password, :password_confirmation, :otp, :tc_accept, :image, :role, :address, :provider, :u_id, :phone, :hobbies, :relation_status, :children, :availability, :other_info, :profile_view_to_requested_users, :profile_view_to_handle_directory_users, :profile_view_to_gab_users)
	end 
	def find_user
		if params[:user][:user_id]
			@user = User.find_by_id(params[:user][:user_id])
		    unless @user
		     render_message 500,"Oops! User not found."
		    end
		else
			render_message 500, "Sorry! You are not an authenticated user."
	    end
  	end
  	def find_friend
		if params[:user][:friend_id]
			@friend = User.find_by_id(params[:user][:friend_id])
		    unless @friend
		     render_message 500, "Oops! Friend User not found."
		    end
		else
			render_message 500, "Sorry! You are not an authenticated user."
	    end
  	end
  	def profile_status_params
  		params.require(:status).permit(:name, :email, :image, :phone, :address, :hobbies, :relation_status, :children, :availability, :other_info, :facebook, :google, :instagram, :linkedin, :twitter, :social_code)
  	end
end

