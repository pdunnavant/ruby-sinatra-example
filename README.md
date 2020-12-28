# ruby-sinatra-example

## Runbook For This App
1. Run `bundle install`.
2. Start Postgres (via docker) and run application by running `rake up`.
3. Seed some example data by running `rake db:seed`.
4. Example cURL commands to run while application is running:
  * Get all users: `curl http://localhost:8080/users`
  * Get single user: `curl http://localhost:8080/user/1`
  * Get all users: `curl -X POST http://localhost:8080/user -d 'user={"first_name":"Frodo","last_name":"Baggins"}'`
  * Get all users: `curl -X DELETE http://localhost:8080/user/1`
5. Stop Postgres and wipe all local testing data within DB by running `rake down`.

## Generic Sinatra App Runbook
1. Install prerequisites (noted versions were used at time of writing -- older/newer versions may also work as well)
    * Ruby (2.6.3)
      * Using a version manager to manage Ruby installations--such as [asdf](https://github.com/asdf-vm/asdf) or [rbenv](https://github.com/rbenv/rbenv)--is recommended.
    * Bundler (2.2.3)
      * `gem install bundler`
    * [docker](https://docs.docker.com/get-docker/) (20.10.1)
    * [docker-compose](https://docs.docker.com/compose/install/) (1.27.4)
2. Create a `Gemfile` in the root of your project with the following contents:
```
source 'https://rubygems.org'

gem 'activesupport', '= 6.1.0'
gem 'pg', '= 1.2.3'
gem 'rake', '= 13.0.3'
gem 'sinatra', '= 2.1.0'
gem 'sinatra-activerecord', '= 2.0.21'
```
3. Download gem dependencies specified within the `Gemfile`.
```
# bundle install
```
4. Create a `docker-compose.yml` file in the root of your project with the following contents:
```
version: '3.8'

services:
  postgres:
    container_name: 'postgres'
    image: 'postgres:13.1'
    restart: 'always'
    ports:
      - '5432:5432'
    environment:
      - POSTGRES_USER=test
      - POSTGRES_PASSWORD=test
```
5. Create a `Rakefile` file in the root of your project with the following contents:
```
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
```
6. Set up database connection settings by creating a new `config/database.yml` file within your project with the following contents:
```
development:
  adapter: postgresql
  encoding: unicode
  database: ruby_sinatra_example
  pool: 2
  host: localhost
  username: test
  password: test
```
6. Set up database migration to create initial table, e.g.:
```
# rake db:create_migration NAME=create_users
```
7. This will generate a file in `./db/migrate` named `<TIMESTAMP>_create_users.rb`. Edit this file to create the desired table, e.g.:
```
class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
    end
  end
end
```
8. Set up a simple model by adding the following to `./models/users.rb`:
```
require 'active_record'

class Users < ActiveRecord::Base
end
```
9. Set up a few simple routes by creating an `app.rb` file in the root of your project with the following contents:
```
current_dir = Dir.pwd
Dir["#{current_dir}/models/*.rb"].each { |file| require file }
require 'sinatra'
require 'sinatra/activerecord'

set :port, 8080

get('/users') do
  output = ""
  users = Users.all
  users.to_json
end

get '/user/:id' do
  user = Users.find(params[:id])
  user.to_json
end

post '/user' do
  json = JSON.parse(params[:user])
  user = Users.create(json)
  "Created: #{user.to_json}"
end

delete '/user/:id' do
  Users.destroy(params[:id])
  "Deleted: #{params[:id]}"
end
```
10. To run Postgres and the application:
```
# rake up
```
  * Press CTRL-C or CMD-C to stop the application.
11. To stop Postgres and wipe all local DB data:
```
# rake down
```
12. Example cURL commands to run while application is running:
  * Get all users: `curl http://localhost:8080/users`
  * Get single user: `curl http://localhost:8080/user/1`
  * Get all users: `curl -X POST http://localhost:8080/user -d 'user={"first_name":"Frodo","last_name":"Baggins"}'`
  * Get all users: `curl -X DELETE http://localhost:8080/user/1`
