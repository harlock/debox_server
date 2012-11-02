require 'sinatra'
require 'sinatra/namespace'
require 'sinatra/json'
require 'yaml'
require 'fileutils'
require 'erb'
require "debox_server/version"
require "debox_server/utils"
require "debox_server/config"
require "debox_server/users"
require "debox_server/recipes"
require "debox_server/basic_auth"

# TODO get root without the ../
DEBOX_ROOT = File.join(File.dirname(__FILE__), '../')

module DeboxServer

  module App
    include DeboxServer::Config
    include DeboxServer::Users
    include DeboxServer::Recipes
  end

  class HTTP < Sinatra::Base
    include DeboxServer::BasicAuth

    set :root, DEBOX_ROOT

    require 'rack'
    include DeboxServer::App
    register Sinatra::Namespace
    helpers Sinatra::JSON

    # TODO auto reload please!!
    configure :development do
      use Rack::Reloader
    end

    get "/" do
      "debox"
    end

    # Return the api_key for the user
    post "/api_key" do
      user = login_user(params[:user], params[:password])
      throw(:halt, [401, "Not authorized\n"]) unless user
      user[:api_key]
    end

    # API
    #----------------------------------------------------------------------

    # Require api_key
    before '/api/*'  do
      authenticate!
    end

    namespace '/api' do
      # Return a list with users in the system
      get '/users' do
        json users_config.keys
      end

      # Users
      #----------------------------------------------------------------------

      post '/users/create' do
        user = add_user params[:user], params[:password]
        throw(:halt, [400, "Unvalid request\n"]) unless user
        "ok"
      end

      # receipes
      #----------------------------------------------------------------------

      get "/recipes/:app/:env/new" do
        new_recipe params[:app], params[:env]
      end

      post "/recipes/:app/:env/create" do
        create_recipe params[:app], params[:env], params[:content]
        "ok"
      end

      # deploy
      #----------------------------------------------------------------------

      # Deploy an app
      post "/deploy/:app" do
        "Deploing #{params[:app]}"
      end

    end
  end

end
