class ForwardInfo::BaseController < ApplicationController
	# before_filter :require_manager

	layout 'forward_info'

	helper_method :current_manager
	  
	def current_manager
	  current_manager ||= User.find(session[:forward_user_id]) if session[:forward_user_id]
	end

	def require_manager
	  redirect_to '/forward_info/login' unless current_manager
	end

end