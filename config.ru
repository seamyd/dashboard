require 'dotenv'
Dotenv.load

require 'dashing'
require 'haml'

configure do
  set :auth_token, ENV['AUTH_TOKEN']

  helpers do
    def protected!
      unless authorized?
        response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
        throw(:halt, [401, "Not authorized\n"])
      end
    end

    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      ENV['AUTH_USER'] && ENV['AUTH_PASS'] && @auth.provided? && @auth.basic? &&
        @auth.credentials && @auth.credentials == [ENV['AUTH_USER'], ENV['AUTH_PASS']]
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

Sinatra::Application.set :erb, layout_engine: :haml

run Sinatra::Application
