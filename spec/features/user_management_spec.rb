require 'spec_helper'

feature "User Signs in" do

	scenario "As a user I want to sign in" do
		visit '/'
		click_button("Sign in")
		fill_in :name,  :with => "name"
		fill_in :username,  :with => "username"
		fill_in :email,  :with => "email"
		fill_in :password,  :with =>"password"
		fill_in :password_confirmation, :with => "password"
		click_button("Sign in")
		expect(page).to have_content('Welcome, name')
		expect(User.first.email).to eq("email")
	end
end