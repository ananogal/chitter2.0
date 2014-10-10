get '/' do
	@user = User.first(id = session[:user_id])
	erb :index
end