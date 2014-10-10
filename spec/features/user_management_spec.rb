require 'spec_helper'
require_relative 'helpers/sessions'

feature "User Signs up" do

	scenario "correctly" do
		sign_up
		expect(page).to have_content('Welcome, Test')
		expect(User.first.email).to eq("test@test.com")
	end

	scenario "As a user I must enter an email" do
		expect{sign_up("")}.to change(User, :count).by(0)
		expect(page).to have_content("The field email is mandatory")
	end

	scenario "As a user I must enter a unique email" do
		sign_out
		expect{sign_up("test@test.com")}.to change(User, :count).by(0)
		expect(page).to have_content("This email is already taken")
	end

	scenario "As a user I must enter an username" do
		visit '/'
		expect{sign_up("test@test.com", "Test", "")}.to change(User, :count).by(0)
		expect(page).to have_content("The field username is mandatory")
	end

	scenario "As a user I must enter a unique username" do
		sign_out
		expect{sign_up("test2@test.com", "Test2", "test_test")}.to change(User, :count).by(0)
		expect(page).to have_content("This username is already taken")
	end

	scenario "As a user I must enter a name" do
		visit '/'
		expect{sign_up("test@test.com", "")}.to change(User, :count).by(0)
		expect(page).to have_content("The field name is mandatory")
	end

	scenario "with a password that doesnt match" do 
		visit '/'
		expect{sign_up("test@test.com", "Test", "test_test", "12345", "67890")}.to change(User, :count).by(0)
		expect(page).to have_content("Password does not match the confirmation")
	end
end

feature "User sign out" do
	
	scenario "As a user I want to logout" do
		sign_out
		expect(page).to have_content("Good bye!")
	end
end

feature "User signs in" do
	before(:each) do
		User.create(:email => "test@test.com",
					:name =>"Test",
					:username => "test",
					:password => "test",
					:password_confirmation => "test")
	end

	scenario "with correct credentials" do
		visit '/'
		expect(page).not_to have_content("Welcome, Test")
		sign_in("test@test.com", "test")
	end
end










