module ApplicationHelper

	def find_lat_long
			
		@user=User.all
		@user.collect { |item| {:lat => item.latitude, :lng => item.longitude} }.to_json
		# arr=Array.new
		# i=0
		# unless @user.nil?
		# 	@user.each do |user|
		# 		arr[i]=user.latitude
		# 		arr[i+1]=user.longitude
		# 		i=i+1
		# 	end	
			#keys=[:lat,:lng]
			#h={}
			#values=arr.each_slice(2).map{ |value| Hash[keys.zip(value)]}.to_json
			
			#values=keys.inject({}) { |h, k| h.merge({k: arr}) }
			
	 #   end
	end

   def nav_action_class(actionName)
      if params[:action] == actionName    
      "active"
      end
   end

	def location_dropdown
	  a = []
      @invitations = Invitation.where("reciever_id = ? AND status = ?",current_manager , "accepted")
      @invitations.each do |invitation| 
        invitation.event.location if invitation.event.end_time < Time.current
      
         a << invitation.event.location if invitation.event.end_time < Time.current 
        end
        return a.uniq
	end
end
