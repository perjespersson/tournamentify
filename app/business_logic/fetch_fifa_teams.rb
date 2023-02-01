class FetchFifaTeams
  def initialize(url, edition)
    #This only works for fifaindex.com..
    @url = url
    @edition = edition
  end

  def fetch_all_teams
    fetch_teams('club')
    fetch_teams('mens_national')
    fetch_teams('womens_national')
  end

  private

  def url(page, type)
    return "#{@url}?page=#{page}" if type == 'club'
    return "#{@url}?page=#{page}&type=1" if type == 'mens_national'
    "#{@url}?page=#{page}&type=2" if type == 'womens_national'
  end

  def fetch_teams(type)
    @fetch ||= begin
      page = 1
      loop do
        begin
          read_page(Nokogiri::HTML(URI.open(url(page, type)).read).css("tbody"))
          # Get next page
          page += 1
        rescue OpenURI::HTTPError => ex
          # If we have reached the last page, exit the loop
          break
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
      fifa_team.edition = @edition
      fifa_team.save
    end
  end
end
