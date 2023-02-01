class Game < ApplicationRecord
  belongs_to :home_team, class_name: 'User'
  belongs_to :away_team, class_name: 'User'
  belongs_to :home_fifa_team, class_name: 'FifaTeam'
  belongs_to :away_fifa_team, class_name: 'FifaTeam'
  belongs_to :tournament
end
