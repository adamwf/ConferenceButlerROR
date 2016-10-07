class CreateForwardProfiles < ActiveRecord::Migration
  def change
    create_table :forward_profiles do |t|
      t.references :user, index: true, foreign_key: true
      t.string :email

      t.timestamps null: false
    end
  end
end
