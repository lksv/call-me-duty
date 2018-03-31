class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.string :name,                   null: false, default: ''
      t.string :type,                   index: true
      t.text   :description

      t.references :parent
      t.references :owner
      t.string :slug,                  null: false, default: ''
      t.string :full_path,             null: false, default: ''

      t.timestamps
    end

    add_index :teams, :full_path,          unique: true
    add_index :teams, [:parent_id, :name], unique: true
    add_index :teams, [:parent_id, :slug], unique: true
  end
end
