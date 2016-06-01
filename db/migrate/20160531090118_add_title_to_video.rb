class AddTitleToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :title, :string, default: ""
    add_column :videos, :discription, :text, default: ""
  end
end
