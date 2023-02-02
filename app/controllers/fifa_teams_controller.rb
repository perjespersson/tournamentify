class FifaTeamsController < ApplicationController
  def index
    @leagues = FifaTeam.where("league #{gender_clause} ILIKE ?", "%Women%").distinct.pluck(:league)
    render json: @leagues
  end

  private

  def gender_clause
    params[:gender] == 'women' ? "" : "NOT"
  end
end
