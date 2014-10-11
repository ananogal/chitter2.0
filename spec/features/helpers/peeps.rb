module PeepsHelper
	def create_peep(email, password, message)
		sign_in(email, password)
		click_link 'New peep'
		fill_in :message, :with => message
		click_button 'Peep'
	end
end