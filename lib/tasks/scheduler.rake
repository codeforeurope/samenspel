require 'heroku-api'
desc "Scale UP dynos"
task :spin_up => :environment do
  heroku = Heroku::API.new(:api_key => 'HEROKU_ACCOUNT_API_KEY')
  heroku.post_ps_scale(ENV['HEROKU_APP_NAME'], 'web', 2)
end

desc "Scale DOWN dynos"
task :spin_down => :environment do
  heroku = Heroku::API.new(:api_key => 'HEROKU_ACCOUNT_API_KEY')
  heroku.post_ps_scale(ENV['HEROKU_APP_NAME'], 'web', 1)
end