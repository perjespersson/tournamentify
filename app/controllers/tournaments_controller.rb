class TournamentsController < ApplicationController
  def new
    @users = User.all
  end

  def create
    puts "================"
    puts params[:user_ids].reject(&:empty?)
    puts "================"
    create_games(params[:user_ids].reject(&:empty?))
  end

  private

  def create_games(users)
    users.push nil if users.count.odd?

    number_of_rounds = users.count - 1
    number_per_groups = users.count / 2

    number_of_rounds.times {
      split_users = users.each_slice(number_per_groups).to_a

      number_per_groups.times do |index|
        next if split_users[0][index].nil? || split_users[1].reverse[index].nil?

        puts split_users[0][index].to_s + " - " + split_users[1].reverse[index].to_s
      end

      puts

      # Rotate array
      users.push users.delete_at(1)
    }
  end
end
