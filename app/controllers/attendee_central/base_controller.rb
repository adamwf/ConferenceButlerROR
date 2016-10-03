class AttendeeCentral::BaseController < ApplicationController

	layout 'attendee_central'
   helper_method :current_attendee
   
   def current_attendee
  	 current_attendee ||= User.find(session[:attendee_id]) if session[:attendee_id]
   end

   def require_user
  	 redirect_to '/attendee_central/login' unless current_attendee
   end

end