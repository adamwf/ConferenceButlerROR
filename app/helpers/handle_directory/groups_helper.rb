module HandleDirectory::GroupsHelper
  def is_muted?(group)
    GroupMembership.where(:group_id => group.id, :user_id => current_handle_user.id).first.is_mute
  end
end
