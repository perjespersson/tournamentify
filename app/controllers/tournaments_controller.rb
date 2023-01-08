class TournamentsController < ApplicationController
  def new
    @users = User.all
  end

  def create
    puts TournamentGenerator.new(params[:user_ids].reject(&:empty?)).generate_games.inspect
  end
end
