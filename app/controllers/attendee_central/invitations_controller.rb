class AttendeeCentral::InvitationsController < AttendeeCentral::BaseController

	before_filter :require_attendee

	def index
	p"=-=-=-=-=#{current_attendee.id.inspect}-=-=-=-=-=-=-=-" 
		@invitations = Invitation.where(reciever_id: current_attendee.id).order("created_at desc").paginate(:page => params[:page], :per_page => 4)
	end

	def show
	end

	def new
		@invitation = InviteManager.new
	end

	def create 
		@invitation = InviteManager.new(invite_params)
		if @invitation.save
			UserMailer.request_invite(@invitation).deliver_now
			flash[:notice] = "You are successfully send request."
          	redirect_to attendee_central_home_index_path(tab: 4)
		else
			redirect_to attendee_central_home_index_path(tab: 4)
			flash[:error] = "You are unable to send request."
		end
	end
	
	def manual
		@invitations = Invitation.where(reciever_id: current_attendee.id)
	end
	private
	def invite_params
		params.require(:invitation).permit(:sender_id,:reciever_id,:email,:company_name,:event_id)
	end
end