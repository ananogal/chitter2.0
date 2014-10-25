require 'spec_helper'
require_relative 'helpers/sessions'
require_relative 'helpers/peeps'

include SessionHelpers
include PeepsHelper

feature "When asked for the api" do

	scenario "should return all peeps in DataBase" do
		@user1 = User.create(:email => "test@test.com",
				:name =>"Test",
				:username => "test",
				:password => "test",
				:password_confirmation => "test")
		@user2 = User.create(:email => "ana@test.com",
				:name =>"Ana",
				:username => "ana",
				:password => "ana",
				:password_confirmation => "ana")

		Peep.create(:message =>"Test first peep", :created_at => DateTime.now, :user_id => @user1.id)
		Peep.create(:message =>"Ana first peep", :created_at => DateTime.now, :user_id => @user2.id)
		Peep.create(:message =>"Test second peep", :created_at => DateTime.now, :user_id => @user1.id)
		Peep.create(:message =>"Ana second peep", :created_at => DateTime.now, :user_id => @user2.id)

		visit '/api/'
		expect(page).to have_content('peeps":[{')
	end
end