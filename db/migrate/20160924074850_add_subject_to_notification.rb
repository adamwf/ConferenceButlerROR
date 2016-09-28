class AddSubjectToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :subject, :string
    add_column :notifications, :reciever_id, :integer
    add_column :notifications, :notifiable_id, :integer
    add_column :notifications, :notifiable_type, :string
  end
end
