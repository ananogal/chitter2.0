require 'sinatra'
require 'data_mapper'
require 'rack-flash'
require 'sinatra/partial'
require 'rest-client'

require_relative "data_mapper_setup"

require_relative "controllers/application"
require_relative "controllers/users"
require_relative "controllers/sessions"
require_relative "controllers/peeps"

require_relative 'helpers/application'
require_relative 'helpers/mailgun'

include Email

use Rack::Flash, :sweep =>true
enable :sessions
set :partial_template_engine, :erb