module Email
	def send_message(user)
		@key = ENV["MAILGUN_KEY"]
		@link = ENV["RACK_ENV"] == 'production' ? "http://ana-bookmark.herokuapp.com/users/reset_password/#{user.password_token}" : "http://localhost:9292/users/reset_password/#{user.password_token}"
	  	RestClient.post "https://api:key-f5d241cef73c782ce37af4495eb72662"\
	  	"@api.mailgun.net/v2/sandboxa93399365f1a43b8957288725c6d03f1.mailgun.org/messages",
	  	:from => "Bookmark Manager <postmaster@sandboxa93399365f1a43b8957288725c6d03f1.mailgun.org>",
	  	:to => user.email,
	  	:subject => "Reset Password",
	  	:text => "Hi #{user.name}, 
You are receiving this email because you ask to reset your password.
Please follow this link #{@link} to continue with this process.

Best regards,
Chitter Team"
	end

end