class HandleDirectory::SessionsController < HandleDirectory::BaseController

	def create
    @user = User.find_by_email(params[:session][:email])|| User.find_by_user_name(params[:session][:username])
    if @user && @user.valid_password?(params[:session][:password])
     	if @user.role.eql?"user"
        session[:user_id] = @user.id
         flash[:notice] = "You are successfully login!"
        redirect_to '/handle_directory'
      # elsif @user.role.eql?"employee"
      #   session[:user_id] = @user.id
      #    flash[:notice] = "You are successfully login!"
      #   redirect_to '/handle_directory'
      else
        redirect_to '/handle_directory/login'
        flash[:error] = "Invalid Email or Password"
      end
    else
     		redirect_to '/handle_directory/login'
        flash[:error] = "Invalid email or password"
    end
	end

	def destroy
    session[:user_id] = nil
    flash[:success] = "You are successfully logout!" 
    redirect_to '/handle_directory/login'
	end
end
