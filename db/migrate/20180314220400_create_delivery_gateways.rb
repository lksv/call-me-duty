class CreateDeliveryGateways < ActiveRecord::Migration[5.1]
  def change
    create_table :delivery_gateways do |t|
      t.string :name
      t.string :type
      t.references :team, foreign_key: true
      t.text :data

      t.timestamps
    end
    add_index :delivery_gateways, :type
  end
end
