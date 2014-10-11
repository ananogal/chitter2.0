require 'bcrypt'

class User 
	include DataMapper::Resource

	attr_reader :password
	attr_accessor :password_confirmation

	property :id, Serial
	property :email, String,  :required => true, :unique => true
	property :name, String,  :required => true
	property :username, String,  :required => true, :unique => true
	property :password_digest, Text
	property :password_token, Text
  	property :password_token_timestamp, Time

  	has n, :peeps

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

  	def self.authenticate(email, password)
		user = first(:email => email)
		if user && BCrypt::Password.new(user.password_digest) == password
			user
		else
			nil
		end
	end
end