require 'spec_helper'
require_relative 'helpers/sessions'

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
		sign_in("test@test.com", "test")
		click_link 'New peep'
		fill_in :message, :with =>"My first peep"
		click_button 'Peep'
		expect(Peep.first.message).to eq("My first peep")
	end


end