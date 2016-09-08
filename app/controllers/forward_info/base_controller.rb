class ForwardInfo::BaseController < ApplicationController
	# before_filter :require_manager

	layout 'forward_info'

	helper_method :current_manager
	  
	def current_manager
	  current_manager ||= User.find(session[:user_id]) if session[:user_id]
	end

	def require_manager
	  redirect_to '/forward_info/login' unless current_manager
	end

end