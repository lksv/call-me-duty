class CreateServices < ActiveRecord::Migration[5.1]
  def change
    create_table :services do |t|
      t.string :name,                         null: false, default: ''
      t.text :description
      t.references :team, foreign_key: true

      t.timestamps
    end

    add_index :services, :name,                unique: true
  end
end
