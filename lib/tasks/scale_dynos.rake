namespace :scale_dynos do
  require 'heroku-api'
  desc "Scale UP dynos"
  task :up do
    heroku = Heroku::API.new(:api_key => ENV['HEROKU_ACCOUNT_API_KEY'])
    heroku.post_ps_scale(ENV['HEROKU_APP_NAME'], 'web', 2)
  end

  desc "Scale DOWN dynos"
  task :down do
    heroku = Heroku::API.new(:api_key => ENV['HEROKU_ACCOUNT_API_KEY'])
    heroku.post_ps_scale(ENV['HEROKU_APP_NAME'], 'web', 1)
  end

end