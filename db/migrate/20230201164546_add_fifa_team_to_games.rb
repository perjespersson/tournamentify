class AddFifaTeamToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :home_fifa_team, :integer
    add_column :games, :away_fifa_team, :integer
  end
end
