require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require './app'

task :up do
  [
    "docker-compose up -d",
    "sleep 1",
    "rake db:create",
    "rake db:migrate",
    "APP_ENV=development ruby app.rb",
  ].each { |cmd|
    system(cmd)
  }
end

task :down do
  system("docker-compose down")
end
