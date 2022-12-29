class User < ApplicationRecord
  # Easiest way to do the association
  def games
    Game.where("home_team_id = ? OR away_team_id = ?", self.id, self.id)
  end

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable

  validates :email,
            uniqueness: true,
            presence: true
  validates :username,
            uniqueness: true,
            presence: true

  attr_accessor :login

  # Add support for authenticate with both email and username
  def self.find_for_database_authentication warden_condition
    conditions = warden_condition.dup
    login = conditions.delete(:login)
    where(conditions).where(
      ["lower(username) = :value OR lower(email) = :value",
      { value: login.strip.downcase}]).first
  end
end
