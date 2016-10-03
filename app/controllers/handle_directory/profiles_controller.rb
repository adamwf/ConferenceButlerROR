class HandleDirectory::ProfilesController < HandleDirectory::BaseController
	before_filter :current_handle_user

	def inbox 
	end

	def show
	    @profile = User.find_by_id(params[:id])
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		@user.update(role: "employee")
		if @user.save
			UserMailer.account_confirmation(@user).deliver_now
			flash[:notice] = "You are successfully create a employee."
          	redirect_to handle_directory_home_index_path
		else
			redirect_to handle_directory_home_index_path
			flash[:error] = @user.errors.full_messages
		end
	end

	def edit
	  @profile = User.find_by_id(params[:id])
	end

	def update
	  @profile = User.find_by_id(params[:id])
	  if @profile
	  	@profile.update_attributes(user_params)
	  	 redirect_to handle_directory_home_path,:notice => 'Profile is successfully updated.'
	  else
	    flash[:alert] = "Sorry! Profile can't updated, try again."
	  end
	end

	private

	def user_params
      params.require(:user).permit(:user_name,:first_name,:email,:password,:password_confirmation,:phone,:fax,:company_name,:company_website,:facebook,:instagram,:youtube,:image)
	end
end