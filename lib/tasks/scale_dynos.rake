namespace :scale_dynos do
  require 'heroku-api'
  desc "Scale UP dynos"
  task :up do
    #If it's a weekend day, scale the dyno to 1. If it's a day between Monday and Friday, scale to 2
    dyno_number = [6,0].include?(Time.now.wday) ? 1 : 2
    heroku = Heroku::API.new(:api_key => ENV['HEROKU_ACCOUNT_API_KEY'])
    heroku.post_ps_scale(ENV['HEROKU_APP_NAME'], 'web', dyno_number)
  end

  desc "Scale DOWN dynos"
  task :down do
    heroku = Heroku::API.new(:api_key => ENV['HEROKU_ACCOUNT_API_KEY'])
    heroku.post_ps_scale(ENV['HEROKU_APP_NAME'], 'web', 1)
  end

end