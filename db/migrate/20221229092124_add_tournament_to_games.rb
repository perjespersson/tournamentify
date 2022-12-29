class AddTournamentToGames < ActiveRecord::Migration[7.0]
  def change
    add_reference :games, :tournament, null: false, foreign_key: true
  end
end
