class Webservices::UserApisController < ApplicationController
	before_filter :find_user,except: [:sign_up, :sign_in, :otp_confirm, :otp_resend, :social_login]

	def sign_up
		if @user_param = User.find_by(email: params[:user][:email].downcase)
			render :json =>  {:responseCode => 200,:responseMessage =>"Email has already been taken."}
		else
	    	@otp = OtpInfo.find_or_create_by(email: params[:user][:email].downcase)
	    	@otp.otp =  rand(1000..9999)
	    	if @otp.save
		    	UserMailer.send_otp(@otp).deliver
			    render :json =>  {:responseCode => 200,:responseMessage =>"Your OTP successfully send to your account email, Please verify your OTP to create your account.",:user => @otp }
   			end
   		end
   	end

  	def otp_confirm
  		@user = OtpInfo.find_by(email: params[:user][:email].downcase)
  		if @user.otp.eql?(params[:user][:otp])
  			@user_param = User.new(user_params)
  			@user_param.role = "user"
  			if @user_param.save
	    		@device = Device.find_or_create_by(device_id: params[:device_id], device_type: params[:device_type], user_id: @user_param.id)
	  			UserMailer.signup_confirmation(@user_param).deliver
	  			render :json =>  {:responseCode => 200,:responseMessage =>"You are successfully verify your OTP and account created successfully.",:user => @user_param }
			else
		    	render :json =>  {:responseCode => 500,:responseMessage => @user_param.errors.full_messages.first}
    		end
		else
  			render :json =>  {:responseCode => 500,:responseMessage => "Invalid OTP, Please enter a valid OTP."}
		end	
  	end

  	def otp_resend
  		@user = OtpInfo.find_by(email: params[:user][:email])
  		@user.otp = rand(1000..9999)
  		if @user.save
  			UserMailer.send_otp(@user).deliver_now
  			render :json =>  {:responseCode => 200,:responseMessage =>"Your OTP successfully send to your account email, Please verify your account.",:user => @user}
		else
  			render :json =>  {:responseCode => 500,:responseMessage => @user.errors.full_messages.first }
		end	
  	end

  	def update_user
  		if @user.update_attributes(user_params)
  			render :json =>  {:responseCode => 200,:responseMessage =>"Your account has been updated successfully.",:user => @user}	
  		else
		    render :json =>  {:responseCode => 500,:responseMessage => @user.errors.full_messages.first}
		end	
  	end

  	def sign_in
	    if @user = User.find_by_user_name(params[:user][:user_name]) || @user = User.find_by_email(params[:user][:email].downcase)
	        if (@user && @user.valid_password?(params[:user][:password]))
		        @device = Device.find_or_create_by(device_id: params[:device_id], device_type: params[:device_type]).update(user_id: @user.id)
	        	render :json =>  {:responseCode => 200,:responseMessage =>"User login successfully.",:user => @user}
	      	else
	        	render :json =>  {:responseCode => 500,:responseMessage =>"Invalid Email or Password, Please try again.",:user => @user.errors.full_messages.first}
	      	end
	    else
	      render :json =>  {:responseCode => 500,:responseMessage => "Invalid Email or Username, Please enter a valid email or Username."}
	    end
  	end

  	def social_login
		@user = User.find_by(email: params[:user][:email].downcase, provider: params[:user][:provider], u_id: params[:user][:u_id])
		if @user
		    @user.update_attributes(first_name: params[:first_name],last_name: params[:last_name])
		    @device = Device.find_or_create_by(device_id: params[:device_id], device_type: params[:device_type], user_id: @user.id)
		    render :json => {responseCode: 200,responseMessage: "User login successfully.",user: @user }
		else
			@otp = OtpInfo.find_or_create_by(email: params[:user][:email])
	    	@otp.otp =  rand(1000..9999)
	    	if @otp.save
		    	UserMailer.send_otp(@otp).deliver
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

  	private
	def user_params
		params[:user][:image] = User.image_data(params[:user][:image].to_s.gsub("\\r\\n","")) if params[:user][:image]
	    params.require(:user).permit(:first_name, :last_name, :user_name, :email, :password, :password_confirmation, :otp, :tc_accept, :image, :role, :address, :provider, :u_id)
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
