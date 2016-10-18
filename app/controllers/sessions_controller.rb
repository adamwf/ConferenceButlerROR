 class SessionsController < ApplicationController

	
	# def create
 #           @user = User.find_by_email(params[:session][:email])|| @user = User.find_by_user_name(params[:session][:username])
 #           if @user && @user.valid_password?(params[:session][:password])
 #           		session[:user_id] = @user.id
 #           		 flash[:success] = "You are successfully login!"
 #           		redirect_to '/'
 #           else
 #           		redirect_to '/login'
 #              flash[:error] = "Invalid email or password"
 #           end
	# end

	# def destroy
 #       session[:user_id] = nil
 #       flash[:success] = "You are successfully logout!" 
 #       redirect_to '/login'
	# end
end
