class RemoveTimeToEvent < ActiveRecord::Migration
  def change
    remove_column :events, :time, :datetime
    remove_column :events, :organizer, :string
    remove_column :events, :user_id, :integer
    add_column :events, :start_time, :datetime
    add_column :events, :end_time, :datetime
    add_column :events, :category, :string
    add_column :events, :event_type, :string
    add_column :events, :no_of_availability, :integer
    add_column :events, :availability, :boolean
    add_reference :events, :user, index: true, foreign_key: true
  end
end
