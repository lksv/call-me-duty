class CreateTeamsUsersJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :teams, :users do |t|
      t.references :team, foreign_key: true
      t.references :user, foreign_key: true
    end
  end
end
