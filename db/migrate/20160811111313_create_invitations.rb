class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :sender_id
      t.integer :reciever_id
      t.string :status, default: "pending"
      t.references :event, index: true, foreign_key: true
      t.boolean :mode, default: true

      t.timestamps null: false
    end
  end
end
