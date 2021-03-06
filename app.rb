require("bundler/setup")
    Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }
#add also reload

get("/") do
  @teams = Team.all()
  @players = Player.all()
  erb(:index)
end

  delete('/teams') do
    team = Team.find(params.fetch('id').to_i)
    team.delete
    redirect("/")
  end

  patch('/teams') do
    team = Team.find(params.fetch('id').to_i)
    name = params.fetch('name')
    team.update({:name => name})
    redirect('/')
  end

post('/teams') do
  name = params.fetch('name')
  new_team = Team.create(:name => name)
  redirect('/')
end

post('/players') do
  team_id = params.fetch('team_id')
  name = params.fetch('name')
  new_player = Player.create(:name => name, :team_id => team_id)
  # new_url = '/teams/' + team_id --> Alternative method
  # redirect new_url --> alternative method
  redirect ("/teams/#{team_id}")
end

get("/teams/:id/?") do
  @add_home = params[:add_home]
  @add_away = params[:add_away]
  @add_result = params[:add_result]
  @team = Team.find(params.fetch('id').to_i)
  @teams= Team.all()
  @games = @team.game_as_team1 + @team.game_as_team2
  erb(:team)
end

  post("/games") do
    team1_id = params.fetch('team1_id')
    team2_id = params.fetch('team2_id')
    game = Game.create({:team1_id => team1_id, :team2_id => team2_id })
    self_id = params.fetch('self_id')
    redirect ("/teams/#{self_id}")
    end

  patch("/games") do
    game = Game.find(params.fetch('game_id').to_i())
    team1_score = params.fetch('team1_score')
    team2_score = params.fetch('team2_score')
    game.update({:team1_score => team1_score, :team2_score => team2_score })
    self_id = params.fetch('self_id')
    redirect ("/teams/#{self_id}")
  end
