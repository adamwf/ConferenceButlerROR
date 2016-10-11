class HandleDirectory::ProfilesController < HandleDirectory::BaseController
	before_filter :current_handle_user

	def inbox 
	end

	def show
	  @events = Event.all
    @user = current_handle_user
	end

	def new
	end

	def create
	end

	def edit
	  @profile = User.find_by_id(params[:id])
	end

	def update
	  @profile = User.find_by_id(params[:id])
	  if @profile
	  	@profile.update_attributes(user_params)
	  	 redirect_to handle_directory_profile_path,:notice => 'Profile is successfully updated.'
	  else
	    flash[:alert] = "Sorry! Profile can't updated, try again."
	  end
	end

	private

	def user_params
      params.require(:user).permit(:user_name,:first_name,:email,:password,:password_confirmation,:phone,:facebook,:instagram,:youtube,:image, :other_info, :hobbies, :last_name, :address, :profile_view_to_requested_users, :profile_view_to_handle_directory_users, :profile_view_to_gab_users)
	end
end