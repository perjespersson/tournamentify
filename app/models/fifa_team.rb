class FifaTeam < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :league
  validates_presence_of :attack
  validates_presence_of :midfield
  validates_presence_of :defense
  validates_presence_of :overall
end
