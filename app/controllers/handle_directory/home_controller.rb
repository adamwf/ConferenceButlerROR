class HandleDirectory::HomeController < HandleDirectory::BaseController
	before_filter :current_handle_user, except: [:new, :create]

	# layout 'handle_directory'

	def index 
		@events = Event.all
		@user = current_handle_user
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		@user.update(role: "user")
		@user.generate_auth_token
		if @user.save
			UserMailer.signup_confirmation(@user).deliver_now
			flash[:notice] = "You are successfully registered!"
          	redirect_to forward_info_home_index_path
		else
			redirect_to forward_info_home_index_path
			flash[:error] = @user.errors.full_messages
		end
	end
end
