class AddVisibilityLevelToTeam < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :visibility_level, :integer,     null: false, default: 0
  end
end
