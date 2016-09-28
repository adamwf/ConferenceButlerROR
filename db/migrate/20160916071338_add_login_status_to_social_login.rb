class AddLoginStatusToSocialLogin < ActiveRecord::Migration
  def change
    add_column :social_logins, :login_status, :boolean
  end
end
