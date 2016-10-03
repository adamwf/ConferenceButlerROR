class ForwardInfo::SessionsController < ForwardInfo::BaseController
  #before_filter :require_manager
  def create
    @user = User.find_by_email(params[:session][:email])|| @user = User.find_by_user_name(params[:session][:username])
    if @user && @user.valid_password?(params[:session][:password])
      if @user.role.eql?"manager"
        session[:forward_user_id] = @user.id
         flash[:notice] = "You are successfully login!"
        redirect_to '/forward_info'
      elsif @user.role.eql?"employee"
        session[:forward_user_id] = @user.id
         flash[:notice] = "You are successfully login!"
        redirect_to '/forward_info'
      else
        redirect_to '/forward_info/login'
        flash[:error] = "Invalid Email or Password"
      end
    else
        redirect_to '/forward_info/login'
        flash[:error] = "Invalid Email or Password"
    end
  end

  def destroy
    session[:forward_user_id] = nil
    flash[:notice] = "You are successfully logout!" 
    redirect_to '/forward_info/login'
  end
end
