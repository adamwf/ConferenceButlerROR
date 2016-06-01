class CreateSocialLogins < ActiveRecord::Migration
  def change
    create_table :social_logins do |t|
      t.string :provider
      t.string :u_id
      t.string :user_name
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
