class AddProfileDisplayWithinSearchEngineToUser < ActiveRecord::Migration
  def change
    add_column :users, :profile_display_within_search_engine, :boolean
  end
end
