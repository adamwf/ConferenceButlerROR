class ForwardInfo::HomeController < ForwardInfo::BaseController
	before_filter :require_manager, except: [:new, :create]


	def index 
		@invitations = Invitation.all.order("created_at desc").paginate(:page => params[:page], :per_page => 3)
		@employees = User.where(role: "employee").order("user_name asc")
		@user = current_manager
	end
	
	def show
	    @profile = User.find_by_id(params[:id])
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		@user.update(role: "manager")
		if @user.save
			UserMailer.signup_confirmation(@user).deliver_now
			flash[:notice] = "You are successfully registered!"
          	redirect_to forward_info_home_index_path
		else
			redirect_to forward_info_home_index_path
			flash[:error] = @user.errors.full_messages
		end
	end

	def edit
	    @invitation = Invitation.find_by_id(params[:id])
	end

	def accept_invitation
		@invitation = Invitation.find_by_id(params[:id])
		if @invitation
		  	@invitation.update_attributes(status: "accepted")
		  	 redirect_to forward_info_root_path,:notice => 'Event invitation accepted.'
		else
		    flash[:error] = "Sorry! You are unable to accept, try again."
		end
	end

	def decline_invitation
	  	@invitation = Invitation.find_by_id(params[:id])
	  	if @invitation
	  		@invitation.update_attributes(status: "rejected")
	  	 	redirect_to forward_info_root_path,:notice => 'Event invitation rejected.'
	  	else
	    	flash[:error] = "Sorry! You are unable to reject, try again."
	  	end
	end


	private

	def user_params
      params.require(:user).permit(:user_name,:first_name,:email,:password,:password_confirmation,:phone,:fax,:company_name,:company_website,:facebook,:instagram,:youtube,:image)
	end
end
