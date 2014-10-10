require 'bcrypt'

class User 
	include DataMapper::Resource

	attr_reader :password
	attr_accessor :password_confirmation

	property :id, Serial
	property :email, String
	property :name, String
	property :username, String
	property :password_digest, Text

	validates_presence_of :email, :message => "The field email is mandatory"
	validates_uniqueness_of :email, :message => "This email is already taken"
	validates_presence_of :username, :message => "The field username is mandatory"
	validates_uniqueness_of :username, :message => "This username is already taken"
	validates_presence_of :name, :message => "The field name is mandatory"
  	validates_confirmation_of :password
  	
  	def password=(password)
		@password = password
    	self.password_digest = BCrypt::Password.create(password)
  	end
end