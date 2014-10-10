env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/chitter_#{env}")

require_relative './models/user'

DataMapper.auto_upgrade!
DataMapper.finalize