class AttendeeCentral::SettingsController < AttendeeCentral::BaseController
  before_filter :require_attendee

  def index
    @user  = current_attendee
  end
  
  def update_advance
    @user  = current_attendee
    if @user.update(user_params)
      redirect_to handle_directory_settings_path, notice: 'Your setting has been updated successfully.'
    else
      redirect_to :back, notice: "Something went wrong, please try again."
    end
  end
  
  def password
    @user  = current_attendee
  end
 
  def update_password
    @user  = current_attendee
    if @user.valid_password?(params[:user][:old_password])
      if params[:user][:password].eql?(params[:user][:password_confirmation])
        if @user.update_attributes(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
          reset_session
          redirect_to email_handle_directory_settings_path, notice: 'Your Password has been reset successfully,please logged in account.'
        else
          redirect_to :back, notice: "Your password can't be reset, please try again."
        end
      else
        redirect_to :back, notice: "Your new password and confirm password doesn't match, please try again."
      end
    else
      redirect_to :back, notice: "Your old password has not been matched."
    end  
  end

  def email
    @user  = current_attendee
  end
  
  def update_email
    @user  = current_attendee
    if @user.valid?(params[:user][:email])
      if params[:user][:new_email].eql?(params[:user][:email_confirmation])
        if @user.update_attributes(email: params[:user][:new_email])
          User.send_password_reset(@user)
          reset_session
          redirect_to email_handle_directory_settings_path, notice: 'An OTP send to your new email successfully,please verify and logged in account.'
        else
          redirect_to :back, notice: 'Error occur while changing email, please try again.'
        end
      else
        redirect_to :back, notice: "Your new email and confirm email doesn't match together, please try again."
      end
    else
      redirect_to :back, notice: "Your old email is not valid."
    end  
  end

  def status
    @user  = current_attendee
  end
  
  def update_status
    if current_attendee.update_attributes(availability: params[:user][:availability])
      redirect_to :back, notice: 'Your availability status has been updated successfully.'
    else
      redirect_to :back, alert: 'Unable to update availability status.'
    end
  end

  def remind_me
    @reminder = current_attendee.reminder || current_attendee.build_reminder
  end
  
  def update_remind_me
    @reminder = current_attendee.reminder || current_attendee.build_reminder
    unless params[:reminder][:delay_time].eql?("never")
      @reminder.update_attributes(delay_time: params[:reminder][:delay_time], status: true)
    else
      @reminder.update_attributes(delay_time: params[:reminder][:delay_time], status: false)
    end
    redirect_to :back, notice: 'Record was successfully updated.'
  end
  
  private
  
    def user_params
      params.require(:user).permit(:profile_view_to_requested_users, :profile_view_to_handle_directory_users, :profile_view_to_gab_users)
    end

end
