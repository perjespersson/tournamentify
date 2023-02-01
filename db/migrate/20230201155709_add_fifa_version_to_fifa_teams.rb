class AddFifaVersionToFifaTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :fifa_teams, :edition, :string
  end
end
