# ruby-sinatra-example

## Runbook For This App

## Generic Sinatra App Runbook
1. Install prerequisites (noted versions were used at time of writing -- older/newer versions may also work as well)
    * Ruby (2.6.3)
    * Bundler (2.2.3)
    * Sinatra (2.1.0)
2. Configure a simple Sinatra app (e.g. `hello world`)
    * Configure the app to connect to the/a database using active_support
3. Add a Model (e.g. ["User"](https://github.com/sinatra-activerecord/sinatra-activerecord) or "Item") which will be stored/managed in the database.
4. Automate/orchestrate the startup of the DB and the app
    * Doesn't need to be production ready, but us developers don't like running a ton of shell commands to run things.
