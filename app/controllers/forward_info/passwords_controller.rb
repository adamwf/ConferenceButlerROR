class ForwardInfo::PasswordsController < ForwardInfo::BaseController

	def index
		
	end

	def forget_password
	end

	def reset_password
		@user = User.find_by_email(params[:user][:email]) 
		if @user
			if @user.role.eql?("manager") || @user.role.eql?("employee")
				User.send_password_reset(@user)
				flash[:notice] = "Your Password send to your email successfully."
				redirect_to forward_info_root_path
			else
		 	flash[:error] = "Invalid User."
		 	redirect_to forward_info_passwords_forget_password_path
			end	
		else
		 	flash[:error] = "Invalid User,Email not found."
		 	redirect_to forward_info_passwords_forget_password_path
		end
	end

	def change_password
		@user = User.find_by_id(params[:id])
	 	if @user.valid_password?params[:user][:current_password] 
	 		if params[:user][:new_password].eql?(params[:user][:password_confirmation])
		 		@user.update_attributes(password: params[:user][:new_password], password_confirmation: params[:user][:password_confirmation])
		 		flash[:notice] = "Your Password changed successfully."
		 		redirect_to forward_info_root_path
		 	else
		 		flash[:error] = "Confirm Password doen't match with Password."
		 		redirect_to forward_info_root_path	
		 	end
		else
		 	flash[:error] = "Invalid Current Password."
		 	redirect_to forward_info_root_path
		end		
	end
end
