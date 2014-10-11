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
end