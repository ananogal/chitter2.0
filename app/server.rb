require 'sinatra'
require 'data_mapper'
require 'rack-flash'

require_relative "data_mapper_setup"

require_relative "controllers/application"
require_relative "controllers/users"

use Rack::Flash, :sweep =>true
enable :sessions
set :partial_template_engine, :erb