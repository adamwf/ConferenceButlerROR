class HandleDirectory::FriendsController < HandleDirectory::BaseController
  before_filter :require_handle_user

  def index
    if params[:search].present?
      if params[:search][:keyword].present?
        @search = current_handle_user.friendships.where("keyword LIKE ?", "%#{params[:search][:keyword]}%")
      else
        @search = current_handle_user.friendships
      end
      @friends = @search.map{|key| key.friend}.sort_by {|friend| friend[params[:search][:order_by]]}.paginate(:page => params[:page], :per_page => 10)
    else
      @friends = current_handle_user.friends.paginate(:page => params[:page], :per_page => 10)
    end
  end

  def show
  end
end
 User.find(4).approve User.first
