class TournamentsController < ApplicationController
  def new
    @users = User.all
  end

  def create
    @tournament = Tournament.new(name: params[:name])
    generated_games.each do |game|
      Game.create(home_team_id: game[0], away_team_id: game[1], round: game[2], tournament: @tournament)
    end

    if @tournament.save
      redirect_to tournament_path @tournament
    else
      render 'new'
    end
  end

  def show
    @tournament = Tournament.find(params[:id])
    @table = ActiveRecord::Base.connection.execute(table_query)
    @per_page = @tournament.games.where(round: 1).count
    @games = @tournament.games.order('round ASC').page(params[:page]).per_page(@per_page)
  end

  private

  def generated_games
    @generated_games ||= TournamentGenerator.new(params[:user_ids].reject(&:empty?), params[:rounds]).generate_games
  end

  def table_query
    <<-EOF
      WITH users_games_with_score AS (
        SELECT
            users.username,
            CASE
              WHEN users.id = home_team_id THEN home_team_score
              WHEN users.id = away_team_id THEN away_team_score
            END as scored_goals,
            CASE
              WHEN users.id = home_team_id THEN away_team_score
              WHEN users.id = away_team_id THEN home_team_score
            END as conceded_goals
        FROM
          tournaments
        JOIN
          games
        ON
          tournaments.id = games.tournament_id
        JOIN
          users
        ON
          users.id = games.home_team_id OR users.id = games.away_team_id
        WHERE
          tournaments.id = #{params[:id]}
      ), user_games_with_points AS(
        SELECT
          *,
          CASE
            WHEN scored_goals > conceded_goals THEN 3
            WHEN scored_goals = conceded_goals THEN 1
            ELSE 0
          END as points
        FROM
          users_games_with_score
      )

      SELECT
        username,
        COUNT(*) filter(WHERE scored_goals IS NOT NULL AND conceded_goals IS NOT NULL) played_games,
        COUNT(*) filter(WHERE scored_goals > conceded_goals) won_games,
        COUNT(*) filter(WHERE scored_goals = conceded_goals AND scored_goals IS NOT NULL AND conceded_goals IS NOT NULL) tied_games,
        COUNT(*) filter(WHERE scored_goals < conceded_goals) lost_games,
        SUM(CASE WHEN scored_goals IS NULL THEN 0 ELSE scored_goals END) as scored_goals,
        SUM(CASE WHEN conceded_goals IS NULL THEN 0 ELSE conceded_goals END) as conceded_goals,
        (SUM(CASE WHEN scored_goals IS NULL THEN 0 ELSE scored_goals END) - SUM(CASE WHEN conceded_goals IS NULL THEN 0 ELSE conceded_goals END)) as goal_difference,
        SUM(points) as points
      FROM
        user_games_with_points
      GROUP BY
        username
      ORDER BY
        9 DESC,
        8 DESC,
        6 DESC
    EOF
  end
end
