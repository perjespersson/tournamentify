class Game < ApplicationRecord
  belongs_to :home_team, class_name: 'User'
  belongs_to :away_team, class_name: 'User'
  belongs_to :tournament
end
