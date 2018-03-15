class CreateCalendars < ActiveRecord::Migration[5.1]
  def change
    create_table :calendars do |t|
      t.references  :team,                    foreign_key: true
      t.references  :current_calendar_event,  foreign_key: false

      t.timestamps
    end
  end
end
