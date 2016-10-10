class AttendeeCentral::FriendsController < AttendeeCentral::BaseController
  before_filter :require_attendee

  def index
    if params[:search].present?
      if params[:search][:keyword].present?
        @search = current_attendee.friendships.where("keyword LIKE ? And pending =?", "%#{params[:search][:keyword]}%", false)
      else
        @search = current_attendee.friendships.where(pending: false)
      end
      @friends = @search.map{|key| key.friend}.sort_by {|friend| friend[params[:search][:order_by]]}.paginate(:page => params[:page], :per_page => 10)
    else
      @friends = current_attendee.friends.paginate(:page => params[:page], :per_page => 10)
    end
  end

  def show
  end
end