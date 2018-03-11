class CreateIncidents < ActiveRecord::Migration[5.1]
  def change
    create_table :incidents do |t|
      t.integer :status
      t.string :title, limit: 127
      t.text :description
      t.text :data
      t.references :team,                 foreign_key: true
      t.references :integration,          foreign_key: false
      t.references :service,              foreign_key: false
      t.references :escalation_policy,    foreign_key: true
      t.integer :priority
      t.integer :alert_trigged_count
      t.datetime :snoozed_until

      t.timestamps
    end
  end
end
