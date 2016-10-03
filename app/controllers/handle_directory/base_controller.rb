class HandleDirectory::BaseController < ApplicationController

	layout 'handle_directory'
   helper_method :current_handle_user
   
   def current_handle_user
  	 current_handle_user ||= User.find(session[:handle_user_id]) if session[:handle_user_id]
   end

   def require_user
  	 redirect_to '/handle_directory/login' unless current_handle_user
   end

end