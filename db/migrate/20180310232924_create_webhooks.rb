class CreateWebhooks < ActiveRecord::Migration[5.1]
  def change
    create_table :webhooks do |t|
      t.references :team, foreign_key: true
      t.string :name
      t.string :token
      t.string :uri, limit: 2000
      t.string :template

      t.timestamps
    end
  end
end
