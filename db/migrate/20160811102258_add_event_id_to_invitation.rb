class AddEventIdToInvitation < ActiveRecord::Migration
  def change
    add_reference :invitations, :event, index: true, foreign_key: true
  end
end
