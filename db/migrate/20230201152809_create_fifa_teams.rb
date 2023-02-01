class CreateFifaTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :fifa_teams do |t|
      t.string :name
      t.string :league
      t.integer :attack
      t.integer :midfield
      t.integer :defense
      t.integer :overall

      t.timestamps
    end
  end
end
