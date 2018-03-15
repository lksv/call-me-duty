class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.integer     :status,            null: false
      t.integer     :event,             null: false
      t.references  :messageable,       polymorphic: true
      t.string      :static_gateway
      t.references  :delivery_gateway,  foreign_key: true
      t.references  :user,              foreign_key: true
      t.datetime    :delivered_at

      # following fields are user for (and filled form) Voice Call API
      t.string      :gateway_request_uid
      t.datetime    :answered_at
      t.datetime    :ended_at
      t.float       :cost
      t.integer     :duration
      t.text        :error_msg,         limit: 1024

      t.timestamps
    end
    add_index :messages, :event
  end
end
