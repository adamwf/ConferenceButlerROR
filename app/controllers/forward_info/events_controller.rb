class ForwardInfo::EventsController < ForwardInfo::BaseController
	before_filter :require_manager

	def index
		@notifications = Notification.all.order("created_at desc").where(user_id: current_manager.id).paginate(:page => params[:page], :per_page => 4)
	end

	def show
		@employee = User.find_by_id(params[:id])
		# @viewer = @employee.profile_views
	end

	def edit
	end

	def destroy
		@notification = Notification.find_by_id(params[:id])
	    @notification.destroy
	    redirect_to forward_info_events_path
	    flash[:notice] = "Notification successfully deleted."
	end
end
