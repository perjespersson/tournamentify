class FetchFifaTeams


  def fetch_all_teams
    fetch
  end

  private

  def url(page)
    "https://www.fifaindex.com/teams/fifa21_486/?page=#{page}"
  end

  def fetch
    @fetch ||= begin
      page = 1
      loop do
        begin
          read_page(Nokogiri::HTML(URI.open(url(page)).read).css("tbody"))
          # Get next page
          page += 1
        rescue OpenURI::HTTPError => ex
          if ex.message == '404 Not Found'
            puts "404 Not Found encountered, breaking the loop: Page: #{page}"
            break
          end
        end
      end
    end
  end

  def read_page(page)
    page.css("tr").each do |team|
      fifa_team = FifaTeam.new
      fifa_team.name = team.css("td[data-title='Name']").text
      fifa_team.league = team.css("td[data-title='League']").text
      fifa_team.attack = team.css("td[data-title='ATT']").text.to_i
      fifa_team.midfield = team.css("td[data-title='MID']").text.to_i
      fifa_team.defense = team.css("td[data-title='DEF']").text.to_i
      fifa_team.overall = team.css("td[data-title='OVR']").text.to_i
      fifa_team.save
    end
  end
end
