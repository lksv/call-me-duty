class CreateMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :members do |t|
      t.string      :type
      t.references  :user,          foreign_key: true
      t.references  :team,          foreign_key: true
      t.integer     :access_level,  null: false
      t.references  :created_by

      t.timestamps
    end
  end
end
