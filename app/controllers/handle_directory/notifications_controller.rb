class HandleDirectory::NotificationsController < HandleDirectory::BaseController
  before_filter :require_handle_user
  
  def index
    @notifications = current_handle_user.notifications.order("created_at desc").paginate(:page => params[:page], :per_page => 4)
  end
  
  def destroy
    @notification = Notification.find_by_id(params[:id])
      @notification.destroy
      redirect_to handle_directory_notifications_path
      flash[:notice] = "Notification successfully deleted."
  end
end
