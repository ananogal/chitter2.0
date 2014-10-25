get '/api/' do
	@user_json = ''
	if (session[:user_id])
		@user_json = User.get(session[:user_id])
	end
	@replies = Reply.all()
	@ids = []
	@replies.each {|replay| @ids << replay.answer_id }
	@peeps = Peep.all(:id.not => @ids ,:order => [:created_at.desc])

	@return_obj = { :user => @user_json, :peeps => @peeps}
	@return_obj.to_json
end

get '/api/users/:id' do
	@user = User.get(params[:id])
	@user.to_json
end

get '/api/repies/:id' do
	@replies = Reply.all(:target_id => params[:id], :order => [:answer_id.desc])
	@replies.to_json
end

get '/api/peeps/:id' do
	@peep = Peep.get(params[:id])
	@peep.to_json
end