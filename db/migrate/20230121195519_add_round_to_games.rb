class AddRoundToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :round, :string
  end
end
