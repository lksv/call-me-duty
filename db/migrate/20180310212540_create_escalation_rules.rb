class CreateEscalationRules < ActiveRecord::Migration[5.1]
  def change
    create_table :escalation_rules do |t|
      t.references  :escalation_policy,   foreign_key: true
      t.integer     :condition_type,      defaut: '', null: false
      t.integer     :action_type,         defaut: '', null: false
      t.integer     :delay
      t.references  :target, polymorphic: true
      t.datetime    :finished_at

      t.timestamps
    end
  end
end
