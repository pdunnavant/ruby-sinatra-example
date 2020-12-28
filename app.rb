current_dir = Dir.pwd
Dir["#{current_dir}/models/*.rb"].each { |file| require file }
require 'sinatra'
require 'sinatra/activerecord'

set :port, 8080

# curl http://localhost:8080/users
get('/users') do
  output = ""
  users = Users.all
  users.to_json
end

# curl http://localhost:8080/user/1
get '/user/:id' do
  user = Users.find(params[:id])
  user.to_json
end

# curl -X POST http://localhost:8080/user -d 'user={"first_name":"Frodo","last_name":"Baggins"}'
post '/user' do
  json = JSON.parse(params[:user])
  user = Users.create(json)
  "Created: #{user.to_json}"
end

# curl -X DELETE http://localhost:8080/user/1
delete '/user/:id' do
  Users.destroy(params[:id])
  "Deleted: #{params[:id]}"
end
