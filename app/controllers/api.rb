get '/api/' do
	@user_json = ''
	if (session[:user_id])
		@user_json = User.get(session[:user_id])
	end

	@ids = Reply.all().map{|reply| reply.answer_id }
	@all_peeps = Peep.all(:id.not => @ids ,:order => [:created_at.desc])

	@peeps = @all_peeps.map do |peep| 
		@replies = Reply.all(:target_id => peep.id, :order =>[:answer_id.desc]).map{|reply| {:reply => reply.answer, :user =>reply.answer.user}}
		{:peep => peep, :user => peep.user, :replies =>@replies }
	end

	@return_obj = { :user => @user_json, :peeps => @peeps}
	@return_obj.to_json
end

post '/api/sessions/' do
	@data = JSON.parse(request.body.read)
	@user = User.authenticate(@data["email"], @data["password"])
	session[:user_id] = @user.id if(@user) 
	@user.to_json
end

post '/api/sessions/logout' do
	session[:user_id] = nil
	{:message => "Good bye!"}.to_json
end

post '/api/users/new/' do
	@data = JSON.parse(request.body.read)
	@user = User.create(:email => @data["email"], 
						:username => @data["username"],
						:name => @data["name"],
						:password =>@data["password"],
						:password_confirmation =>@data["password_confirmation"])

	session[:user_id] = @user.id if(@user) 
	@user.to_json
end

post '/api/peep/new' do
	@data = JSON.parse(request.body.read)
	@peep = Peep.create(:message =>@data["message"], :created_at => DateTime.now, :user_id => session[:user_id])
	@data.to_json
end