class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :sender_email
      t.string :reciever_email
      t.string :status
      t.string :event_name
      t.string :mode

      t.timestamps null: false
    end
  end
end
