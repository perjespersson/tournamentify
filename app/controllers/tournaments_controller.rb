class TournamentsController < ApplicationController
  def new
    @users = User.all
  end

  def create
    puts "================"
    puts params
    puts "================"
  end
end
