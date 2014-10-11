require 'spec_helper'
require_relative 'helpers/sessions'

include SessionHelpers

feature "User Signs up" do

	scenario "correctly" do
		sign_up
		expect(page).to have_content('Welcome, Test')
		expect(User.first.email).to eq("test@test.com")
	end

	scenario "without an email" do
		expect{sign_up("")}.to change(User, :count).by(0)
		expect(page).to have_content("The field email is mandatory")
	end

	scenario "with a non unique email" do
		sign_out
		expect{sign_up("test@test.com")}.to change(User, :count).by(0)
		expect(page).to have_content("This email is already taken")
	end

	scenario "without an username" do
		visit '/'
		expect{sign_up("test@test.com", "Test", "")}.to change(User, :count).by(0)
		expect(page).to have_content("The field username is mandatory")
	end

	scenario "with a non unique username" do
		sign_out
		expect{sign_up("test2@test.com", "Test2", "test_test")}.to change(User, :count).by(0)
		expect(page).to have_content("This username is already taken")
	end

	scenario "without a name" do
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
	
	scenario "while being signed in" do
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
		expect(page).to have_content("Welcome, Test")
	end

	scenario "with incorrect credentials" do
		visit '/'
		expect(page).not_to have_content("Welcome, Test")
		sign_in("test@test.com", "something")
		expect(page).to have_content("The email or password is incorrect.")
	end
end

feature "User forgets password" do

	before(:each) do
		User.create(:email => "test@test.com",
					:name =>"Test",
					:username => "test",
					:password => "test",
					:password_confirmation => "test")
	end

	scenario "and enters a correct email" do
		send_email("test@test.com")
		expect(page).to have_content("We've just send you an email confirmation.")
	end

	scenario "and enter a incorrect email" do
		send_email("test11111@test.com")
		expect(page).to have_content("The email you enter is not correct.")
	end


	def send_email(email)
		visit '/users/forgotten'
		fill_in :email, :with =>email
		click_button 'Reset'
	end
end

feature "User follows the email link" do
	
	before(:each) do
		User.create(:email => "test@test.com",
					:name =>"Test",
					:username => "test",
					:password => "test",
					:password_confirmation => "test",
					:password_token =>"11112222333444555667778899",
					:password_token_timestamp => Time.now)
	end

	scenario "and has the correct token" do
		visit '/users/reset_password/11112222333444555667778899'
		expect(page).to have_content("Reset Password")
	end

	scenario "and doesnt have a correct token" do
		visit '/users/reset_password/11111111111'
		expect(page).to have_content("This token is not valid.")
		expect(page).not_to have_content("Reset Password")
	end

	scenario "and has a token older than 1 hour" do
		User.create(:email => "test2@test.com",
					:name =>"Test",
					:username => "test2",
					:password => "test",
					:password_confirmation => "test",
					:password_token =>"9999888877766655544433322211",
					:password_token_timestamp => Time.now - 60*60*2)
		visit '/users/reset_password/9999888877766655544433322211'
		expect(page).to have_content("This token is not valid anymore.")
		expect(page).not_to have_content("Reset Password")
	end 

	scenario "and enters password in the 2 fields correctly" do
		visit '/users/reset_password/11112222333444555667778899'
		expect(page).to have_content("Reset Password")
		fill_in :password, :with => 'newpw'
		fill_in :password_confirmation, :with => 'newpw'
		click_button("Reset")
		expect(page).to have_content("Welcome, Test")
	end

	scenario "and enters a password that doesnt match" do
		visit '/users/reset_password/11112222333444555667778899'
		expect(page).to have_content("Reset Password")
		fill_in :password, :with => 'newpw'
		fill_in :password_confirmation, :with => 'oldpw'
		click_button("Reset")
		expect(page).to have_content("Password does not match the confirmation")
	end
end










