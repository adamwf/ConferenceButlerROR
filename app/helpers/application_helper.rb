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
end
