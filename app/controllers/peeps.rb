get '/peep/new' do
	erb :"peeps/new"
end

post '/peep/new' do
	@peep = Peep.create(:message =>params[:message], :message_timestamp => DateTime.now, :user_id => session[:user_id])
	if @peep
		redirect to '/'
	end
end