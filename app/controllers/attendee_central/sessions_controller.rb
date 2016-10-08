class AttendeeCentral::SessionsController < AttendeeCentral::BaseController

	def create
    @user = User.find_by_email(params[:session][:email])|| User.find_by_user_name(params[:session][:username])
    if @user && @user.valid_password?(params[:session][:password])
     	if @user.role.eql?("organiser")
        session[:attendee_id] = @user.id
         flash[:notice] = "You are successfully login!"
        redirect_to '/attendee_central'
      elsif @user.role.eql?("attendee")
        session[:user_id] = @user.id
         flash[:notice] = "You are successfully login!"
        redirect_to '/attendee_central'
      else
        redirect_to '/attendee_central/login'
        flash[:error] = "Invalid Email or Password"
      end
    else
     		redirect_to '/attendee_central/login'
        flash[:error] = "Invalid email or password"
    end
	end

	def destroy
    session[:attendee_id] = nil
    flash[:success] = "You are successfully logout!" 
    redirect_to '/attendee_central/login'
	end
end
