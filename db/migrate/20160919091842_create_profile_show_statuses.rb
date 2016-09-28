class CreateProfileShowStatuses < ActiveRecord::Migration
  def change
    create_table :profile_show_statuses do |t|
      t.boolean :name, default: true
      t.boolean :email, default: true
      t.boolean :phone, default: true
      t.boolean :other_info, default: true
      t.boolean :hobbies, default: true
      t.boolean :relation_status, default: true
      t.boolean :children, default: true
      t.boolean :image, default: true
      t.boolean :facebook, default: true
      t.boolean :google, default: true
      t.boolean :linked_in, default: true
      t.boolean :instagram, default: true
      t.boolean :twitter, default: true
      t.boolean :social_code, default: true

      t.timestamps null: false
    end
  end
end
