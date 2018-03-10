class CreateCalendarEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :calendar_events do |t|
      t.references :calendar,           foreign_key: true
      t.references :user,               foreign_key: true
      t.datetime :start_at,             null: false
      t.datetime :end_at,               null: false

      t.timestamps
    end
  end
end
