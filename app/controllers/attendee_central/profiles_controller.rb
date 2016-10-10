class AttendeeCentral::ProfilesController < AttendeeCentral::BaseController
	before_filter :require_attendee

	def inbox 
	end

	def show
	end

	def new
		p"=-new=-=-=-=-#{params.inspect}=-=-=-=-=-=-=-"
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		@user.update(role: "attendee")
		@user.generate_auth_token
		if @user.save!
			UserMailer.account_confirmation(@user,current_attendee).deliver_now
			flash[:notice] = "You are successfully create a attendee."
          	redirect_to attendee_central_home_index_path
		else
			redirect_to new_attendee_central_profile_path
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
	  	 redirect_to attendee_central_home_index_path,:notice => 'Profile is successfully updated.'
	  else
	    flash[:alert] = "Sorry! Profile can't updated, try again."
	  end
	end

	private
	def user_params
      params.require(:user).permit!#(:user_name,:first_name,:email,:password,:password_confirmation,:phone,:fax,:company_name,:company_website,:facebook,:instagram,:youtube,:image)
	end
end