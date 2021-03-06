
module SessionHelpers
	def sign_up(email="test@test.com", name="Test", username="test_test", 
					password = "test", password_confirmation="test")
		visit '/'
		click_link("Sign up")
		fill_in :email,  :with => email
		fill_in :name,  :with => name
		fill_in :username,  :with => username
		fill_in :password,  :with => password
		fill_in :password_confirmation, :with => password_confirmation
		click_button("Sign up")
	end

	def sign_out 
		sign_up
		click_button('Sign out')
	end

	def sign_in(email, password)
	    visit '/sessions/new'
	    fill_in :email, :with => email
	    fill_in :password, :with => password
	    click_button 'Sign in'
	end
end