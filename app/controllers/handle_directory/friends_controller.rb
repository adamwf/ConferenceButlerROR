class HandleDirectory::FriendsController < HandleDirectory::BaseController
  before_filter :require_handle_user

  def index
    @friends = current_handle_user.friends
  end

  def show
  end
end
