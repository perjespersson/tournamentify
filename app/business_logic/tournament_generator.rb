class TournamentGenerator
  def initialize(users, rounds)
    @users = users.count.even? ? users : users << nil
    @rounds = rounds.to_i
  end

  def generate_games
    games = []
    (number_of_games_per_user * @rounds).times do |round|
      # Split array into half
      split_users = @users.each_slice(games_per_round).to_a

      games_per_round.times do |user|
        home_team = split_users[0][user]
        away_team = split_users[1].reverse[user]

        # If we have added nil, those matches shouldn't count
        next if home_team.nil? || away_team.nil?
        games << [home_team, away_team, (round + 1)]
      end
      rotate_users
    end

    games
  end

  private

  # Everyone has to play against each other once
  def number_of_games_per_user
    @users.count - 1
  end

  # Since @users are never odd, every team should have a game every round
  def games_per_round
    @users.count / 2
  end

  # Move index 1 to last in the array
  def rotate_users
    @users.push @users.delete_at(1)
  end
end
