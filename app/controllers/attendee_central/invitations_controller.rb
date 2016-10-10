class AttendeeCentral::InvitationsController < AttendeeCentral::BaseController

	before_filter :require_attendee

	def index
	p"=-=-=-=-=#{current_attendee.id.inspect}-=-=-=-=-=-=-=-" 
		@invitations = Invitation.where(reciever_id: current_attendee.id)
	end

	def show
	end

	def new
		@invitation = InviteManager.new
	end

	def create 
		@invitation = InviteManager.new(invite_params)
	end

	private
	def invite_params
		params.require(:invitation).permit(:sender_id,:reciever_id,:email,:company_name,:event_id)
	end
end