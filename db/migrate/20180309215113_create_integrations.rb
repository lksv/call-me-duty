class CreateIntegrations < ActiveRecord::Migration[5.1]
  def change
    create_table :integrations do |t|
      t.string :name,                             null: false, default: ''
      t.string :key
      t.integer :type
      t.references :service,                      foreign_key: true

      t.timestamps
    end
    add_index :integrations, :key
    add_index :integrations, :name,                unique: true
  end
end
