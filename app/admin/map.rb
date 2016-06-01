ActiveAdmin.register_page "Map" do
	# menu priority: 5

	action_item only: :index do
	end

	content do
		render :partial => 'users_on_map'
	end 

	controller do
		def users_locater
			@users = User.all(params[:address])
			render :json => @users.as_json(:only => [:id,:first_name])
		end
	end
end
