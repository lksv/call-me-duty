class AddDefaultOranizationToUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :default_organization
  end
end
