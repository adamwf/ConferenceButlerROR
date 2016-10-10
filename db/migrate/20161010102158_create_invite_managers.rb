class CreateInviteManagers < ActiveRecord::Migration
  def change
    create_table :invite_managers do |t|
      t.integer :sender_id
      t.integer :reciever_id
      t.string :company_name
      t.string :email
      t.references :event, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
