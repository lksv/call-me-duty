class CreateEscalationPolicies < ActiveRecord::Migration[5.1]
  def change
    create_table :escalation_policies do |t|
      t.string :name,                     null: false, default: ''
      t.text :description
      t.references :team,               foreign_key: true
      t.references :clonned_from,       foreign_key: false

      t.timestamps
    end
    add_index :escalation_policies, :name
  end
end
