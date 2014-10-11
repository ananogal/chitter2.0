env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/chitter_#{env}")

require_relative './models/user'
require_relative './models/peep'

DataMapper.auto_upgrade!
DataMapper.finalize