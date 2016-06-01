class Webservices::UserApisController < ApplicationController
	before_filter :find_user,except: [:sign_up, :sign_in]

	def sign_up
    	@user = User.new(user_params)
    	@user.otp = rand(1000..9999)
    	if @user.save
    		@device = Device.find_or_create_by(device_id: params[:device_id], device_type: params[:device_type], user_id: @user.id)
    		UserMailer.send_otp(@user).deliver_now
	    	render :json =>  {:responseCode => 200,:responseMessage =>"Your account has been created successfully, Please verify your account.",:user => @user}
    	else
		    render :json =>  {:responseCode => 500,:responseMessage => @user.errors.full_messages.first}
    	end
  	end

  	def otp_confirm
  		if @user.otp.eql?(params[:user][:otp])
  			render :json =>  {:responseCode => 200,:responseMessage =>"You are successfully verify your account.",:user => @user}
		else
  			render :json =>  {:responseCode => 500,:responseMessage => "Invalid OTP, Please enter a valid OTP."}
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

  	def sign_out
	    @device = Device.find_or_create_by(device_id: params[:device_id], device_type: params[:device_type])
	    if @user
	      @device.update(device_id: nil)
	      render :json => {:responseCode => 200,:responseMessage => "You've successfully logged out."}
	    end     
	end

  	private
	def user_params
		params[:user][:image] = User.image_data(params[:user][:image].to_s.gsub("\\r\\n","")) if params[:user][:image]
	    params.require(:user).permit(:first_name, :last_name, :user_name, :email, :password, :password_confirmation, :otp, :tc_accept, :image, :role, :address)
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
