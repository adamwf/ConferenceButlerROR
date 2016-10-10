class HandleDirectory::HomeController < HandleDirectory::BaseController
	before_filter :require_handle_user, except: [:new, :create]

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
          	redirect_to handle_directory_home_index_path
		else
			redirect_to new_handle_directory_home_path
			flash[:error] = @user.errors.full_messages
		end
	end
	
	private

  def user_params
      params.require(:user).permit(:user_name,:first_name,:email,:password,:password_confirmation,:phone,:facebook,:instagram,:youtube,:image, :other_info, :hobbies, :last_name, :address, :profile_view_to_requested_users, :profile_view_to_handle_directory_users, :profile_view_to_gab_users)
  end
end
