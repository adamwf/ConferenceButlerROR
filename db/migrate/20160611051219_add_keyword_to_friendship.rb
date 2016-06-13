class AddKeywordToFriendship < ActiveRecord::Migration
  def change
    add_column :friendships, :keyword, :string, default: ""
  end
end
