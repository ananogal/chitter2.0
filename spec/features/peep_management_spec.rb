require 'spec_helper'
require_relative 'helpers/sessions'
require_relative 'helpers/peeps'

include SessionHelpers
include PeepsHelper

feature "To post a peep" do

	before(:each) do
		User.create(:email => "test@test.com",
					:name =>"Test",
					:username => "test",
					:password => "test",
					:password_confirmation => "test")
	end

	scenario "user must be sign in" do
		visit '/'
		expect(page).not_to have_content("New peep")
		sign_in("test@test.com", "test")
		expect(page).to have_content("New peep")
	end

	scenario "user can access page to peep" do
		sign_in("test@test.com", "test")
		click_link 'New peep'
		expect(page).to have_content("Tell us what's on your mind!")
	end

	scenario "user enters a text" do
		create_peep("test@test.com", "test", "My first peep")
		expect(Peep.first.message).to eq("My first peep")
	end

	scenario "user enter peep and goes to homepage" do
		create_peep("test@test.com", "test", "My first peep")
		expect(page).to  have_content("What's going on...")
	end
end

feature "User browses the list of peeps" do
	
	before(:each) {
			User.create(:email => "test@test.com",
					:name =>"Test",
					:username => "test",
					:password => "test",
					:password_confirmation => "test")
			User.create(:email => "ana@test.com",
					:name =>"Ana",
					:username => "ana",
					:password => "ana",
					:password_confirmation => "ana")

			create_peep("test@test.com", "test", "My first peep")
			create_peep("ana@test.com", "ana", "My first peep")
			create_peep("test@test.com", "test", "My second peep")
			create_peep("ana@test.com", "ana", "My second peep")
		}

	scenario "when enter the homepage" do
		visit '/'
		expect(page).to have_content("What's going on...")
	end

end