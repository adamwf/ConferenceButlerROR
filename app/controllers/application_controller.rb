class ApplicationController < ActionController::Base
	# include PublicActivity::StoreController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  # helper_method :current_user
  # helper_method :current_manager

  def render_message (code, msg)
    render :json => {
        :responseCode => code,
        :responseMessage => msg
    }
  end

  def authentication
    auth_token = request.headers[:token]
    unless auth_token
      return render_message 501, "You are not Authenticated User."
    end
    user = User.find_by(access_token: auth_token)
    unless  user
      return render_message 501, "You are not Authenticated User."
    end
  end

  # def current_user
  # 	current_user ||= User.find(session[:user_id]) if session[:user_id]
  # end

  # def require_user
  # 	redirect_to '/handle_directory/login' unless current_user
  # end

  # def current_manager
  #   current_manager ||= User.find(session[:user_id]) if session[:user_id]
  # end

  # def require_manager
  #   redirect_to '/forward_info/login' unless current_manager
  # end
end
