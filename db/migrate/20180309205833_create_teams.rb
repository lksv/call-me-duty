class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.string :name,                   null: false, default: ''
      t.text :description

      t.timestamps
    end

    add_index :teams, :name,            unique: true
  end
end
