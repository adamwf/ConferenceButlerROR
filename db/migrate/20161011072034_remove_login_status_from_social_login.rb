class RemoveLoginStatusFromSocialLogin < ActiveRecord::Migration
  def change
    remove_column :social_logins, :login_status, :boolean
    add_column :social_logins, :login_status, :boolean, default: false
    add_column :social_logins, :email, :string
    add_column :social_logins, :image, :string
  end
end
